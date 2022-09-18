module "ec2_instance_vpc1_pub" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
  count = var.deploy_instances ? length(module.vpc1.public_subnets) : 0 

  name = "vpc-1-pub-${count.index}"

  ami                    = var.public_ami
  instance_type          = "t2.micro"
  key_name               = "lab"
  monitoring             = true
  vpc_security_group_ids = [module.vpc_1_web.security_group_id,module.vpc_1_ssh.security_group_id]
  subnet_id              = element(module.vpc1.public_subnets,count.index)
  associate_public_ip_address = true

  tags = {
   Terraform   = "true"
   Environment = "dev"
  }
}

module "ec2_instance_vpc1_priv" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
  count = var.deploy_instances ? length(module.vpc1.private_subnets) : 0 

  name = "vpc-1-priv-${count.index}"

  ami                    = var.private_ami
  instance_type          = "t2.micro"
  key_name               = "lab"
  monitoring             = true
  vpc_security_group_ids = [module.vpc_1_web.security_group_id,module.vpc_1_ssh.security_group_id]
  subnet_id              = element(module.vpc1.private_subnets,count.index)
  associate_public_ip_address = false

  tags = {
   Terraform   = "true"
   Environment = "dev"
  }
}

module "ec2_instance_vpc2_pub" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
  count = var.deploy_instances ? length(module.vpc2.public_subnets) : 0

  name = "vpc-2-pub-${count.index}"

  ami                    = var.public_ami
  instance_type          = "t2.micro"
  key_name               = "lab"
  monitoring             = true
  vpc_security_group_ids = [module.vpc_2_web.security_group_id,module.vpc_2_ssh.security_group_id]
  subnet_id              = element(module.vpc2.public_subnets,count.index)
  associate_public_ip_address = true

  tags = {
   Terraform   = "true"
   Environment = "dev"
  }
}

module "ec2_instance_vpc2_priv" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
  count = var.deploy_instances ? length(module.vpc1.private_subnets) : 0

  name = "vpc-2-priv-${count.index}"

  ami                    = var.private_ami
  instance_type          = "t2.micro"
  key_name               = "lab"
  monitoring             = true
  vpc_security_group_ids = [module.vpc_2_web.security_group_id,module.vpc_2_ssh.security_group_id]
  subnet_id              = element(module.vpc2.private_subnets,count.index)
  associate_public_ip_address = false

  tags = {
   Terraform   = "true"
   Environment = "dev"
  }
}
