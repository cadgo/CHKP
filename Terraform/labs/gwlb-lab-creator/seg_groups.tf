module "vpc_1_web" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${local.name_vpc1}-web-server"
  description = "${local.name_vpc1} Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc1.vpc_id

  ingress_cidr_blocks = [var.cidr_vpc2,"0.0.0.0/0"]
}

module "vpc_1_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "${local.name_vpc1}-ssh"
  description = "${local.name_vpc1} Security group for ssh ports open within VPC"
  vpc_id      = module.vpc1.vpc_id

  ingress_cidr_blocks = [var.cidr_vpc2,"0.0.0.0/0"]
}

resource "aws_security_group" "icmpvpc1"{
  name = "allow vpc1 icmp"
  description = "allow vpc1 icmp between vpc1 and vpc2"
  vpc_id = module.vpc1.vpc_id

  ingress{
    description = "icmp access"
    from_port =-1
    to_port =-1
    protocol = "icmp"
    cidr_blocks = [var.cidr_vpc2]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
module "vpc_2_web" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${local.name_vpc2}-web-server"
  description = "${local.name_vpc2} Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc2.vpc_id

  ingress_cidr_blocks = [var.cidr_vpc1,"0.0.0.0/0"]
}

module "vpc_2_ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "${local.name_vpc2}-ssh"
  description = "Security group for ssh ports open within VPC"
  vpc_id      = module.vpc2.vpc_id

  ingress_cidr_blocks = [var.cidr_vpc1,"0.0.0.0/0"]
}

resource "aws_security_group" "icmpvpc2"{
  name = "allow vpc2 icmp"
  description = "allow vpc2 icmp between vpc1 and vpc2"
  vpc_id = module.vpc2.vpc_id

  ingress{
    description = "icmp access"
    from_port =-1
    to_port =-1
    protocol = "icmp"
    cidr_blocks = [var.cidr_vpc1]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
