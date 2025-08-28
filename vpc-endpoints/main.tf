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

# Create S3 Bucket
resource "aws_s3_bucket" "nextwork_vpc_project" {
  bucket = "nextwork-vpc-project-jsabrokwah-jksdkeq"

  tags = {
    Name = "NextWork VPC Project Bucket"
  }
}

# S3 Bucket Policy to restrict access to VPC endpoint only
resource "aws_s3_bucket_policy" "nextwork_vpc_endpoint_policy" {
  bucket = aws_s3_bucket.nextwork_vpc_project.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.nextwork_vpc_project.arn,
          "${aws_s3_bucket.nextwork_vpc_project.arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.nextwork_s3_endpoint.id
          }
        }
      }
    ]
  })
}

# Create VPC Endpoint for S3
resource "aws_vpc_endpoint" "nextwork_s3_endpoint" {
  vpc_id         = aws_vpc.nextwork_vpc.id
  service_name   = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_default_route_table.nextwork_main_rt.id]

  tags = {
    Name = "NextWork VPC Endpoint"
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


