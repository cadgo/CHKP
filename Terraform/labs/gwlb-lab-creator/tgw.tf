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

resource "aws_ec2_transit_gateway_route_table" "hub-to-sec-rt"{
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_ec2_transit_gateway_route" "default-gw-to-sechub"{
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub-to-sec-rt.id
} 

resource "aws_ec2_transit_gateway_route_table_association" "vpc1-hub-to-sec-rt-asoc"{
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub-to-sec-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc2-hub-to-sec-rt-asoc"{
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub-to-sec-rt.id
}

resource "aws_ec2_transit_gateway_route_table" "sec-to-hub-rt"{
  transit_gateway_id = aws_ec2_transit_gateway.main_tgw.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_vpc1"{
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sec-to-hub-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "propagation_vpc2"{
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sec-to-hub-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "sec-to-hub-asoc"{
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_security.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sec-to-hub-rt.id
}
