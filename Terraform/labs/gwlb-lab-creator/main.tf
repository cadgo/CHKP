
module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

   name = local.name_vpc1
   cidr = var.cidr_vpc1

  azs             = var.list_region
  public_subnets = [cidrsubnet(var.cidr_vpc1,8,10), cidrsubnet(var.cidr_vpc1,8,20)]
  private_subnets  = [cidrsubnet(var.cidr_vpc1,8,30), cidrsubnet(var.cidr_vpc1,8,40)]
  intra_subnets = [cidrsubnet(var.cidr_vpc1,8,50), cidrsubnet(var.cidr_vpc1,8,60)]

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

  azs             = var.list_region
  public_subnets = [cidrsubnet(var.cidr_vpc2,8,10), cidrsubnet(var.cidr_vpc2,8,20)]
  private_subnets  = [cidrsubnet(var.cidr_vpc2,8,30), cidrsubnet(var.cidr_vpc2,8,40)]
  intra_subnets = [cidrsubnet(var.cidr_vpc2,8,50), cidrsubnet(var.cidr_vpc2,8,60)]
  

  manage_default_network_acl = var.network_acl
  default_network_acl_tags = {Name = "${local.name_vpc2}-vpc-acl-default"} 

  enable_nat_gateway = var.enable_nat_gw
  enable_vpn_gateway = var.enable_vpn_gateway
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

