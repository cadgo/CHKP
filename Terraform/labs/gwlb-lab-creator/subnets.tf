resource "aws_subnet" "endpoint_subs_vpc_1"{
  count = length([cidrsubnet(var.cidr_vpc1,8,90),cidrsubnet(var.cidr_vpc1,8,100)])

  vpc_id = module.vpc1.vpc_id
  availability_zone = element(var.list_region, count.index)
  cidr_block = element(var.endpoint_subnets_vpc1, count.index)
  tags = {Name = "endpoint-vpc1-sub-${count.index}"}
  depends_on = [module.vpc1]
}

resource "aws_subnet" "endpoint_subs_vpc_2"{
  count = length([cidrsubnet(var.cidr_vpc2,8,90),cidrsubnet(var.cidr_vpc2,8,100)])

  vpc_id = module.vpc2.vpc_id
  availability_zone = element(var.list_region, count.index)
  cidr_block = element(var.endpoint_subnets_vpc2, count.index)
  tags = {Name = "endpoint-vpc2-sub-${count.index}"}
  depends_on = [module.vpc2]
}
