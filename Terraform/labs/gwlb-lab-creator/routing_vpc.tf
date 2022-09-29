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
