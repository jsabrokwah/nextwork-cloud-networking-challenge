# VPC Outputs
output "vpc_id" {
  description = "ID of the NextWork VPC"
  value       = aws_vpc.nextwork_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the NextWork VPC"
  value       = aws_vpc.nextwork_vpc.cidr_block
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the NextWork Internet Gateway"
  value       = aws_internet_gateway.nextwork_ig.id
}

# Subnet Outputs
output "public_subnet_1_id" {
  description = "ID of the Public Subnet 1"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_1_cidr_block" {
  description = "CIDR block of the Public Subnet 1"
  value       = aws_subnet.public_subnet_1.cidr_block
}

output "availability_zone" {
  description = "Availability Zone where resources are created"
  value       = data.aws_availability_zones.available.names[0]
}
