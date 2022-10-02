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

resource "aws_route_table" "edge-vpc2-pub-rt"{
//  count = length([cidrsubnet(var.cidr_vpc2,8,10), cidrsubnet(var.cidr_vpc2,8,20)])
  vpc_id = module.vpc2.vpc_id
  route{
  cidr_block = cidrsubnet(var.cidr_vpc2,8,10)
  vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc2[0].id
  }
  route{
  cidr_block = cidrsubnet(var.cidr_vpc2,8,20)
  vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc2[1].id
  }
  tags = {Name = "rt-vpc2-pub-endpoint"}
}

resource "aws_route_table_association" "vpc2_rt_assoc"{
  gateway_id = module.vpc2.igw_id
  route_table_id = aws_route_table.edge-vpc2-pub-rt.id
}

resource "aws_route_table" "modify_vpc_1-pulic"{
  count = length(module.vpc1.public_subnets)
  vpc_id = module.vpc1.vpc_id
  route{
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc1[count.index].id
  }
  tags = {Name = "rt-vpc1-public-${count.index}"}
}

//resource "aws_route_table_association" "new-pub-vpc1-rt"{
//  count = length(module.vpc1.public_subnets)
//  subnet_id = element(module.vpc1.public_subnets, count.index)
//  route_table_id = aws_route_table.modify_vpc_1-pulic[count.index].id
//}

resource "aws_route_table" "modify_vpc_2-pulic"{
  count = length(module.vpc2.public_subnets)
  vpc_id = module.vpc2.vpc_id
  route{
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.endpoint_service_vpc2[count.index].id
  }
  tags = {Name = "rt-vpc2-public-${count.index}"}
}

resource "aws_route_table" "rt-endpoint-igw-vpc1"{
  vpc_id = module.vpc1.vpc_id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc1.igw_id
  }
  tags = {Name = "rt-endpoint-igw-vpc1"}
}

resource "aws_route_table_association" "assoc-rt-endpoint-igw-vpc1"{
  count = length([cidrsubnet(var.cidr_vpc1,8,90),cidrsubnet(var.cidr_vpc1,8,100)])
  subnet_id = aws_subnet.endpoint_subs_vpc_1[count.index].id
  route_table_id = aws_route_table.rt-endpoint-igw-vpc1.id
}
resource "aws_route_table" "rt-endpoint-igw-vpc2"{
  vpc_id = module.vpc2.vpc_id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc2.igw_id
  }
  tags = {Name = "rt-endpoint-igw-vpc2"}
}
resource "aws_route_table_association" "assoc-rt-endpoint-igw-vpc2"{
  count = length([cidrsubnet(var.cidr_vpc2,8,90),cidrsubnet(var.cidr_vpc2,8,100)])
  subnet_id = aws_subnet.endpoint_subs_vpc_2[count.index].id
  route_table_id = aws_route_table.rt-endpoint-igw-vpc2.id
}
