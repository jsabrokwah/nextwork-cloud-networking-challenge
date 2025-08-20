# AWS Region
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet Configuration
variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.0.0/24"
}

# Private Subnet Configuration
variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1 - for investigation purposes"
  type        = string
  default     = "10.0.1.0/24"  # Using 10.0.1.0/24 to avoid overlap
}

