terraform{
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "protected1" {
  cidr_block  = "172.32.0.0/16"
  tags = merge(var.default_tags, {Name = "protected vpc1"},)
}

resource "aws_subnet" "EndpointA" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.0.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "EndpointA"},)
} 

resource "aws_subnet" "EndpointB" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.1.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "EndpointB"},)
}

resource "aws_subnet" "PublicA" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.2.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "PublicA"},)
}

resource "aws_subnet" "PublicB" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.3.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "PublicB"},)
}

resource "aws_subnet" "TGWA" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.4.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "TGWA"},)
}

resource "aws_subnet" "TGWB" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.5.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "TGWB"},)
}

resource "aws_subnet" "PrivateA" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.6.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "PrivateA"},)
}

resource "aws_subnet" "PrivateB" {
  vpc_id = aws_vpc.protected1.id
  cidr_block = "172.32.7.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "PrivateB"},)
}

resource "aws_vpc" "protected2" {
  cidr_block  = "172.44.0.0/16"
  tags = merge(var.default_tags, {Name = "protected vpc2"},)
}

resource "aws_subnet" "EndpointP2A" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.0.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "EndpointP2A"},)
} 

resource "aws_subnet" "EndpointP2B" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.1.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "EndpointP2B"},)
}

resource "aws_subnet" "PublicP2A" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.2.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "PublicP2A"},)
}

resource "aws_subnet" "PublicP2B" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.3.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "PublicP2B"},)
}

resource "aws_subnet" "TGWP2A" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.4.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "TGWP2A"},)
}

resource "aws_subnet" "TGWP2B" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.5.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "TGWP2B"},)
}

resource "aws_subnet" "Private2A" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.6.0/24"
  availability_zone = "us-east-1a"

  tags = merge(var.default_tags, {Name = "Private2A"},)
}


resource "aws_subnet" "Private2B" {
  vpc_id = aws_vpc.protected2.id
  cidr_block = "172.44.7.0/24"
  availability_zone = "us-east-1b"

  tags = merge(var.default_tags, {Name = "Private2B"},)
}
#Internet GW
resource "aws_internet_gateway" "pro1-igw"{
  vpc_id = aws_vpc.protected1.id

  tags = merge(var.default_tags, {Name = "pro1-igw"},)
}

resource "aws_internet_gateway" "pro2-igw"{
  vpc_id = aws_vpc.protected2.id

  tags = merge(var.default_tags, {Name = "pro2-igw"},)
}
#Security Groups
resource "aws_security_group" "Pord-1-ns-Instances"{
  name = "Allow SSH-Pro-1"
  vpc_id = aws_vpc.protected1.id

  ingress {
    description = "Inbound ssh"
    from_port = 0
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.IPSource}/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Pord-2-ns-Instances"{
  name = "Allow SSH-Pro-2"
  vpc_id = aws_vpc.protected2.id

  ingress {
    description = "Inbound ssh"
    from_port = 0
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.IPSource}/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Instances
resource "aws_instance" "pro-1-insta-PubA"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.PublicA.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.Pord-1-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-1-insta-PubA"},)
}

resource "aws_instance" "pro-1-insta-PubB"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1b"
  subnet_id = aws_subnet.PublicB.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.Pord-1-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-1-insta-PubB"},)
}

resource "aws_instance" "pro-1-insta-PrivA"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.PrivateA.id
  security_groups = [aws_security_group.Pord-1-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-1-insta-PrivA"},)
}

resource "aws_instance" "pro-2-insta-Pub2A"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.PublicP2A.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.Pord-2-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-2-insta-Pub2A"},)
}

resource "aws_instance" "pro-2-insta-Pub2B"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1b"
  subnet_id = aws_subnet.PublicP2B.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.Pord-2-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-2-insta-Pub2B"},)
}

resource "aws_instance" "pro-2-insta-Priv2A"{
  ami = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  key_name = "${var.key_lab}"
  availability_zone = "us-east-1a"
  subnet_id = aws_subnet.Private2A.id
  security_groups = [aws_security_group.Pord-2-ns-Instances.id]
  tags = merge(var.default_tags, {Name = "pro-2-insta-Priv2A"},)
}
