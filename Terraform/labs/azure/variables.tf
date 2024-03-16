variable "lab_tags" {
  type = map
  description = "default lab tags"
  default = {
    Terraform = "True"
    owner = "cdiaz"
    description = "azure vwan peering vnets"
  }
}

variable "rg_vnet1"{
  type = string
  description = "resource group for vnet1"
  default = "rg_vnet1"
}

variable "rg_vnet2"{
  type = string
  description = "resource group for vnet2"
  default = "rg_vnet2"
}

variable "rg_vnet3_fw"{
  type = string
  description = "resource group for vnet3 fw"
  default = "rg_vnet3_fw"
}

variable "vnet1_definition"{
  type = map
  description = "vnet1 definition"
  default ={ 
    name = "vnet1"
    resource_g = "rg_vnet1"
    cidr = "10.0.1.0/24"
  }
}

variable "vnet2_definition"{
  type = map
  description = "vnet2 definition"
  default = {
    name = "vnet2"
    resource_g = "rg_vnet2"
    cidr = "10.0.2.0/24"
  }
}

variable "vnet3_in_serv_fw"{
  type = map
  description = "vnet3 definition"
  default = {
    name = "vnet3"
    resource_g = "rg_vnet3"
    cidr = "10.0.3.0/24"
  }
}
