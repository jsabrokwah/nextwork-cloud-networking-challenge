# AWS Region
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# VPC 1 Configuration
variable "vpc_1_cidr" {
  description = "CIDR block for VPC 1"
  type        = string
  default     = "10.1.0.0/16"
}

# VPC 2 Configuration
variable "vpc_2_cidr" {
  description = "CIDR block for VPC 2"
  type        = string
  default     = "10.2.0.0/16"
}

# Public Subnet 1 Configuration
variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1 in VPC 1"
  type        = string
  default     = "10.1.0.0/24"
}

# Public Subnet 2 Configuration
variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2 in VPC 2"
  type        = string
  default     = "10.2.0.0/24"
}

# EC2 Instance Configuration
variable "instance_ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-00ca32bbc84273381" # Amazon Linux 2 AMI in us-east-1
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}
