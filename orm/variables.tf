## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}

variable "vcn_display_name" {
  default = "testVCN"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "subnet_display_name" {
  default = "testPrivateSubnet"
}

variable "instance_display_name" {
  default = "testCreatePrivateEndpointInstance"
}

variable "private_endpoint_display_name" {
  default = "testResourceManagerPrivateEndpoint"
}

variable "availability_domain_name" {
  default = null
}

## Instance

variable "instance_shape" {
  default = "VM.Standard.E4.Flex"
}

variable "instance_shape_config_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 16
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "8"
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

# Dictionary Locals
locals {
  is_flexible_node_shape  = contains(local.compute_flexible_shapes, var.instance_shape)
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex"
  ]
}
