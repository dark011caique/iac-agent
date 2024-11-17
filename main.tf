provider "oci" {
  tenancy_ocid = "<YOUR_TENANCY_OCID>"
  user_ocid    = "<YOUR_USER_OCID>"
  fingerprint  = "<YOUR_FINGERPRINT>"
  private_key_path = "<PATH_TO_YOUR_PRIVATE_KEY>"
  region       = "<YOUR_REGION>"
}

resource "oci_core_vcn" "vcn" {
  cidr_block = "10.0.0.0/16"
  display_name = "TFVCN"
  compartment_id = "<YOUR_COMPARTMENT_OCID>"
}

resource "oci_core_subnet" "subnet" {
  cidr_block = "10.0.1.0/24"
  vcn_id = oci_core_vcn.vcn.id
  display_name = "TFSubnet"
  compartment_id = "<YOUR_COMPARTMENT_OCID>"
}

resource "oci_core_instance" "instance" {
  availability_domain = "<YOUR_AVAILABILITY_DOMAIN>"
  compartment_id = "<YOUR_COMPARTMENT_OCID>"
  shape = "VM.Standard2.1"
  display_name = "TFInstance"
  create_vnic_details {
    subnet_id = oci_core_subnet.subnet.id
  }
  metadata = {
    ssh_authorized_keys = file("../chave/id-agent.pub")
  }
  source_details {
    source_type = "image"
    source_id = "<YOUR_LINUX_IMAGE_OCID>"
  }
}
