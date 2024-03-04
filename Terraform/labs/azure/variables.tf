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
