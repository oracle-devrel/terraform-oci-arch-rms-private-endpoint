## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// The RMS private endpoint resource. Requires a VCN with a private subnet
resource "oci_resourcemanager_private_endpoint" "rms_pe" {
  provider       = oci.current_region
  compartment_id = var.compartment_ocid
  display_name   = var.private_endpoint_display_name
  description    = "Private Endpoint to remote-exec in Private Instance"
  vcn_id         = oci_core_vcn.rms_pe_vcn.id
  subnet_id      = oci_core_subnet.rms_pe_subnet.id
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
