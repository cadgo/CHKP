
terraform {
  required_providers {
    checkpoint = {
      source  = "checkpointsw/checkpoint"
      version = "~> 1.6.0"
    }
  }
}
#rules Section
#inbound sections
resource "checkpoint_management_access_rule" "httpsaccess" {
  name = "https acess"
  layer = "Network"
  position = { bottom = "inbound rules" }
  source = ["Any"]
  destination = ["servidor1"]
  action = "Accept"
  service = ["http"]
  track = { type = "Log" }
}


resource "checkpoint_management_access_rule" "sshaccess" {
  name = "ssh access"
  layer = "Network"
  position = { above = "outbound" }
  source = ["Any"]
  destination = ["servidor1","servidor2","servidor3"]
  action = "Accept"
  service = ["ssh"]
  track = { type = "Log" }
}
#
#Outbound Section
resource "checkpoint_management_access_rule" "rule1" {
  name = "rule 1"
  layer = "Network"
  position = { below = "inter vpc" }
  source = ["SecNet"]
  destination = ["NotTrustNetwork"]
  action = "Accept"
  service = ["YouTube"]
  track = { type = "Log" }
}


resource "checkpoint_management_access_rule" "badstuff" {
  name = "badstuff"
  layer = "Network"
  position = { below = "outbound" }
  source = ["SecNet"]
  destination = ["Internet"]
  action = "Drop"
  service = ["BadStuff"]
  track = { type = "Log" }
}


resource "checkpoint_management_access_rule" "apt" {
  name = "Apt Updates"
  layer = "Network"
  position = { bottom = "bottom" }
  source = ["SecNet"]
  destination = ["Internet"]
  action = "Accept"
  service = ["Apt-get"]
  track = { type = "Log" }
}


resource "checkpoint_management_access_rule" "updates" {
  name = "updates"
  layer = "Network"
  position = { bottom = "bottom" }
  source = ["SecNet"]
  destination = ["Internet"]
  action = "Accept"
  service = ["Software Update"]
  track = { type = "Log" }
}

###CLEANUP
resource "checkpoint_management_access_rule" "drop" {
  name = "cleanup"
  layer = "Network"
  position = { bottom = "bottom" }
  source = ["Any"]
  destination = ["Any"]
  action = "Drop"
  service = ["Any"]
  track = { type = "Log" }
}
