
terraform {
  required_providers {
    checkpoint = {
      source  = "checkpointsw/checkpoint"
      version = "~> 1.6.0"
    }
  }
}
# Create network object
resource "checkpoint_management_network" "network1" {
  name         = "${var.SecNet.name}"
  subnet4      = "${var.SecNet.subnet}"
  mask_length4 = "${var.SecNet.mask}"
}

resource "checkpoint_management_network" "network2" {
  name         = "${var.NotTrustNetwork.name}"
  subnet4      = "${var.NotTrustNetwork.subnet}"
  mask_length4 = "${var.NotTrustNetwork.mask}"
}

#Create specific hosts objects
resource "checkpoint_management_host" "servidor1" {
  name = "servidor1"
  ipv4_address = "10.200.30.5"
}

resource "checkpoint_management_host" "servidor2" {
  name = "servidor2"
  ipv4_address = "10.200.30.6"
}

resource "checkpoint_management_host" "servidor3" {
  name = "servidor3"
  ipv4_address = "10.200.30.7"
}

#Create Rules in sections
resource "checkpoint_management_access_section" "inboundrules"{
  name = "inbound rules"
  layer = "Network"
  position = { top = "top" }
}

resource "checkpoint_management_access_section" "outbound" {
  name = "outbound"
  layer = "Network"
  position = { bottom = "bottom" }
}

resource "checkpoint_management_access_section" "intervpc" {
  name = "inter vpc"
  layer = "Network"
  position = { top = "top" }
}



