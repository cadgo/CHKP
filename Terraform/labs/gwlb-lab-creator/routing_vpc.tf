//comment
resource "aws_route" "modify_vpc_1-priv-to-tgw"{
  count = length(var.private_subnets_vpc1)
  route_table_id = element(module.vpc1.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_ec2_transit_gateway.main_tgw.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment]
}

resource "aws_route" "modify_vpc_2-priv-to-tgw"{
  count = length(var.private_subnets_vpc2)
  route_table_id = element(module.vpc2.private_route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_ec2_transit_gateway.main_tgw.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment]
}
//resource "aws_route_table" "vpc_1-priv-to-tgw"{
//  vpc_id = module.vpc1.vpc_id
//  route {
//    cidr_block = "0.0.0.0/0"
//    gateway_id = aws_ec2_transit_gateway.main_tgw.id
//  }
//  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment]
//  tags = {Name = "vpc_1-priv-to-tgw"}
//}
//
//resource "aws_route_table_association" "vpc_1priv_asoc"{
//  count = length(var.private_subnets_vpc1)
//  subnet_id = element(module.vpc1.private_subnets, count.index)
//  route_table_id = element(module.vpc1.private_route_table_ids, count.index) 
//}
//
//resource "aws_route_table" "vpc_2-priv-to-tgw"{
//  vpc_id = module.vpc2.vpc_id
//  route {
//    cidr_block = "0.0.0.0/0"
//    gateway_id = aws_ec2_transit_gateway.main_tgw.id
//  }
//  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment]
//  tags = {Name = "vpc_2-priv-to-tgw"}
//}
//
//resource "aws_route_table_association" "vpc_2priv_asoc"{
//  count = length(var.private_subnets_vpc2)
//  subnet_id = element(module.vpc2.private_subnets, count.index)
//  route_table_id = element(module.vpc2.private_route_table_ids, count.index)
//}