# Terraform AWS Production infrastructure Project

This project provisions a complete AWS infrastructure using **Terraform**, including a VPC with public and private subnets, a bastion host, an Application Load Balancer (ALB), and multiple EC2 instances serving traffic behind the ALB.

The goal of this project is to demonstrate a **production-style AWS architecture** with proper networking, security boundaries, and load balancing.

---

## 🏗 Architecture Overview

The infrastructure includes:

- VPC with CIDR `10.0.0.0/16`
- 2 Public Subnets (Multi-AZ)
- 2 Private Subnets (Multi-AZ)
- Internet Gateway for public access
- NAT Gateway for private subnet outbound traffic
- Bastion Host in a public subnet
- 2 Web EC2 Instances in private subnets
- Application Load Balancer (ALB) in public subnets
- Target Group with health checks
- Security Groups for SSH and HTTP access



