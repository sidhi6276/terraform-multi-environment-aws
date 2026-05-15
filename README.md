🏗️ Terraform Multi-Environment AWS Infrastructure

Infrastructure as Code (IaC) using Terraform to provision and manage multi-environment AWS infrastructure — Dev, Staging, and Production — from a single codebase.


📋 Table of Contents

Overview
Architecture
Environments
AWS Resources
Prerequisites
Project Structure
Getting Started
Usage
Environment Variables
Best Practices
Contributing


🌐 Overview
This project demonstrates how to use Terraform to create a complete, scalable AWS infrastructure across three isolated environments using reusable modules and environment-specific variable files. The goal is to maintain consistency, repeatability, and separation of concerns across all deployment stages.
Key highlights:

Single Terraform codebase for all environments
Environment-specific .tfvars files for configuration
Remote state management via AWS S3
DRY (Don't Repeat Yourself) principle using Terraform modules


🏛️ Architecture
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

🌍 Environments
EnvironmentPurposeScaleDEVDevelopment & testingSmall (t2.micro)STGStaging / pre-productionMedium (t2.small)PRDProduction / live trafficLarge (t2.medium+, multi-instance)
Each environment is fully isolated with its own:

AWS resources
Terraform state file
Variable configuration


☁️ AWS Resources Provisioned
DEV & Staging
ResourceDescriptionEC2 InstanceApplication serverS3 BucketObject storageRDS / DBRelational database
Production (PRD)
ResourceCountDescriptionEC2 Instances3Load-distributed application serversS3 Buckets2Primary + backup storageRDS / DB1Production-grade database

✅ Prerequisites
Before you begin, make sure you have the following installed and configured:

Terraform >= 1.0
AWS CLI configured with credentials
An AWS account with appropriate IAM permissions
An S3 bucket for Terraform remote state (optional but recommended)

bash# Verify installations
terraform -v
aws --version
aws sts get-caller-identity

📁 Project Structure
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

🚀 Getting Started
1. Clone the Repository
bashgit clone https://github.com/sidhi6276/terraform-multi-environment-aws.git
cd terraform-multi-environment-aws
2. Configure AWS Credentials
bashaws configure
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
3. Navigate to the Target Environment
bash# For DEV
cd environments/dev

# For Staging
cd environments/stg

# For Production
cd environments/prd

🛠️ Usage
Run these commands inside the desired environment directory:
Initialize Terraform
bashterraform init
Preview the Changes
bashterraform plan
Apply Infrastructure
bashterraform apply

Type yes when prompted to confirm.

Destroy Infrastructure
bashterraform destroy

⚠️ Warning: This will permanently delete all provisioned resources. Use with caution in production.


🔧 Environment Variables
Each environment has a terraform.tfvars file. Customize these values before deploying:
hcl# Example: environments/dev/terraform.tfvars

environment    = "dev"
region         = "us-east-1"
instance_type  = "t2.micro"
db_name        = "myapp_dev"
s3_bucket_name = "myapp-dev-storage"
hcl# Example: environments/prd/terraform.tfvars

environment    = "prd"
region         = "us-east-1"
instance_type  = "t2.medium"
instance_count = 3
db_name        = "myapp_prod"
s3_bucket_name = "myapp-prd-storage"

👤 Author
Sidhi

GitHub: @sidhi6276
