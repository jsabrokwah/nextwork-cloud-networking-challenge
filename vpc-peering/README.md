# VPC Peering Configuration

This Terraform configuration creates two VPCs for peering purposes as specified in the requirements.

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

## Resources Created

Each VPC includes:
- VPC with DNS support enabled
- Internet Gateway
- Public subnet in a different availability zone
- Route table with internet access
- Route table association

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

4. View outputs:
   ```bash
   terraform output
   ```

## Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Configuration variables
- `outputs.tf` - Output values for created resources

## Notes

- The VPCs are configured with unique CIDR blocks (10.1.0.0/16 and 10.2.0.0/16) to avoid conflicts
- No NAT gateways are created to minimize costs as requested
- Each VPC has one public subnet with internet access
- Subnets are placed in different availability zones for high availability
