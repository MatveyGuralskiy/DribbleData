#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

# Module AWS EKS VPC
#---------------VPC-------------------

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
    Name = "Public Subnet A - ${var.Environment}"
  }
}

resource "aws_subnet" "Public_B" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.Public_B_CIDR
  availability_zone = "${var.Region}b"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet B - ${var.Environment}"
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

# Create Route Tables for Public Subnet B
resource "aws_route_table" "Public_RouteTable_B" {
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
    Name = "Public RouteTable B- ${var.Environment}"
  }
}

# Attach Public Subnets to Route Tables A,B
resource "aws_route_table_association" "RouteTable_Attach_A" {
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.Public_RouteTable_A.id
}

resource "aws_route_table_association" "RouteTable_Attach_B" {
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.Public_RouteTable_B.id
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

#---------------EKS-------------------

# IAM role for EKS
data "aws_iam_policy_document" "Assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role for EKS
resource "aws_iam_role" "Main_Role" {
  name               = "eks-cluster-cloud"
  assume_role_policy = data.aws_iam_policy_document.Assume_role.json
}

# IAM role for EKS
resource "aws_iam_role_policy_attachment" "Main_Role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Main_Role.name
}

#EKS Cluster
resource "aws_eks_cluster" "EKS" {
  name     = var.EKS_Name
  role_arn = aws_iam_role.Main_Role.arn

  vpc_config {
    subnet_ids = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.Main_Role-AmazonEKSClusterPolicy
  ]
}

# IAM Role for Nodes
resource "aws_iam_role" "Node_Role" {
  name = "EKS_Node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Policies for Nodes
resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Node_Role.name
}

resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Node_Role.name
}

resource "aws_iam_role_policy_attachment" "Node_Role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.Node_Role.name
}

# Create Node Group
resource "aws_eks_node_group" "Worker_Nodes" {
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = var.Node_Group_Name
  node_role_arn   = aws_iam_role.Node_Role.arn
  subnet_ids      = [aws_subnet.Public_A.id, aws_subnet.Public_B.id]

  scaling_config {
    desired_size = var.Scaling_Number
    max_size     = var.Scaling_Max_Number
    min_size     = var.Scaling_Number
  }

  tags = {
    Environment = var.Environment
  }

  launch_template {
    name    = aws_launch_template.EKS_Node_Template.name
    version = aws_launch_template.EKS_Node_Template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.Node_Role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Node_Role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Launch Template for EKS Nodes
resource "aws_launch_template" "EKS_Node_Template" {
  name          = var.EKS_Template_Name
  instance_type = var.Instance_type
  key_name      = var.Key_SSH
}
