# 🏗️ Terraform Multi-Environment AWS Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-v1.x-7B42BC?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Infrastructure as Code (IaC)** using Terraform to provision and manage **multi-environment AWS infrastructure** — Dev, Staging, and Production — from a single codebase.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Environments](#environments)
- [AWS Resources](#aws-resources)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

---

## 🌐 Overview

This project demonstrates how to use **Terraform** to create a complete, scalable AWS infrastructure across three isolated environments using reusable modules and environment-specific variable files. The goal is to maintain **consistency**, **repeatability**, and **separation of concerns** across all deployment stages.

Key highlights:
- Single Terraform codebase for all environments
- Environment-specific `.tfvars` files for configuration
- Remote state management via AWS S3
- DRY (Don't Repeat Yourself) principle using Terraform modules

---

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Multi-Environment Setup                   │
├───────────────────┬───────────────────┬─────────────────────────┤
│      DEV          │     STAGING        │      PRODUCTION         │
│                   │                   │                         │
│  ┌────┐ ┌────┐   │  ┌────┐ ┌────┐   │  ┌────┐ ┌────┐         │
│  │ S3 │ │ DB │   │  │ S3 │ │ DB │   │  │ S3 │ │ S3 │ ┌────┐  │
│  └────┘ └────┘   │  └────┘ └────┘   │  └────┘ └────┘ │ DB │  │
│       ┌─────┐    │       ┌─────┐    │                  └────┘  │
│       │ EC2 │    │       │ EC2 │    │  ┌─────┐ ┌─────┐ ┌────┐ │
│       └─────┘    │       └─────┘    │  │ EC2 │ │ EC2 │ │EC2 │ │
│                   │                   │  └─────┘ └─────┘ └────┘ │
└───────────────────┴───────────────────┴─────────────────────────┘
```

---

## 🌍 Environments

| Environment | Purpose | Scale |
|-------------|---------|-------|
| **DEV** | Development & testing | Small (t2.micro) |
| **STG** | Staging / pre-production | Medium (t2.small) |
| **PRD** | Production / live traffic | Large (t2.medium+, multi-instance) |

Each environment is fully isolated with its own:
- AWS resources
- Terraform state file
- Variable configuration

---

## ☁️ AWS Resources Provisioned

### DEV & Staging
| Resource | Description |
|----------|-------------|
| **EC2 Instance** | Application server |
| **S3 Bucket** | Object storage |
| **RDS / DB** | Relational database |

### Production (PRD)
| Resource | Count | Description |
|----------|-------|-------------|
| **EC2 Instances** | 3 | Load-distributed application servers |
| **S3 Buckets** | 2 | Primary + backup storage |
| **RDS / DB** | 1 | Production-grade database |

---

## ✅ Prerequisites

Before you begin, make sure you have the following installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.0`
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with credentials
- An AWS account with appropriate IAM permissions
- An S3 bucket for Terraform remote state (optional but recommended)

```bash
# Verify installations
terraform -v
aws --version
aws sts get-caller-identity
```

---

## 📁 Project Structure

```
terraform-multi-environment-aws/
│
├── modules/                    # Reusable Terraform modules
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── rds/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── stg/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prd/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── backend.tf                  # Remote state configuration
├── provider.tf                 # AWS provider configuration
└── README.md
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/sidhi6276/terraform-multi-environment-aws.git
cd terraform-multi-environment-aws
```

### 2. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
```

### 3. Navigate to the Target Environment

```bash
# For DEV
cd environments/dev

# For Staging
cd environments/stg

# For Production
cd environments/prd
```

---

## 🛠️ Usage

Run these commands inside the desired environment directory:

### Initialize Terraform

```bash
terraform init
```

### Preview the Changes

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

> Type `yes` when prompted to confirm.

### Destroy Infrastructure

```bash
terraform destroy
```

> ⚠️ **Warning:** This will permanently delete all provisioned resources. Use with caution in production.

---

## 🔧 Environment Variables

Each environment has a `terraform.tfvars` file. Customize these values before deploying:

```hcl
# Example: environments/dev/terraform.tfvars

environment    = "dev"
region         = "us-east-1"
instance_type  = "t2.micro"
db_name        = "myapp_dev"
s3_bucket_name = "myapp-dev-storage"
```

```hcl
# Example: environments/prd/terraform.tfvars

environment    = "prd"
region         = "us-east-1"
instance_type  = "t2.medium"
instance_count = 3
db_name        = "myapp_prod"
s3_bucket_name = "myapp-prd-storage"
```

---

## 💡 Best Practices Followed

- **Modular Design** — Resources are abstracted into reusable modules
- **Remote State** — Terraform state stored in S3 for team collaboration
- **Environment Isolation** — Each env has its own state file and variables
- **Naming Convention** — Resources tagged with environment prefix (e.g., `dev-ec2`, `prd-s3`)
- **DRY Principle** — No code duplication across environments
- **Least Privilege** — IAM roles configured with minimal required permissions

---

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add: your feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Sidhi**
- GitHub: [@sidhi6276](https://github.com/sidhi6276)

---

> Made with ❤️ using Terraform & AWS | *"Infrastructure should be code, not clicks."*
