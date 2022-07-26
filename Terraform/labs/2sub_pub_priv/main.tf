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

resource "aws_vpc" "vpcs"{
  count = length(var.vpc_list)
  cidr_block = var.vpc_list[count.index]
  tags=merge(var.lab_tags, {Name = "vpc_${count.index}"})
} 

resource "aws_internet_gateway" "igw_lab" {
  count = length(var.vpc_list)
  vpc_id = aws_vpc.vpcs[count.index].id
  tags=merge(var.lab_tags, {Name = "igw-lab${count.index}"})
}

resource "aws_subnet" "subnets_priv"{
  count=length(var.subnets_privs)
  vpc_id = aws_vpc.vpcs["${length(var.vpc_list)-1}"].id
  cidr_block = var.subnets_privs[count.index]
  availability_zone = var.lab_az[count.index]
  tags=merge(var.lab_tags, {Name = "priv_sub_${count.index}"})
}

resource "aws_subnet" "subnets_pubs"{
  count=length(var.subnets_pubs)
  vpc_id = aws_vpc.vpcs["${length(var.vpc_list)-1}"].id
  cidr_block = var.subnets_pubs[count.index]
  availability_zone = var.lab_az[count.index]
  tags=merge(var.lab_tags, {Name = "pub_sub_${count.index}"})
}

resource "aws_eip" "Nat_GW_ips"{
  count = length(var.subnets_pubs)
  vpc = true
  tags=merge(var.lab_tags, {Name = "EIP_${var.subnets_privs[count.index]}"})
  depends_on = [aws_internet_gateway.igw_lab]
}

resource "aws_nat_gateway" "Nat_Pubs"{
  count = length(var.subnets_pubs)
  allocation_id = aws_eip.Nat_GW_ips[count.index].id
  subnet_id = aws_subnet.subnets_pubs[count.index].id
  connectivity_type = "public"
  tags=merge(var.lab_tags, {Name = "Nat_gw_${var.subnets_privs[count.index]}"})
  depends_on = [aws_eip.Nat_GW_ips]
  }

resource "aws_route_table" "pub_rt"{
  count = length(var.subnets_pubs)
  vpc_id = aws_vpc.vpcs[length(var.vpc_list)-1].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_lab[length(var.vpc_list)-1].id
  }
  tags=merge(var.lab_tags, {Name = "pub_rt_${count.index}"})
}

resource "aws_route_table_association" "rt-pub-assco"{
  count = length(var.subnets_pubs)
  subnet_id = aws_subnet.subnets_pubs[count.index].id
  route_table_id = aws_route_table.pub_rt[count.index].id 
}

resource "aws_route_table" "priv_rt"{
  count = length(var.subnets_privs)
  vpc_id = aws_vpc.vpcs[length(var.vpc_list)-1].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Nat_Pubs[count.index].id
  }
  tags=merge(var.lab_tags, {Name = "priv_rt_${count.index}"})
}

resource "aws_route_table_association" "rt-priv-assco"{
  count = length(var.subnets_privs)
  subnet_id = aws_subnet.subnets_priv[count.index].id
  route_table_id = aws_route_table.priv_rt[count.index].id 
}

