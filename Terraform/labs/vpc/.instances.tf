module "ec2_instance_vpc1_pub" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  
  count = length(module.vpc1.public_subnets) 

  name = "instance-${count.index}"

  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  key_name               = "lab"
  monitoring             = true
  vpc_security_group_ids = ["module.vpc_1_web.id","module.vpc_2_ssh.id"]
  subnet_id              = element(module.vpc1.public_subnets,count.index)
  associate_public_ip_address = true

  tags = {
   Terraform   = "true"
   Environment = "dev"
  }
}
