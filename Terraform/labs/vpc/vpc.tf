module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

   name = "vpc_1"
   cidr = "10.0.0.0/16"

  azs             = ["${local.region}a","${local.region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.51.0/24", "10.0.52.0/24"]
  intra_subnets = ["10.0.61.0/24", "10.0.62.0/24"]
  
  manage_default_network_acl = true
  default_network_acl_tags = {Name = "vpc1-acl-default"}

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc2"
  cidr = "172.16.0.0/16"

  azs             = ["${local.region}a","${local.region}b"]
  public_subnets = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.51.0/24", "172.16.52.0/24"]
  intra_subnets = ["172.16.61.0/24", "172.16.62.0/24"]

  manage_default_network_acl = true
  default_network_acl_tags = {Name = "vpc2-acl-default"}

  enable_nat_gateway = false
  enable_vpn_gateway = false

   tags = {
     Terraform = "true"
     Environment = "dev"
  }
}

module "vpc_1_web" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "vpc1-web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc1.vpc_id

  ingress_cidr_blocks = ["172.16.0.0/16","0.0.0.0/0"]
}

module "vpc_1_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "vpc1-ssh"
  description = "Security group for ssh ports open within VPC"
  vpc_id      = module.vpc1.vpc_id

  ingress_cidr_blocks = ["172.16.0.0/16","0.0.0.0/0"]
}

module "vpc_2_web" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "vpc1-web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc2.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16","0.0.0.0/0"]
}

module "vpc_2_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "vpc1-ssh"
  description = "Security group for ssh ports open within VPC"
  vpc_id      = module.vpc2.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16","0.0.0.0/0"]
}
