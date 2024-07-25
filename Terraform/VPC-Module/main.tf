#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

# Module AWS VPC
data "aws_availability_zones" "Availability" {}

resource "aws_vpc" "VPC" {
  cidr_block = var.VPC_CIDR
  tags = {
    Name        = "VPC - ${var.Environment}"
    Owner       = "Matvey Guralskiy"
    Environment = var.Environment
    From        = "Terraform"
  }
}

# Create Internet Gateway and Automatically Attach
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "IG FlaskPipeline"
  }
}

# Create Public Subnet in Availability Zones A, B
resource "aws_subnet" "Public_A" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.Public_A_CIDR
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet - ${var.Environment}"
  }
}

# Create Route Tables for Public Subnet A
resource "aws_route_table" "Public_RouteTable_A" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = var.VPC_CIDR
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
  tags = {
    Name = "Public RouteTable A- ${var.Environment}"
  }
}

# Attach Public Subnets to Route Tables
resource "aws_route_table_association" "RouteTable_Attach_A" {
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_RouteTable_A.id
}


# Create 2 Private Subnets in different Availability Zones: A, B
resource "aws_subnet" "Private_A" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.Private_A_CIDR
  availability_zone = "${var.Region}a"

  tags = {
    Name = "Private Subnet - ${var.Environment}"
  }
}

resource "aws_subnet" "Private_B" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.Private_B_CIDR
  availability_zone = "${var.Region}b"

  tags = {
    Name = "Private Subnet - ${var.Environment}"
  }
}

# Create Private Route Tabless for Availability zones: A, B
resource "aws_route_table" "Private_Route_Table_A" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
  route {
    cidr_block = var.VPC_CIDR
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet A- ${var.Environment}"
  }
}

resource "aws_route_table" "Private_Route_Table_B" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
  route {
    cidr_block = var.VPC_CIDR
    gateway_id = "local"
  }
  tags = {
    Name = "Route Table Private Subnet B- ${var.Environment}"
  }

}

# Elastic IP for NAT
resource "aws_eip" "NAT_EIP" {
  domain = "vpc"
  tags = {
    Name = "Elastic IP - ${var.Environment}"
  }
}

# NAT Gateway A
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.Public_A.id
  tags = {
    Name = "NAT Gateway - ${var.Environment}"
  }
}


# Attach Private Subnet A to Route Table
resource "aws_route_table_association" "Route_Table_Private_A" {
  subnet_id      = aws_subnet.Private_A.id
  route_table_id = aws_route_table.Private_Route_Table_A.id
}

# Attach Private Subnet B to Route Table
resource "aws_route_table_association" "Route_Table_Private_B" {
  subnet_id      = aws_subnet.Private_B.id
  route_table_id = aws_route_table.Private_Route_Table_B.id
}
