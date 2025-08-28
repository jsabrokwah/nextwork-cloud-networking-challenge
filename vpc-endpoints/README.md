# VPC Endpoints

This directory contains Terraform configuration for creating AWS VPC endpoints to enable secure, private connectivity to AWS services without internet gateway routing.

## Architecture

The infrastructure creates:
- **VPC** with DNS support enabled
- **Public subnet** with internet gateway access
- **S3 VPC Endpoint** for private S3 access
- **EC2 instance** to test endpoint connectivity
- **S3 bucket** with endpoint-only access policy

## Resources Created

### Networking
- VPC (10.0.0.0/16)
- Internet Gateway
- Public subnet (10.0.0.0/24)
- Route table with internet access
- Security group (HTTP/SSH access)
- Network ACL (allow all)

### VPC Endpoint
- S3 Gateway Endpoint attached to route table
- Restricts S3 access to VPC traffic only

### Compute & Storage
- EC2 instance (t2.micro, Amazon Linux 2)
- S3 bucket with VPC endpoint policy

## Files

- `main.tf` - Core infrastructure resources
- `variables.tf` - Input variables (region, CIDR blocks)
- `outputs.tf` - Resource IDs and connection details
- `terraform.tfvars` - Variable values

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Key Features

- **Private S3 Access**: S3 traffic routes through VPC endpoint, not internet
- **Security Policy**: S3 bucket denies access from outside VPC endpoint
- **Cost Optimization**: No data transfer charges for S3 access via endpoint

## Testing

SSH to EC2 instance and test S3 access:
```bash
aws s3 ls s3://nextwork-vpc-project-jsabrokwah-jksdkeq
```

Traffic flows through VPC endpoint, ensuring private connectivity.