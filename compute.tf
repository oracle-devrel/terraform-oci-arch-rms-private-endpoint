## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Compute instance that our SSH connection will be established with.
resource "oci_core_instance" "privateinstance" {
  provider            = oci.current_region
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  availability_domain = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number], "name") : var.availability_domain_name
  shape               = var.instance_shape
  // specify the subnet and that there is no public IP assigned to the instance
  create_vnic_details {
    subnet_id        = oci_core_subnet.rms_pe_subnet.id
    assign_public_ip = false
  }
  extended_metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  // use latest oracle linux image via data source
  source_details {
    source_id   = data.oci_core_images.InstanceImageOCID.images[0].id
    source_type = "image"
  }

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.instance_shape_config_memory_in_gbs
      ocpus         = var.instance_shape_config_ocpus
    }
  }

  defined_tags        = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
