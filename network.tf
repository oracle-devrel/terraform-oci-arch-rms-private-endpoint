## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// VCN holding the private subnet
resource "oci_core_vcn" "rms_pe_vcn" {
  provider       = oci.current_region
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

// Private subnet the compute instance will reside in
resource "oci_core_subnet" "rms_pe_subnet" {
  provider                   = oci.current_region
  compartment_id             = var.compartment_ocid
  display_name               = var.subnet_display_name
  vcn_id                     = oci_core_vcn.rms_pe_vcn.id
  prohibit_public_ip_on_vnic = true
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 1)
  security_list_ids          = [oci_core_security_list.rms_pe_sec_list.id]
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "rms_pe_sec_list" {
  provider       = oci.current_region
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rms_pe_vcn.id
  display_name   = "Allow SSH Communication Security List"
  // Lock down ingress and egress traffic to the VCN cidr block. Can be restricted further to be subnet cidr range
  // Only allow SSH communication on specific port
  ingress_security_rules {
    tcp_options {
      min = 22
      max = 22
    }

    protocol = 6
    source   = var.vcn_cidr
  }
  egress_security_rules {
    tcp_options {
      min = 22
      max = 22
    }

    protocol    = 6
    destination = var.vcn_cidr
  }
  defined_tags        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
