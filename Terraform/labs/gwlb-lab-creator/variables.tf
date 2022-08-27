variable "network_acl"{
  type = bool
  description = "aws vpc module network acl true or false"
  default = true
}

variable "region"{
  type = string
  description = "aws region used by AZS"
  default = "us-east-1"
}

variable "enable_nat_gw"{
  type = bool
  description = "enable nat gw for private subnets"
  default = false
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
