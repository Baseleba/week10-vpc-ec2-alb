# VPC

resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform-vpc"
    env = "dev"
    Team = "DevOps"
  }
}



# Internet Gateway

resource "aws_internet_gateway" "gwy1" {
  vpc_id = aws_vpc.vpc1.id
}



# NAT gateway

resource "aws_nat_gateway" "nat1" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.Public_1.id
  
}



# Public Subnet 

resource "aws_subnet" "Public_1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-1"
    env = "dev"
  }
}

resource "aws_subnet" "Public_2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.2.0/24"
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-2"
    env = "dev"
  }
}




# Private subnet

resource "aws_subnet" "Private_1" {
  availability_zone = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "Private-subnet-1"
    env = "dev"
  }
}

resource "aws_subnet" "Private_2" {
  availability_zone = "us-east-1b"
  cidr_block = "192.168.4.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "Private-subnet-2"
    env = "dev"
  }
}




# Public route

resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwy1.id
  }
}




# Private route

resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}



# Elastic IP

resource "aws_eip" "eip" {
  
}




# Subnet association Private

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.Private_1.id
    route_table_id = aws_route_table.rtprivate.id
  
}

resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.Private_2.id
    route_table_id = aws_route_table.rtprivate.id
  
}




# subnet association Public 

resource "aws_route_table_association" "rta3" {
    subnet_id = aws_subnet.Public_1.id
    route_table_id = aws_route_table.rtpublic.id
  
}

resource "aws_route_table_association" "rta4" {
    subnet_id = aws_subnet.Public_2.id
    route_table_id = aws_route_table.rtpublic.id
  
}