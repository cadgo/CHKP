resource "aws_vpc_endpoint" "endpoint_service_vpc1"{
  service_name = var.endpoint_service_name
  dynamic "subnet_calc"{
  for_each = {for i, val in }
  content{
    subnet_ids = ["subnet-0c56a785ef0ac60a6"]
    }
  }
  vpc_endpoint_type = local.endpoint_type
  vpc_id = module.vpc1.vpc_id
}
