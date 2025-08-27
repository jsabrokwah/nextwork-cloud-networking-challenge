# VPC Peering

This Terraform configuration creates two VPCs with a VPC peering connection and EC2 instances for connectivity testing.

## VPC Configuration

### VPC 1 (NextWork-1)

- **CIDR Block**: 10.1.0.0/16
- **Name Tag**: NextWork-1
- **Public Subnets**: 1 (10.1.0.0/24)
- **Private Subnets**: 0
- **NAT Gateways**: None

### VPC 2 (NextWork-2)

- **CIDR Block**: 10.2.0.0/16
- **Name Tag**: NextWork-2
- **Public Subnets**: 1 (10.2.0.0/24)
- **Private Subnets**: 0
- **NAT Gateways**: None

## VPC Peering Configuration

The configuration establishes a VPC peering connection between VPC 1 and VPC 2 with the following features:

- **Auto-accept**: Enabled for automatic peering connection acceptance
- **Route Configuration**: Routes are automatically added to both VPC route tables
  - VPC 1 route table: Route to VPC 2 CIDR (10.2.0.0/16) via peering connection
  - VPC 2 route table: Route to VPC 1 CIDR (10.1.0.0/16) via peering connection

## EC2 Instances for Connectivity Testing

Each VPC contains an EC2 instance for testing connectivity:

### VPC 1 Instance

- **AMI**: Amazon Linux 2 (ami-00ca32bbc84273381)
- **Instance Type**: t2.micro
- **Subnet**: Public Subnet 1 (10.1.0.0/24)
- **Security Group**: vpc-1-instance-sg
- **Key Pair**: None (proceed without key pair)

### VPC 2 Instance

- **AMI**: Amazon Linux 2 (ami-00ca32bbc84273381)
- **Instance Type**: t2.micro
- **Subnet**: Public Subnet 2 (10.2.0.0/24)
- **Security Group**: vpc-2-instance-sg
- **Key Pair**: None (proceed without key pair)

## Security Group Configuration

### VPC 1 Instance Security Group

- **SSH Access**: Allowed from anywhere (0.0.0.0/0)
- **ICMP (ping)**: Allowed from VPC 2 CIDR (10.2.0.0/16)
- **Outbound Traffic**: Allowed to anywhere

### VPC 2 Instance Security Group

- **SSH Access**: Allowed from VPC 2 CIDR (10.2.0.0/16)
- **ICMP (ping)**: Allowed from anywhere (0.0.0.0/0)
- **Outbound Traffic**: Allowed to anywhere

## Resources Created

Each VPC includes:

- VPC with DNS support enabled
- Internet Gateway
- Public subnet in a different availability zone
- Route table with internet access
- Route table association
- VPC peering connection
- EC2 instance for connectivity testing
- Security groups for connectivity testing

## Usage

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Plan the deployment:

   ```bash
   terraform plan
   ```

3. Apply the configuration:

   ```bash
   terraform apply
   ```

4. View outputs (includes instance public IPs for testing):

   ```bash
   terraform output
   ```

## Testing Connectivity

After deployment, you can test the VPC peering connectivity:

1. **Ping Test**: From VPC 1 instance, ping the private IP of VPC 2 instance
2. **VPC Peering Status**: Check the peering connection status in AWS Console
3. **Route Verification**: Verify routes are properly configured in both route tables

## Outputs

The configuration provides the following outputs:

- **VPC Information**: IDs and CIDR blocks for both VPCs
- **Subnet Information**: IDs of public subnets
- **Internet Gateway Information**: IDs of internet gateways
- **Route Table Information**: IDs of public route tables
- **VPC Peering Information**: Connection ID and status
- **EC2 Instance Information**: Instance IDs and public IP addresses
- **Security Group Information**: Security group IDs

## Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Configuration variables
- `outputs.tf` - Output values for created resources

## Notes

- The VPCs are configured with unique CIDR blocks (10.1.0.0/16 and 10.2.0.0/16) to avoid conflicts
- No NAT gateways are created to minimize costs as requested
- Each VPC has one public subnet with internet access
- Subnets are placed in different availability zones for high availability
- VPC peering is configured with auto-accept for seamless connection establishment
- EC2 instances are deployed without key pairs for simplified testing
- Security groups are configured to allow connectivity testing between VPCs
