variable "lab_tags"{
  default = {
    Environment = "2subs_priv_pub"
    Owner = "cdz"
  }
  type=map(string)
}

variable "vpc_list" {
  type = list(string)
  description ="VPC Used in lab"
}

variable "subnets_privs"{
  type = list(string)
    description = "list of subnets privs"
}

variable "subnets_pubs"{
  type = list(string)
  description = "list of public subnets"
}

variable "lab_az" {
  type = list(string)
  description = "AZ zones used in lab"
}
