variable "location" {
  type = string
  description = "Azure lab location"
  default = "East US" 
}

variable "instances_number" {
  type = number
  description = "how many resources"
  default = 2
}

variable "instance_pass"{
  type = string
  description = "instance password"
  default = "Cpwins1!"
}
