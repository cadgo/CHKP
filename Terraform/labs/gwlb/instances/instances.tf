terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "pro-1-inst"{
  ami = "ami-052efd3df9dad4825"
  count=2
  instance_type = "t2.micro"
  key_name = "labs"
  availability_zone = "us-east-1a"
  subnet_id = "subnet-02180785e35774c1e"
  associate_public_ip_address = true
  #  network_interface {
  #    network_interface_id = aws_network_interface.pro-1-eni.id
  #    device_index = 0
  # }
}
