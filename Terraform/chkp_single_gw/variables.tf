variable "prefix" {
	description = "Prefix used by any resource"
	default = "LabEnvironment"
}

variable "location" {
	description = "Location to deploy the lab"
	default = "East US"
}

variable "admin_username" {
	description = "admin user name"
	default = "admin"
}

variable "admin_password" {
	description = "default lab password"
	default = "Cpwins1!"
}

variable "vnetlab" {
	description = "vnet used for the lab"
	default = "vnet"
}

variable "addressVnet" {
	default = "172.16.0.0/16"
}

variable "GWName" {
	default = "R8010Demo"
}

variable "PC1VPN" {
	description = "PC used for VPN demo"
	default = "PCinside"
}

variable "PC1USer" {
	default = "carlos"
}
