# Terraform AWS VPC and EC2 Mini Project

This mini project provisions a basic AWS infrastructure using Terraform.

## Architecture
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance (with user data)
- ALB
- S3
- IAM

## Architecture Diagram
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/9c547697-666a-4081-b502-18f42f2aea6c" />


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
