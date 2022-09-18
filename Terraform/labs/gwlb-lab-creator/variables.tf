variable "tgw-name"{
  type = string
  description = "tgw lab name"
  default = "tgw1"
}
variable "deploy_instances"{
  type = bool
  description = "deploy instances or not"
  default = true
}
variable "public_ami"{
  type = string
  description = "ami used for public subnets"
  default = "ami-0d5a1db7ddd7dddde"
}

variable "private_ami"{
  type = string
  description = "ami used for private subnets"
  default = "ami-052efd3df9dad4825"
}
variable "network_acl"{
  type = bool
  description = "aws vpc module network acl true or false"
  default = true
}
variable "enable_nat_gw"{
  type = bool
  description = "enable nat gw for private subnets"
  default = false
}

variable "region"{
  type = string
  description = "region"
  default = "us-east-1"
}

variable "list_region"{
  type = list(string)
  description = "list of region used by locals"
}
variable "enable_vpn_gateway"{
  type = bool
  description = "ennable vpc gw for lab"
  default = false
}

variable "cidr_vpc1" {
  type = string
  description = "vpc_1 cidr"
}

variable "public_subnets_vpc1"{
  type = list(string)
  description = "vpc_1 public subnets"
}

variable "private_subnets_vpc1"{
  type = list(string)
  description = "vpc_1 private subnets"
}

variable "tgwconnection_subnets_vpc1"{
  type = list(string)
  description = "vpc_1 Subnets where the TGW Attachment lives used for routing private subnet to TGW and GWLB Fw"
}

variable "endpoint_subnets_vpc1"{
  type = list(string)
  description = "vpc_1 subnets where the endpoint lives used for internet to public subnet"
}

variable "cidr_vpc2" {
  type = string
  description = "vpc_2 cidr"
}

variable "public_subnets_vpc2"{
  type = list(string)
  description = "vpc_2 public subnets"
}

variable "private_subnets_vpc2"{
  type = list(string)
  description = "vpc_2 private subnets"
}

variable "tgwconnection_subnets_vpc2"{
  type = list(string)
  description = "vpc_2 Subnets where the TGW Attachment lives used for routing private subnet to TGW and GWLB Fw"
}

variable "endpoint_subnets_vpc2"{
  type = list(string)
  description = "vpc_2 subnets where the endpoint lives used for internet to public subnet"
}

variable "security_vpc_tgw_networks_ids"{
  type = list(string)
  description = "tgw networks ids from terraform lab"
}

variable "sec_vpc_id"{
  type = string
  description = "terraform id for security vpc created by checkpoint"
}
