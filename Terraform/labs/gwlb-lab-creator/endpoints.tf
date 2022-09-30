resource "aws_vpc_endpoint" "endpoint_service_vpc1"{
  for_each = {for i, val in aws_subnet.endpoint_subs_vpc_1[*].id: i=> val}
  service_name = var.endpoint_service_name
  subnet_ids = [each.value]
  vpc_endpoint_type = local.endpoint_type
  vpc_id = module.vpc1.vpc_id
  tags = {Name = "endpoint_vpc1_${each.value}"}
}

resource "aws_vpc_endpoint" "endpoint_service_vpc2"{
  for_each = {for i, val in aws_subnet.endpoint_subs_vpc_2[*].id: i=> val}
  service_name = var.endpoint_service_name
  subnet_ids = [each.value]
  vpc_endpoint_type = local.endpoint_type
  vpc_id = module.vpc2.vpc_id
  tags = {Name = "endpoint_vpc2_${each.value}"}
}
