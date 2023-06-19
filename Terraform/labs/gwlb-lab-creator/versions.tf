terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.4.0"
    }
    http = {
      version = "~> 2.0.0"
    }
    random = {
      version = "~> 3.0.1"
    }
  }
}
