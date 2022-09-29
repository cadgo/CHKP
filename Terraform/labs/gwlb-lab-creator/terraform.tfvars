list_region = ["us-east-1a", "us-east-1b"]
deploy_instances = true
cidr_vpc1 = "192.168.0.0/16"
tgwconnection_subnets_vpc1 = ["192.168.70.0/24", "192.168.80.0/24"]
endpoint_subnets_vpc1 = ["192.168.90.0/24", "192.168.100.0/24"]

cidr_vpc2 = "172.16.0.0/16"

tgwconnection_subnets_vpc2 = ["172.16.70.0/24", "172.16.80.0/24"]
endpoint_subnets_vpc2 = ["172.16.90.0/24", "172.16.100.0/24"]
vpc_acl_tag_vpc2 = "${var.name_vpc2}-vpc-acl-default"

sec_vpc_id = "vpc-02302bf9339d5bd8e"
security_vpc_tgw_networks_ids = ["subnet-0a189cec1783ab507","subnet-00007bd9326e13170"]
endpoint_service_name = "gwlb-endpoint-service-gwlb1-cdz"
