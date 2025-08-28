# NextWork Cloud Networking Challenge

A comprehensive collection of AWS VPC networking challenges implemented with Terraform, covering essential cloud networking concepts from basic VPC creation to advanced monitoring and security configurations.

## 🎯 Project Overview

This repository contains 9 hands-on challenges designed to build expertise in AWS VPC networking. Each challenge focuses on specific networking concepts and builds upon previous knowledge to create a complete understanding of cloud networking architecture.

## 📋 Challenge Modules

### 1. [Build a Virtual Private Cloud](./build-a-virtual-private-cloud/)
**Concepts**: VPC fundamentals, CIDR blocks, Internet Gateway
- Create basic VPC infrastructure (10.0.0.0/16)
- Configure Internet Gateway for public access
- Set up public subnet with internet connectivity

### 2. [Creating a Private Subnet](./creating-a-private-subnet/)
**Concepts**: Network segmentation, private subnets, security isolation
- Implement public/private subnet architecture
- Configure separate route tables for network isolation
- Apply security groups and NACLs for traffic control

### 3. [Access S3 from a VPC](./access-s3-from-a-vpc/)
**Concepts**: AWS service integration, EC2-S3 connectivity
- Deploy EC2 instances within VPC
- Configure S3 access from VPC resources
- Implement basic compute and storage integration

### 4. [Launching VPC Resources](./launching-vpc-resources/)
**Concepts**: Resource deployment, instance configuration
- Launch and configure EC2 instances in VPC
- Implement proper security group configurations
- Test resource connectivity and access

### 5. [Testing VPC Connectivity](./testing-vpc-connectivity/)
**Concepts**: Network testing, connectivity validation
- Deploy instances in public and private subnets
- Validate inter-subnet communication
- Test internet connectivity from different network zones

### 6. [VPC Traffic Flow and Security](./vpc-traffic-flow-and-security/)
**Concepts**: Traffic analysis, security controls
- Implement advanced security group rules
- Configure network ACLs for subnet-level security
- Analyze and control traffic flow patterns

### 7. [VPC Peering](./vpc-peering/)
**Concepts**: Inter-VPC communication, network peering
- Create multiple VPCs with unique CIDR blocks
- Establish VPC peering connections
- Configure cross-VPC routing and security

### 8. [VPC Endpoints](./vpc-endpoints/)
**Concepts**: Private service access, cost optimization
- Implement S3 VPC Gateway Endpoint
- Configure private AWS service connectivity
- Eliminate internet gateway dependency for AWS services

### 9. [VPC Monitoring with Flow Logs](./vpc-monitoring-with-flow-logs/)
**Concepts**: Network monitoring, traffic analysis, CloudWatch integration
- Configure VPC Flow Logs for traffic capture
- Set up CloudWatch Logs integration
- Implement network monitoring and analysis

## 🏗️ Architecture Patterns

### Network Design Principles
- **CIDR Planning**: Non-overlapping address spaces (10.x.x.x/16)
- **Multi-AZ Deployment**: High availability across availability zones
- **Security Layering**: Security groups + NACLs for defense in depth
- **Cost Optimization**: Efficient resource utilization and endpoint usage

### Common Components
- **VPCs**: Isolated network environments with DNS support
- **Subnets**: Public (internet-facing) and private (isolated) subnets
- **Gateways**: Internet Gateways for public connectivity
- **Security**: Security groups (stateful) and NACLs (stateless)
- **Routing**: Custom route tables for traffic control

## 🚀 Quick Start

### Prerequisites
- AWS account with appropriate permissions
- AWS CLI configured with credentials
- Terraform >= 1.0 installed
- SSH key pair "NextWorkChallenge" in AWS (for applicable challenges)

### General Usage Pattern
```bash
# Navigate to any challenge directory
cd <challenge-directory>

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy infrastructure
terraform apply

# View outputs
terraform output

# Clean up resources
terraform destroy
```

## 📁 Project Structure

```
nextwork-cloud-networking/
├── build-a-virtual-private-cloud/     # Challenge 1: Basic VPC
├── creating-a-private-subnet/         # Challenge 2: Private networking
├── access-s3-from-a-vpc/             # Challenge 3: S3 integration
├── launching-vpc-resources/           # Challenge 4: Resource deployment
├── testing-vpc-connectivity/          # Challenge 5: Connectivity testing
├── vpc-traffic-flow-and-security/     # Challenge 6: Security controls
├── vpc-peering/                       # Challenge 7: Inter-VPC communication
├── vpc-endpoints/                     # Challenge 8: Private service access
├── vpc-monitoring-with-flow-logs/     # Challenge 9: Network monitoring
└── README.md                          # This documentation
```

### Standard File Structure (per challenge)
```
challenge-directory/
├── main.tf              # Core Terraform configuration
├── variables.tf         # Input variable definitions
├── outputs.tf           # Output value definitions
├── terraform.tfvars     # Variable value assignments
├── README.md           # Challenge-specific documentation
├── architecture.png    # Network architecture diagram
├── .gitignore          # Terraform ignore rules
└── .terraform/         # Terraform working directory
```

## 🔧 Configuration Management

### Common Variables
| Variable | Description | Typical Values |
|----------|-------------|----------------|
| `aws_region` | AWS deployment region | us-east-1, us-west-2 |
| `vpc_cidr` | VPC CIDR block | 10.0.0.0/16, 10.1.0.0/16 |
| `public_subnet_cidr` | Public subnet CIDR | 10.x.0.0/24 |
| `private_subnet_cidr` | Private subnet CIDR | 10.x.1.0/24 |

### Customization
Each challenge can be customized by modifying `terraform.tfvars`:
```hcl
aws_region = "us-west-2"
vpc_cidr = "192.168.0.0/16"
public_subnet_1_cidr = "192.168.1.0/24"
```

## 🔒 Security Best Practices

### Network Security
- **Principle of Least Privilege**: Minimal required access in security groups
- **Defense in Depth**: Multiple security layers (SG + NACL)
- **Network Segmentation**: Separate public/private subnets
- **Traffic Monitoring**: VPC Flow Logs for visibility

### Access Control
- **SSH Key Management**: Secure key pair usage
- **CIDR Restrictions**: Limit source IP ranges where possible
- **Service-Specific Rules**: Targeted port and protocol access

## 📊 Monitoring and Troubleshooting

### Common Debugging Commands
```bash
# Check VPC status
aws ec2 describe-vpcs --vpc-ids <vpc-id>

# Verify subnet configuration
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>"

# Review route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<vpc-id>"

# Check security groups
aws ec2 describe-security-groups --group-ids <sg-id>
```

### Troubleshooting Tips
- Verify AWS credentials and permissions
- Check for CIDR block conflicts
- Validate security group and NACL rules
- Review route table configurations
- Monitor VPC Flow Logs for traffic analysis

## 💰 Cost Considerations

### Resource Optimization
- **Instance Types**: Use t2.micro (free tier eligible) for testing
- **VPC Endpoints**: Reduce data transfer costs for AWS services
- **Resource Cleanup**: Always destroy test environments
- **Monitoring**: Track usage to avoid unexpected charges

### Cost-Effective Practices
- Leverage free tier resources where possible
- Use VPC endpoints to minimize data transfer costs
- Implement proper resource tagging for cost allocation
- Regular cleanup of unused resources

## 🎓 Learning Path

### Recommended Order
1. **Foundation**: Start with basic VPC creation
2. **Segmentation**: Learn private subnet concepts
3. **Integration**: Understand service connectivity
4. **Advanced**: Explore peering and endpoints
5. **Monitoring**: Implement observability

### Skills Developed
- AWS VPC architecture and design
- Network security implementation
- Terraform infrastructure as code
- Cloud networking troubleshooting
- Cost optimization strategies

## 📚 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-best-practices.html)
- [AWS Networking Fundamentals](https://aws.amazon.com/getting-started/hands-on/build-vpc-with-public-private-subnets/)

## 🤝 Contributing

Each challenge is self-contained and can be enhanced independently. When contributing:
- Follow existing Terraform formatting standards
- Update documentation for any architectural changes
- Test configurations in multiple AWS regions
- Maintain cost-effective resource selections

## 📄 License

This project is designed for educational purposes as part of the NextWork Cloud Networking Challenge series.