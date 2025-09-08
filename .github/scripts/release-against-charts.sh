#!/bin/sh
#
# Bumps Webhook version in a locally checked out rancher/charts repository
#
# Usage:
#   ./release-against-charts.sh <path to charts repo> <prev webhook release> <new webhook release>
#
# Example:
# ./release-against-charts.sh "${GITHUB_WORKSPACE}" "v0.5.0-rc.13" "v0.5.0-rc.14"

CHARTS_DIR=$1
PREV_TURTLES_VERSION="$2"   # e.g. 0.23.0-rc.0
NEW_TURTLES_VERSION="$3"    # e.g. 0.23.0
# PREV_CHART_VERSION="$3"   # e.g. 101.2.0
# NEW_CHART_VERSION="$4"
#REPLACE="$3"              # remove previous version if `true`, otherwise add new
# VERSION_OVERRIDE="$3"     # e.g. auto, patch, minor
# MULTI_RC="$4"             # e.g. true, false
# NEW_CHART="$5"            # e.g. true, false

# CHARTS_DIR=${CHARTS_DIR-"$(dirname -- "$0")/../../../charts"}

usage() {
    cat <<EOF
Usage:
  $0 <path to charts repo> <prev rancher turtles release> <new rancher turtles>
EOF
}

bump_patch() {
    version=$1
    major=$(echo "$version" | cut -d. -f1)
    minor=$(echo "$version" | cut -d. -f2)
    patch=$(echo "$version" | cut -d. -f3)
    new_patch=$((patch + 1))
    echo "${major}.${minor}.${new_patch}"
}

validate_version_format() {
    version=$1
    if ! echo "$version" | grep -qE '^v[0-9]+\.[0-9]+\.[0-9]+(-rc\.[0-9]+)?$'; then
        echo "Error: Version $version must be in the format v<major>.<minor>.<patch> or v<major>.<minor>.<patch>-rc.<number>"
        exit 1
    fi
}

if [ -z "$CHARTS_DIR" ] || [ -z "$PREV_TURTLES_VERSION" ] || [ -z "$NEW_TURTLES_VERSION" ]; then
    usage
    exit 1
fi

validate_version_format "$PREV_TURTLES_VERSION"
validate_version_format "$NEW_TURTLES_VERSION"

if echo "$PREV_TURTLES_VERSION" | grep -q '\-rc'; then
    is_prev_rc=true
else
    is_prev_rc=false
fi

if [ "$PREV_TURTLES_VERSION" = "$NEW_TURTLES_VERSION" ]; then
    echo "Previous and new rancher turtles version are the same: $NEW_TURTLES_VERSION, but must be different"
    exit 1
fi

# Remove the prefix v because the chart version doesn't contain it
PREV_TURTLES_VERSION_SHORT=$(echo "$PREV_TURTLES_VERSION" | sed 's|^v||')  # e.g. 0.5.2-rc.3
NEW_TURTLES_VERSION_SHORT=$(echo "$NEW_TURTLES_VERSION" | sed 's|^v||')  # e.g. 0.5.2-rc.4

set -ue

cd "${CHARTS_DIR}"

# Validate the given turtles version (eg: 0.5.0-rc.13)
if ! grep -q "${PREV_TURTLES_VERSION_SHORT}" ./packages/rancher-turtles/package.yaml; then
    echo "Previous turtles version references do not exist in ./packages/rancher-turtles/. The content of the file is:"
    cat ./packages/rancher-turtles/package.yaml
    exit 1
fi

# Get the chart version (eg: 104.0.0)
if ! PREV_CHART_VERSION=$(yq '.version' ./packages/rancher-turtles/package.yaml); then
    echo "Unable to get chart version from ./packages/rancher-turtles/package.yaml. The content of the file is:"
    cat ./packages/rancher-turtles/package.yaml
    exit 1
fi

if [ "$is_prev_rc" = "false" ]; then
    NEW_CHART_VERSION=$(bump_patch "$PREV_CHART_VERSION")
else
    NEW_CHART_VERSION=$PREV_CHART_VERSION
fi

sed -i "s/${PREV_TURTLES_VERSION_SHORT}/${NEW_TURTLES_VERSION_SHORT}/g" ./packages/rancher-turtles/package.yaml
sed -i "s/${PREV_CHART_VERSION}/${NEW_CHART_VERSION}/g" ./packages/rancher-turtles/package.yaml

git add packages/rancher-turtles
git commit -m "Bump rancher-turtles to $NEW_TURTLES_VERSION"

PACKAGE=rancher-turtles make charts
git add ./assets/rancher-turtles ./charts/rancher-turtles index.yaml
git commit -m "make charts"

# Prepends to list
yq --inplace ".rancher-turtles = [\"${NEW_CHART_VERSION}+up${NEW_TURTLES_VERSION_SHORT}\"] + .rancher-turtles" release.yaml

git add release.yaml
git commit -m "Add rancher-turtles ${NEW_CHART_VERSION}+up${NEW_TURTLES_VERSION_SHORT} to release.yaml"

# pushd "${CHARTS_DIR}" > /dev/null

# if [ -f packages/rancher-turtles/package.yaml ];  then
#     # Use new auto bump scripting until the Github action CI works as expected
#     # no parameters besides the target branch are needed in theory, but the pr
#     # creation still needs the new Chart and Turtles version
#     #make pull-scripts
#     # make chart-bump package=rancher-turtles branch="$(git rev-parse --abbrev-ref HEAD)"
#     make chart-bump package=rancher-turtles branch="$(git rev-parse --abbrev-ref HEAD)"
#     #LOG="DEBUG" ./bin/charts-build-scripts chart-bump --package="rancher-turtles" --branch="dev-v2.12"  --override="${VERSION_OVERRIDE}" --multi-rc="${MULTI_RC}" --new-chart="${NEW_CHART}"

#     if [ "${REPLACE}" == "true" ] && [ -f "assets/rancher-turtles/rancher-turtles-${PREV_CHART_VERSION}+up${PREV_TURTLES_VERSION}.tgz" ]; then
#         for i in rancher-turtles; do
#             CHART=$i VERSION=${PREV_CHART_VERSION}+up${PREV_TURTLES_VERSION} make remove
#         done
#         git add assets/rancher-turtles* charts/rancher-turtles* index.yaml
#         git commit -m "Remove Turtles ${PREV_CHART_VERSION}+up${PREV_TURTLES_VERSION}"
#         git checkout release.yaml   # reset unwanted changes to release.yaml, relevant ones are already part of the previous commit
#     fi
# else
#     # For Rancher versions before 2.10 run the legacy implementation
#     if [ ! -f bin/charts-build-scripts ]; then
#         make pull-scripts
#     fi

#     if grep -q "version: ${PREV_CHART_VERSION}" ./packages/rancher-turtles/package.yaml && grep -q "${PREV_TURTLES_VERSION}" ./packages/rancher-turtles/package.yaml; then
#         find ./packages/rancher-turtles/ -type f -exec sed -i -e "s/${PREV_TURTLES_VERSION}/${NEW_TURTLES_VERSION="$2"    # e.g. 0.23.0
# }/g" {} \;
#         find ./packages/rancher-turtles/ -type f -exec sed -i -e "s/version: ${PREV_CHART_VERSION}/version: ${NEW_CHART_VERSION}/g" {} \;
#     else
#         echo "Previous Turtles version references do not exist in ./packages/rancher-turtles/ so replacing it with the new version is not possible. Exiting..."
#         exit 1
#     fi

#     for i in rancher-turtles; do
#         yq --inplace "del( .${i}.[] | select(. == \"${PREV_CHART_VERSION}+up${PREV_TURTLES_VERSION}\") )" release.yaml
#         yq --inplace ".${i} += [\"${NEW_CHART_VERSION}+up${NEW_TURTLES_VERSION="$2"    # e.g. 0.23.0
# }\"]" release.yaml
#     done
#     # Sort keys in release.yaml
#     yq -i -P 'sort_keys(..)' release.yaml

#     # Adapt Gitjob version in generated patch
#     if grep -q '^-  version: ' ./packages/rancher-turtles/generated-changes/patch/Chart.yaml.patch; then
#         GITJOB_VERSION=$(curl -s "https://raw.githubusercontent.com/rancher/turtles/v${NEW_TURTLES_VERSION="$2"    # e.g. 0.23.0
# }/charts/rancher-turtles/gitjob/Chart.yaml" | yq e .version)
#         sed -i -e "s/^-  version: .*$/-  version: ${GITJOB_VERSION}/" ./packages/rancher-turtles/generated-changes/patch/Chart.yaml.patch
#     fi

#     git add packages/rancher-turtles release.yaml
#     git commit -m "Updating to Turtles v${NEW_TURTLES_VERSION="$2"    # e.g. 0.23.0
# }"

#     if [ "${REPLACE}" == "true" ]; then
#         for i in rancher-turtles; do
#             CHART=$i VERSION=${PREV_CHART_VERSION}+up${PREV_TURTLES_VERSION} make remove
#         done
#     fi

#     PACKAGE=rancher-turtles make charts
#     git checkout release.yaml   # reset unwanted changes to release.yaml, relevant ones are already part of the previous commit
#     git add assets/rancher-turtles* charts/rancher-turtles* index.yaml
#     git commit -m "Autogenerated changes for Turtles v${NEW_TURTLES_VERSION="$2"    # e.g. 0.23.0
# }"
# fi

# PACKAGE=rancher-turtles make validate

# popd > /dev/null
