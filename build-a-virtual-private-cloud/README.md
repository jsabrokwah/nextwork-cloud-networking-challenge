# NextWork Virtual Private Cloud

This Terraform configuration creates a basic AWS VPC infrastructure for the NextWork project.

## Infrastructure Components

- **VPC**: NextWork VPC with CIDR block 10.0.0.0/16
- **Internet Gateway**: NextWork IG attached to the VPC
- **Public Subnet**: Public 1 subnet with CIDR block 10.0.0.0/24 in the first available AZ

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0 or later)

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. To destroy the infrastructure when no longer needed:
   ```bash
   terraform destroy
   ```

## Outputs

After successful deployment, the following outputs will be available:
- VPC ID
- VPC CIDR block
- Internet Gateway ID
- Public Subnet 1 ID
- Public Subnet 1 CIDR block
- Availability Zone used

## File Structure

- `main.tf`: Main Terraform configuration
- `variables.tf`: Variable definitions
- `outputs.tf`: Output definitions
- `terraform.tfvars`: Variable values
- `.gitignore`: Git ignore file for Terraform
