module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

   name = local.name_vpc1
   cidr = var.cidr_vpc1

  azs             = ["${var.region}a","${var.region}b"]
  public_subnets = var.public_subnets_vpc1
  private_subnets  = var.private_subnets_vpc1w
  intra_subnets = var.tgwconnection_subnets_vpc1
  
  manage_default_network_acl = var.network_acl
  default_network_acl_tags = {Name = "${local.name_vpc1}-vpc-acl-default"} 

  enable_nat_gateway = var.enable_nat_gw
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

   name = local.name_vpc2
   cidr = var.cidr_vpc2

  azs             = ["${var.region}a","${var.region}b"]
  public_subnets = var.public_subnets_vpc2
  private_subnets  = var.private_subnets_vpc2
  intra_subnets = var.tgwconnection_subnets_vpc2
  
  manage_default_network_acl = var.network_acl
  default_network_acl_tags = {Name = "${local.name_vpc2}-vpc-acl-default"} 

  enable_nat_gateway = var.enable_nat_gw
  enable_vpn_gateway = var.enable_vpn_gateway
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "chkp-gwlb-lab"{
  source = "../aws/tgw-gwlb-master"
  depends_on = [module.vpc1, module.vpc2]
}
