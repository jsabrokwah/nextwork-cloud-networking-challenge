# Access S3 from a VPC

This Terraform configuration creates AWS infrastructure to access S3 from within a VPC.

## Resources Created

- **VPC**: NextWork VPC with DNS support
- **Internet Gateway**: For public internet access
- **Public Subnet**: Single public subnet in first AZ
- **Route Table**: Default route table with internet gateway route
- **Security Group**: Allows HTTP (80) and SSH (22) inbound, all outbound
- **Network ACL**: Allows all traffic
- **EC2 Instance**: Amazon Linux 2 t2.micro in public subnet
- **S3 Bucket**: `nextwork-vpc-project-jsabrokwah`

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Requirements

- AWS CLI configured
- Terraform installed
- Key pair "NextWorkChallenge" must exist in AWS