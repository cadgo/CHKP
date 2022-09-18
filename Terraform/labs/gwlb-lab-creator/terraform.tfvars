list_region = ["us-east-1a", "us-east-1b"]
cidr_vpc1 = "192.168.0.0/16"
deploy_instances = false
public_subnets_vpc1 = ["192.168.1.0/24", "192.168.2.0/24"]
private_subnets_vpc1 = ["192.168.11.0/24", "192.168.12.0/24"]
tgwconnection_subnets_vpc1 = ["192.168.21.0/24", "192.168.22.0/24"]
endpoint_subnets_vpc1 = ["192.168.31.0/24", "192.168.32.0/24"]

cidr_vpc2 = "172.16.0.0/16"

public_subnets_vpc2 = ["172.16.1.0/24", "172.16.2.0/24"]
private_subnets_vpc2 = ["172.16.11.0/24", "172.16.12.0/24"]
tgwconnection_subnets_vpc2 = ["172.16.21.0/24", "172.16.22.0/24"]
endpoint_subnets_vpc2 = ["172.16.31.0/24", "172.16.32.0/24"]
vpc_acl_tag_vpc2 = "${var.name_vpc2}-vpc-acl-default"

sec_vpc_id = "vpc-094067eade82ea2f0"
security_vpc_tgw_networks_ids = ["subnet-04eef61b8a9316aad","subnet-0471fdd3b408168e9"]

