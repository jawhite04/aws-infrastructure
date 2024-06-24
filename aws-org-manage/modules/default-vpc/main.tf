###########################
# VPC
###########################
resource "aws_vpc" "default" {
  provider             = aws.target
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "default-vpc"
  }
}

###########################
# Public Subnet
###########################
resource "aws_subnet" "public" {
  provider                = aws.target
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "default-public-subnet"
  }
}

###########################
# Private Subnet
###########################
resource "aws_subnet" "private" {
  provider   = aws.target
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "default-private-subnet"
  }
}

###########################
# Internet Gateway
###########################
resource "aws_internet_gateway" "default" {
  provider = aws.target
  vpc_id   = aws_vpc.default.id

  tags = {
    Name = "default-igw"
  }
}

###########################
# Route Table for Public Subnet
###########################
resource "aws_route_table" "public" {
  provider = aws.target
  vpc_id   = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "default-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  provider       = aws.target
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


###########################
# Outputs
###########################
output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
