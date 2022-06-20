## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_availability_domains" "ADs" {
  provider       = oci.current_region
  compartment_id = var.tenancy_ocid
}

# Gets home and current regions

data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
  provider   = oci.current_region
}

data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }

  provider = oci.current_region
}

data "oci_identity_regions" "current_region" {
  filter {
    name   = "name"
    values = [var.region]
  }
  provider = oci.current_region
}

data "oci_core_images" "InstanceImageOCID" {
  provider                 = oci.current_region
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

// Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
data "oci_resourcemanager_private_endpoint_reachable_ip" "rms_pe_reachable_ip_address" {
  provider            = oci.current_region
  private_endpoint_id = oci_resourcemanager_private_endpoint.rms_pe.id
  private_ip          = oci_core_instance.privateinstance.private_ip
}