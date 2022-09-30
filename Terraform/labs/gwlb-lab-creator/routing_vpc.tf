//comment
resource "aws_route" "modify_vpc_1-priv-to-tgw"{
  count = length(module.vpc1.private_route_table_ids)
  route_table_id = element(module.vpc1.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_ec2_transit_gateway.main_tgw.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment]
}

resource "aws_route" "modify_vpc_2-priv-to-tgw"{
  count = length(module.vpc2.private_route_table_ids)
  route_table_id = element(module.vpc2.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_ec2_transit_gateway.main_tgw.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment]
}

resource "aws_route_table" "edge-vpc1-pub-rt"{
//  count = length([cidrsubnet(var.cidr_vpc1,8,10), cidrsubnet(var.cidr_vpc1,8,20)])
  vpc_id = module.vpc1.vpc_id
  route{
  cidr_block = cidrsubnet(var.cidr_vpc1,8,10)
  vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc1[0].id
  }
  route{
  cidr_block = cidrsubnet(var.cidr_vpc1,8,20)
  vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc1[1].id
  }
  tags = {Name = "rt-vpc1-pub-endpoint"}
}

resource "aws_route_table_association" "vpc1_rt_assoc"{
  gateway_id = module.vpc1.igw_id
  route_table_id = aws_route_table.edge-vpc1-pub-rt.id
}
