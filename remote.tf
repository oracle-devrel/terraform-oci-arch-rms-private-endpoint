## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Resource to establish the SSH connection. Must have the compute instance created first.
resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.privateinstance,oci_identity_policy.ormpolicy]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "8m"
      host        = data.oci_resourcemanager_private_endpoint_reachable_ip.rms_pe_reachable_ip_address.ip_address
      user        = "opc"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    // write to a file on the compute instance via the private access SSH connection
    inline = [
      "hostname",
      "echo 'remote exec showcase ' > ~/remoteExecTest.txt",
      "echo '-------------Reading from file remoteExecTest.txt ----------------- '",
      "cat ~/remoteExecTest.txt",
      "echo '-------------Reading from file remoteExecTest.txt ----------------- '"
    ]
  }
}

