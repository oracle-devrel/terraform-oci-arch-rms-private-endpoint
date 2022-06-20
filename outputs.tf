## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "private_endpoint" {
  description = "The returned resource attributes for the private endpoint."
  value       = oci_resourcemanager_private_endpoint.rms_pe
}


