# VPC Monitoring with Flow Logs

This Terraform configuration sets up comprehensive VPC flow logs monitoring for AWS VPC infrastructure. It creates all necessary AWS resources to capture and analyze network traffic using VPC Flow Logs.

## Architecture

The solution includes:
- Two VPCs with public subnets
- Internet Gateways for internet connectivity
- VPC peering connection between the VPCs
- EC2 instances in each VPC for testing
- CloudWatch Log Group for storing flow logs
- IAM role and policy for VPC Flow Logs service
- VPC Flow Log configured to capture all traffic

## Resources Created

### Networking
- **VPC 1**: `NextWork-1` (10.1.0.0/16)
- **VPC 2**: `NextWork-2` (10.2.0.0/16)
- **Public Subnets**: One in each VPC
- **Internet Gateways**: For each VPC
- **Route Tables**: Public route tables with internet access
- **VPC Peering**: Connection between VPC 1 and VPC 2

### Monitoring & Logging
- **CloudWatch Log Group**: `NextWorkVPCFlowLogsGroup` - Stores VPC flow logs
- **IAM Role**: `NextWorkVPCFlowLogsRole` - Service role for VPC Flow Logs
- **IAM Policy**: `NextWorkVPCFlowLogsPolicy` - Permissions for CloudWatch Logs access
- **VPC Flow Log**: `NextWorkVPCFlowLog` - Captures all traffic in public subnet 1

### Compute
- **EC2 Instances**: t2.micro instances in each public subnet for connectivity testing

## Configuration

### VPC Flow Log Settings
- **Traffic Type**: ALL (captures all traffic)
- **Aggregation Interval**: 1 minute
- **Destination**: CloudWatch Logs
- **Log Group**: NextWorkVPCFlowLogsGroup
- **IAM Role**: NextWorkVPCFlowLogsRole

### IAM Permissions
The IAM policy grants the following permissions to the VPC Flow Logs service:
- `logs:CreateLogGroup`
- `logs:CreateLogStream`
- `logs:PutLogEvents`
- `logs:DescribeLogGroups`
- `logs:DescribeLogStreams`

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review plan**:
   ```bash
   terraform plan
   ```

3. **Apply configuration**:
   ```bash
   terraform apply
   ```

4. **View outputs** (after apply):
   ```bash
   terraform output
   ```

## Outputs

After successful deployment, the following outputs will be available:

- VPC IDs and CIDR blocks
- Subnet IDs
- Internet Gateway IDs
- Route Table IDs
- VPC Peering Connection details
- EC2 Instance IDs and public IPs
- Security Group IDs
- CloudWatch Log Group ARN and name
- IAM Role ARN and name
- IAM Policy ARN and name
- VPC Flow Log ID

## Variables

Configuration can be customized using the following variables in `terraform.tfvars`:

- `aws_region`: AWS region (default: us-east-1)
- `vpc_1_cidr`: CIDR for VPC 1 (default: 10.1.0.0/16)
- `vpc_2_c极R`: CIDR for VPC 2 (default: 10.2.0.0/16)
- `public_subnet_1_cidr`: CIDR for public subnet 1 (default: 10.1.0.极/24)
- `public_subnet_2_cidr`: CIDR for public subnet 2 (default: 10.2.0.0/24)
- `instance_ami`: AMI ID for EC2 instances
- `instance_type`: Instance type for EC2 instances (default: t2.micro)

## Monitoring

Once deployed, VPC flow logs will be automatically captured and stored in the CloudWatch log group. You can:

1. View logs in AWS CloudWatch Console
2. Create CloudWatch dashboards for traffic monitoring
3. Set up alarms for specific traffic patterns
4. Analyze network traffic patterns and security events

## Cleanup

To remove all created resources:
```bash
terraform destroy
```

## Notes

- The VPC flow log is configured on public subnet 1 only
- Traffic is captured with 1-minute aggregation for detailed monitoring
- All resources are tagged for easy identification and cost tracking
- The configuration uses existing AWS best practices for VPC flow logs
