# Terraform AWS VPC and EC2 Mini Project

This mini project provisions a basic AWS infrastructure using Terraform.

## Architecture
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance (with user data)

## Files
- `main.tf` – Defines AWS resources
- `provider.tf` – AWS provider configuration
- `variables.tf` – Input variables
- `user_data.sh` – EC2 bootstrap script

## Prerequisites
- AWS account
- Terraform installed
- AWS CLI configured

## How to Run
```bash
terraform init
terraform plan
terraform apply
