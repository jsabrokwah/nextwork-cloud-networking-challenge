# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create VPC 1
resource "aws_vpc" "nextwork_vpc_1" {
  cidr_block           = var.vpc_1_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "NextWork-1"
  }
}

# Create Public Subnet for VPC 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.nextwork_vpc_1.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "NextWork-1 Public Subnet"
  }
}

# Create VPC 2
resource "aws_vpc" "nextwork_vpc_2" {
  cidr_block           = var.vpc_2_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "NextWork-2"
  }
}

# Create Public Subnet for VPC 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.nextwork_vpc_2.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "NextWork-2 Public Subnet"
  }
}

# Create Internet Gateway for VPC 1
resource "aws_internet_gateway" "nextwork_ig_1" {
  vpc_id = aws_vpc.nextwork_vpc_1.id

  tags = {
    Name = "NextWork-1 IG"
  }
}

# Create Internet Gateway for VPC 2
resource "aws_internet_gateway" "nextwork_ig_2" {
  vpc_id = aws_vpc.nextwork_vpc_2.id

  tags = {
    Name = "NextWork-2 IG"
  }
}

# Create Route Table for VPC 1 Public Subnet
resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.nextwork_vpc_1.id

  tags = {
    Name = "NextWork-1 Public Route Table"
  }
}

# Create Route Table for VPC 2 Public Subnet
resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.nextwork_vpc_2.id

  tags = {
    Name = "NextWork-2 Public Route Table"
  }
}

# Add route to Internet Gateway for VPC 1
resource "aws_route" "internet_access_1" {
  route_table_id         = aws_route_table.public_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nextwork_ig_1.id
}

# Add route to Internet Gateway for VPC 2
resource "aws_route" "internet_access_2" {
  route_table_id         = aws_route_table.public_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nextwork_ig_2.id
}

# Associate Public Subnet 1 with Route Table 1
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt_1.id
}

# Associate Public Subnet 2 with Route Table 2
resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt_2.id
}

# Create VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.nextwork_vpc_2.id
  vpc_id      = aws_vpc.nextwork_vpc_1.id
  auto_accept = true

  tags = {
    Name = "VPC 1 <> VPC 2"
  }
}

# Add route to VPC 2 in VPC 1's route table
resource "aws_route" "vpc_1_to_vpc_2" {
  route_table_id            = aws_route_table.public_rt_1.id
  destination_cidr_block    = var.vpc_2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Add route to VPC 1 in VPC 2's route table
resource "aws_route" "vpc_2_to_vpc_1" {
  route_table_id            = aws_route_table.public_rt_2.id
  destination_cidr_block    = var.vpc_1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group for VPC 1 EC2 Instance
resource "aws_security_group" "vpc_1_instance_sg" {
  name        = "vpc-1-instance-sg"
  description = "Security group for EC2 instance in VPC 1"
  vpc_id      = aws_vpc.nextwork_vpc_1.id

  # Allow SSH access (for connectivity testing)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping) for connectivity testing
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-1-Instance-SG"
  }
}

# Security Group for VPC 2 EC2 Instance
resource "aws_security_group" "vpc_2_instance_sg" {
  name        = "vpc-2-instance-sg"
  description = "Security group for EC2 instance in VPC 2"
  vpc_id      = aws_vpc.nextwork_vpc_2.id

  # Allow SSH access (for connectivity testing)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping) for connectivity testing
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-2-Instance-SG"
  }
}

# EC2 Instance in VPC 1 - Public Subnet 1
resource "aws_instance" "nextwork_vpc_1_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.vpc_1_instance_sg.id]
  
  # Proceed without a key pair as requested
  key_name = ""

  tags = {
    Name = "Instance - NextWork VPC 1"
  }
}

# EC2 Instance in VPC 2 - Public Subnet 2
resource "aws_instance" "nextwork_vpc_2_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.vpc_2_instance_sg.id]
  
  # Proceed without a key pair as requested
  key_name = ""

  tags = {
    Name = "Instance - NextWork VPC 2"
  }
}
