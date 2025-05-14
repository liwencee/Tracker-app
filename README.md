# Task Tracker App – CI/CD Pipeline & Infrastructure on AWS

This project sets up a fully containerized **Task Tracker Application** with CI/CD, deployed on AWS using **ECS Fargate**, **Application Load Balancer (ALB)**, and **SSL**. The infrastructure is provisioned via **Terraform**, and the application is built and deployed via **GitHub Actions**.

---

## 🚀 Features

- **Frontend** and **Backend** Dockerized
- **Local development** using `docker-compose`
- **CI pipeline** with GitHub Actions
- **Deployment to AWS ECS Fargate**
- **SSL-enabled ALB** for secure access
- **Terraform backend** with S3 and DynamoDB for remote state and locking
- (Optional) Monitoring with **Prometheus** and **Grafana**

---

## 🧱 Project Structure

.
├── backend/ # Backend application (Dockerized)
├── frontend/ # Frontend application (Dockerized)
├── docker-compose.yml # Local development setup
├── terraform/ # Infrastructure as Code
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── .github/workflows/ # GitHub Actions CI/CD pipeline
│ └── deploy.yml
└── README.md

yaml
Copy
Edit

---

## 🛠 Prerequisites

- [Docker](https://www.docker.com/)
- [AWS CLI](https://docs.aws.amazon.com/cli/)
- [Terraform](https://www.terraform.io/)
- GitHub repo with access tokens configured
- AWS account with permissions to create:
  - VPC, Subnets, ECS, ECR, ALB, ACM, IAM, DynamoDB, S3

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/task-tracker.git
cd task-tracker
2. Build and Run Locally (Dev Mode)
bash
Copy
Edit
docker-compose up --build
3. Provision Infrastructure (Terraform)
bash
Copy
Edit
cd terraform

# Initialize Terraform backend
terraform init

# Validate configuration
terraform validate

# Preview the changes
terraform plan

# Apply infrastructure
terraform apply
✅ After deployment, your app will be accessible at:

text
Copy
Edit
https://<ALB-DNS-NAME>
🔐 SSL Certificate
The infrastructure includes an ACM certificate. If using a real domain, replace your-domain.com in variables.tf, and configure DNS validation or import an ACM cert manually.

🔄 CI/CD with GitHub Actions
The GitHub Actions pipeline:

Builds and pushes Docker images to Amazon ECR

Triggers ECS task definition updates and service redeployments

Configure the following secrets in your GitHub repository:

Secret Name	Description
AWS_ACCESS_KEY_ID	IAM user access key
AWS_SECRET_ACCESS_KEY	IAM user secret key
AWS_REGION	AWS region (e.g., us-east-1)
ECR_REPOSITORY_FRONTEND	ECR repo URL for frontend
ECR_REPOSITORY_BACKEND	ECR repo URL for backend

📈 Bonus: Monitoring (Optional)
To enable Prometheus and Grafana:

Add exporters to your containers

Provision EC2 or Fargate containers for Prometheus and Grafana

Configure dashboards and alerts

🔐 Terraform State Locking
The backend uses S3 for storing state and DynamoDB for locking:

To create the lock table:

bash
Copy
Edit
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
📄 License
This project is licensed under the MIT License.