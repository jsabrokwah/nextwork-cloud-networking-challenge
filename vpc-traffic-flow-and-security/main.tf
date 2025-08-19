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
    Name = "Public 1"
  }
}

# Import the existing default route table
resource "aws_default_route_table" "nextwork_main_rt" {
  default_route_table_id = aws_vpc.nextwork_vpc.default_route_table_id

  tags = {
    Name = "NextWork route table"
  }
}

# Uncomment this block, run terraform plan and apply to import the default route table, then comment it out or delete it
#
# import {
#   to = aws_route_table.existing_rt
#   id = aws_vpc.nextwork_vpc.default_route_table_id
# }

resource "aws_route_table" "existing_rt" {
  vpc_id = aws_vpc.nextwork_vpc.id
  tags = {
    Name = "NextWork route table"
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
