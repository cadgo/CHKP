variable "SecNet"{
  description = "Security Netwrok"
  default = {
    "subnet" = "10.200.30.0"
    "mask" = "24"
    "name" = "SecNet"
  }
}

variable "NotTrustNetwork" {
  description = "Not Trusted Network"
  default = {
    "subnet" = "10.33.89.0"
    "mask" = "24"
    "name" = "NotTrustNetwork"
  }
}

variable "K8s1" {
  default = {
    "name" = "K8Cluster1"
    "IP" = "10.200.30.2"
  }
}

variable "K8s2" {
  default = {
    "name" = "K8Cluster2"
    "IP" = "10.33.80.2"
  }
}
