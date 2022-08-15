terraform{
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

resource "aws_vpc" "vpcs"{
  count = length(local.vpc_list)
  cidr_block = local.vpc_list[count.index]
} 


