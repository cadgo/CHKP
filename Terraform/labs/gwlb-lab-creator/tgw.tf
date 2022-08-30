resource "aws_ec2_transit_gateway" "main_tgw"{
  description = "main TGW"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments = "disable"
  vpn_ecmp_support = "disable"
  tags = {Name = "main_tgw_lab"}
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment"{
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id = module.vpc1.vpc_id
  subnet_ids = module.vpc1.intra_subnets
  tags = {Name = "vpc1-intra-subnets"}
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment"{
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id = module.vpc2.vpc_id
  subnet_ids = module.vpc2.intra_subnets
  tags = {Name = "vpc2-intra-subnets"}
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_security"{
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
  vpc_id = var.sec_vpc_id
  subnet_ids = var.security_vpc_tgw_networks_ids
  tags = {Name = "security-vpc-attachment"}
}
