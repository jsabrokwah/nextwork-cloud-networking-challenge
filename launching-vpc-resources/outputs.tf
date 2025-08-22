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

output "private_subnet_1_id" {
  description = "ID of the Private Subnet 1"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_1_cidr_block" {
  description = "CIDR block of the Private Subnet 1"
  value       = aws_subnet.private_subnet_1.cidr_block
}

output "private_subnet_1_az" {
  description = "Availability Zone of the Private Subnet 1"
  value       = aws_subnet.private_subnet_1.availability_zone
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the NextWork Security Group"
  value       = aws_security_group.nextwork_security_group.id
}

output "security_group_name" {
  description = "Name of the NextWork Security Group"
  value       = aws_security_group.nextwork_security_group.name
}

# Output the actual default route table ID
output "default_route_table_id" {
  value = aws_vpc.nextwork_vpc.default_route_table_id
}
output "availability_zone" {
  description = "Availability Zone where resources are created"
  value       = data.aws_availability_zones.available.names[0]
}

# Network ACL Outputs
output "network_acl_id" {
  description = "ID of the NextWork Network ACL"
  value       = aws_network_acl.nextwork_network_acl.id
}

output "network_acl_name" {
  description = "Name of the NextWork Network ACL"
  value       = aws_network_acl.nextwork_network_acl.tags["Name"]
}
