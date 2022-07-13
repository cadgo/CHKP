variable "default_tags" {
  default = {
    Environment = "Lab Pichincha"
    Owner = "cdz"
  }
  description = "Defaul Tags"
  type = map(string)
}

variable "vpc_protected1" {
    default = "172.44.0.0/16"
  
}

variable "aws_region"{
  description = "Region to use"
  default = "us-east-1"
}

variable "key_lab"{
  description = "Lab Key for access instances"
  default = "lab"
}

variable "IPSource"{
  default = "189.216.168.60"
}
#variable "AZ"{
#  description = "Availibity Zones"
#  type = list(string)
#  default = ["${aws_region}a", "${aws_region}b"]
#}
