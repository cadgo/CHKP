resource "aws_route_table" "vpc_1-priv-to-tgw"{
  vpc_id = module.vpc1.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_ec2_transit_gateway.main_tgw.id
  }
  tags = {Name = "vpc_1-priv-to-tgw"}
}

resouce "aws_route_table_association" "vpc_1priv_asoc"{
  count = length(module.vpc1.intra_subnets)
  subnet_id = module.vpc1.intra_subnets[index.count]
  route_table_id = aws_route_table.vpc_1-priv-to-tgw.id 
}

resource "aws_route_table" "vpc_2-priv-to-tgw"{
  vpc_id = module.vpc2.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_ec2_transit_gateway.main_tgw.id
  }
  tags = {Name = "vpc_2-priv-to-tgw"}
}

resouce "aws_route_table_association" "vpc_2priv_asoc"{
  count = length(module.vpc2.intra_subnets)
  subnet_id = module.vpc2.intra_subnets[index.count]
  route_table_id = aws_route_table.vpc_2-priv-to-tgw.id 
