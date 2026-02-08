# AWS Production Architecture – Highly Available Web Application

This repository documents a **production-grade AWS architecture** commonly used in real-world environments to host **secure, highly available, and scalable web applications**.

The design follows **AWS Well-Architected Framework best practices** and reflects how applications are deployed in **enterprise AWS production environments**.
 
---

## 🏗️ Architecture Overview

The architecture is deployed within a **single AWS Region** and spans **multiple Availability Zones (AZs)** to ensure fault tolerance and high availability.

### Key characteristics:
- Internet-facing **Application Load Balancer (ALB)**
- **EC2 instances** running Apache Web Server
- EC2 instances placed in **private subnets**
- **NAT Gateways** for controlled outbound access
- **Auto Scaling Group** for resilience and scalability
- Strict **security group** rules following least-privilege principles

---

## 🧩 Core AWS Components

- **Amazon VPC** – isolated virtual network
- **Public Subnets** – host ALB and NAT Gateways
- **Private Subnets** – host EC2 application servers
- **Application Load Balancer** – distributes traffic and performs health checks
- **Auto Scaling Group** – maintains desired instance count and replaces unhealthy instances
- **NAT Gateway** – enables outbound internet access for private instances
- **Security Groups** – control inbound and outbound traffic
- **Optional integrations** – Amazon S3 (via VPC Endpoint), CloudWatch, ACM

---

## 🔐 Security Best Practices

- No public IPs on application servers
- Internet traffic terminates at the ALB
- EC2 instances accept traffic **only from the ALB**
- SSH access restricted to bastion host or trusted IPs
- IAM roles used instead of static credentials

---

## 🚀 Why This Architecture Is Used in Production

This architecture is widely adopted in AWS production environments because it:

- Survives Availability Zone failures
- Scales horizontally without downtime
- Minimizes attack surface
- Supports rolling deployments and blue/green strategies
- Aligns with AWS networking and security best practices

---

## 📊 Architecture Diagram

<img width="1536" height="1024" alt="f5a9369f-1f03-4f13-b4c4-03b2b5a54904" src="https://github.com/user-attachments/assets/db949a02-e114-4b87-be39-8690b86ab249" />



---

## 📄 Detailed Implementation Guide

A complete **step-by-step implementation guide** is included as a PDF document.

📘 **AWS Production Architecture – Implementation Steps**  
➡️ [View the full PDF guide](production-environment/aws-console/AWS_production-infra.docx)

The document covers:
- VPC and subnet creation
- Internet Gateway and NAT Gateway setup
- Application Load Balancer configuration
- Target groups and health checks
- EC2 setup in private subnets
- Apache web server configuration
- Security group rules
- Troubleshooting and validation steps

> This project includes real troubleshooting scenarios encountered during implementation,
> reflecting challenges commonly faced in AWS production environments.
