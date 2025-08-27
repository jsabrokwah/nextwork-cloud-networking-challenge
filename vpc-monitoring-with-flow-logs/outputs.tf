# Output VPC 1 Information
output "vpc_1_id" {
  description = "ID of VPC 1"
  value       = aws_vpc.nextwork_vpc_1.id
}

output "vpc_1_cidr_block" {
  description = "CIDR block of VPC 1"
  value       = aws_vpc.nextwork_vpc_1.cidr_block
}

# Output VPC 2 Information
output "vpc_2_id" {
  description = "ID of VPC 2"
  value       = aws_vpc.nextwork_vpc_2.id
}

output "vpc_2_cidr_block" {
  description = "CIDR block of VPC 2"
  value       = aws_vpc.nextwork_vpc_2.cidr_block
}

# Output Public Subnet Information
output "public_subnet_1_id" {
  description = "ID of Public Subnet 1 in VPC 1"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "ID of Public Subnet 2 in VPC 2"
  value       = aws_subnet.public_subnet_2.id
}

# Output Internet Gateway Information
output "internet_gateway_1_id" {
  description = "ID of Internet Gateway for VPC 1"
  value       = aws_internet_gateway.nextwork_ig_1.id
}

output "internet_gateway_2_id" {
  description = "ID of Internet Gateway for VPC 2"
  value       = aws_internet_gateway.nextwork_ig_2.id
}

# Output Route Table Information
output "public_route_table_1_id" {
  description = "ID of Public Route Table for VPC 1"
  value       = aws_route_table.public_rt_1.id
}

output "public_route_table_2_id" {
  description = "ID of Public Route Table for VPC 2"
  value       = aws_route_table.public_rt_2.id
}

# Output VPC Peering Connection Information
output "vpc_peering_connection_id" {
  description = "ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.vpc_peering.id
}

output "vpc_peering_connection_status" {
  description = "Status of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.vpc_peering.accept_status
}

# Output EC2 Instance Information
output "vpc_1_instance_id" {
  description = "ID of EC2 instance in VPC 1"
  value       = aws_instance.nextwork_vpc_1_instance.id
}

output "vpc_1_instance_public_ip" {
  description = "Public IP address of EC2 instance in VPC 1"
  value       = aws_instance.nextwork_vpc_1_instance.public_ip
}

output "vpc_2_instance_id" {
  description = "ID of EC2 instance in VPC 2"
  value       = aws_instance.nextwork_vpc_2_instance.id
}

output "vpc_2_instance_public_ip" {
  description = "Public IP address of EC2 instance in VPC 2"
  value       = aws_instance.nextwork_vpc_2_instance.public_ip
}

# Output Security Group Information
output "vpc_1_instance_sg_id" {
  description = "ID of Security Group for VPC 1 instance"
  value       = aws_security_group.vpc_1_instance_sg.id
}

output "vpc_2_instance_sg_id" {
  description = "ID of Security Group for VPC 2 instance"
  value       = aws_security_group.vpc_2_instance_sg.id
}

# Output CloudWatch Log Group Information
output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.NextWorkVPCFlowLogsGroup.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for VPC Flow Logs"
  value       = aws_cloudwatch_log_group.NextWorkVPCFlowLogsGroup.name
}

# Output IAM Role and Policy Information
output "iam_role_arn" {
  description = "ARN of the IAM Role for VPC Flow Logs"
  value       = aws_iam_role.NextWorkVPCFlowLogsRole.arn
}

output "iam_role_name" {
  description = "Name of the IAM Role for VPC Flow Logs"
  value       = aws_iam_role.NextWorkVPCFlowLogsRole.name
}

output "iam_policy_arn" {
  description = "ARN of the IAM Policy for VPC Flow Logs"
  value       = aws_iam_policy.NextWorkVPCFlowLogsPolicy.arn
}

output "iam_policy_name" {
  description = "Name of the IAM Policy for VPC Flow Logs"
  value       = aws_iam_policy.NextWorkVPCFlowLogsPolicy.name
}

# Output VPC Flow Log Information
output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = aws_flow_log.NextWorkVPCFlowLog.id
}
