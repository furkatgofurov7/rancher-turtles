//go:build !ignore_autogenerated

/*
Copyright © 2023 - 2024 SUSE LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by controller-gen. DO NOT EDIT.

package v1

import (
	runtime "k8s.io/apimachinery/pkg/runtime"
)

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ETCDSnapshotFile) DeepCopyInto(out *ETCDSnapshotFile) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
	in.Spec.DeepCopyInto(&out.Spec)
	in.Status.DeepCopyInto(&out.Status)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ETCDSnapshotFile.
func (in *ETCDSnapshotFile) DeepCopy() *ETCDSnapshotFile {
	if in == nil {
		return nil
	}
	out := new(ETCDSnapshotFile)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *ETCDSnapshotFile) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ETCDSnapshotFileList) DeepCopyInto(out *ETCDSnapshotFileList) {
	*out = *in
	out.TypeMeta = in.TypeMeta
	in.ListMeta.DeepCopyInto(&out.ListMeta)
	if in.Items != nil {
		in, out := &in.Items, &out.Items
		*out = make([]ETCDSnapshotFile, len(*in))
		for i := range *in {
			(*in)[i].DeepCopyInto(&(*out)[i])
		}
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ETCDSnapshotFileList.
func (in *ETCDSnapshotFileList) DeepCopy() *ETCDSnapshotFileList {
	if in == nil {
		return nil
	}
	out := new(ETCDSnapshotFileList)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyObject is an autogenerated deepcopy function, copying the receiver, creating a new runtime.Object.
func (in *ETCDSnapshotFileList) DeepCopyObject() runtime.Object {
	if c := in.DeepCopy(); c != nil {
		return c
	}
	return nil
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ETCDSnapshotS3) DeepCopyInto(out *ETCDSnapshotS3) {
	*out = *in
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ETCDSnapshotS3.
func (in *ETCDSnapshotS3) DeepCopy() *ETCDSnapshotS3 {
	if in == nil {
		return nil
	}
	out := new(ETCDSnapshotS3)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ETCDSnapshotSpec) DeepCopyInto(out *ETCDSnapshotSpec) {
	*out = *in
	if in.Metadata != nil {
		in, out := &in.Metadata, &out.Metadata
		*out = make(map[string]string, len(*in))
		for key, val := range *in {
			(*out)[key] = val
		}
	}
	if in.S3 != nil {
		in, out := &in.S3, &out.S3
		*out = new(ETCDSnapshotS3)
		**out = **in
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ETCDSnapshotSpec.
func (in *ETCDSnapshotSpec) DeepCopy() *ETCDSnapshotSpec {
	if in == nil {
		return nil
	}
	out := new(ETCDSnapshotSpec)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *ETCDSnapshotStatus) DeepCopyInto(out *ETCDSnapshotStatus) {
	*out = *in
	if in.ReadyToUse != nil {
		in, out := &in.ReadyToUse, &out.ReadyToUse
		*out = new(bool)
		**out = **in
	}
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new ETCDSnapshotStatus.
func (in *ETCDSnapshotStatus) DeepCopy() *ETCDSnapshotStatus {
	if in == nil {
		return nil
	}
	out := new(ETCDSnapshotStatus)
	in.DeepCopyInto(out)
	return out
}