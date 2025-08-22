# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "nextwork_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "NextWork VPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "nextwork_ig" {
  vpc_id = aws_vpc.nextwork_vpc.id

  tags = {
    Name = "NextWork IG"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.nextwork_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "NextWork Public Subnet"
  }
}

# Import the existing default route table
resource "aws_default_route_table" "nextwork_main_rt" {
  default_route_table_id = aws_vpc.nextwork_vpc.default_route_table_id

  tags = {
    Name = "NextWork Public Route Table"
  }
}

# Add a route to the Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_default_route_table.nextwork_main_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nextwork_ig.id
}


# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Associate the route table with the Public 1 subnet
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_default_route_table.nextwork_main_rt.id
}


# Create Security Group
resource "aws_security_group" "nextwork_security_group" {
  name        = "NextWork Security Group"
  description = "A Security Group for the NextWork VPC"
  vpc_id      = aws_vpc.nextwork_vpc.id

  ingress {
    description = "HTTP from Anywhere-IPv4"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Ingress for SSH to test connectivity from the public internet
  ingress {
    description = "SSH from Anywhere-IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NextWork Security Group"
  }
}

# Create Network ACL
resource "aws_network_acl" "nextwork_network_acl" {
  vpc_id = aws_vpc.nextwork_vpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "NextWork Public NACL"
  }
}

# Associate Network ACL with the public subnet
resource "aws_network_acl_association" "public_subnet_1_acl_association" {
  network_acl_id = aws_network_acl.nextwork_network_acl.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

# Create Private Subnet - Investigation of CIDR overlap
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.nextwork_vpc.id
  cidr_block        = var.private_subnet_1_cidr  # Using 10.0.1.0/24 to avoid overlap
  availability_zone = data.aws_availability_zones.available.names[1]  # Second AZ (us-east-1b)

  tags = {
    Name = "NextWork Private Subnet"
  }
}

# Create separate route table for private subnet (no internet gateway route)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.nextwork_vpc.id

  tags = {
    Name = "NextWork Private Route Table"
  }
}

# Create Network ACL
resource "aws_network_acl" "nextwork_private_network_acl" {
  vpc_id = aws_vpc.nextwork_vpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "NextWork Private NACL"
  }
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate the private network ACL with the private subnet
resource "aws_network_acl_association" "private_subnet_1_acl_association" {
  network_acl_id = aws_network_acl.nextwork_private_network_acl.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

# Data source to get the latest Amazon Linux 2 AMI (free tier eligible)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create Security Group for Private Server
resource "aws_security_group" "nextwork_private_security_group" {
  name        = "NextWork Private Security Group"
  description = "Security group for NextWork Private Subnet"
  vpc_id      = aws_vpc.nextwork_vpc.id

  ingress {
    description = "SSH from Public Security Group"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.nextwork_security_group.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NextWork Private Security Group"
  }
}

# Create EC2 Instance - NextWork Public Server
resource "aws_instance" "nextwork_public_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = "NextWorkChallenge"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.nextwork_security_group.id]

  tags = {
    Name = "NextWork Public Server"
  }
}

# Create EC2 Instance - NextWork Private Server
resource "aws_instance" "nextwork_private_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = "NextWorkChallenge"
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.nextwork_private_security_group.id]

  tags = {
    Name = "NextWork Private Server"
  }
}

