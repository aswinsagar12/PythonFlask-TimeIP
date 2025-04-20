# 🌐 ServerIP - IP Geolocation as a Serverless Containerized Microservice

## 🚀 Overview

**ServerIP** is a fully containerized, serverless IP Geolocation microservice deployed on **AWS Lambda** using **Docker** and provisioned via **Terraform**.

It fetches geographical and network metadata of any public IP address — ideal for analytics, logging, and security auditing pipelines.

---

## 🧰 Tech Stack

| Layer             | Tools / Services Used                          |
|------------------|-------------------------------------------------|
| Infrastructure    | Terraform, AWS Lambda, AWS ECR                 |
| Containerization  | Docker, AWS CLI                                |
| Runtime           | `public.ecr.aws/lambda/python:3.11`            |
| API Integration   | `ipapi.co` or `ipinfo.io`                      |
| CI/CD (Optional)  | GitHub Actions / Jenkins (if applicable)       |

---

## 🔑 Key Features

- 🔎 **IP Metadata Lookup**: City, region, country, ISP from any public IP
- 🐳 **Dockerized Microservice**: Lambda-compatible, standalone container
- ⚙️ **Terraform Infrastructure**: IAM role, ECR, Lambda — automated setup
- ☁️ **AWS Lambda Deployment**: Serverless and scalable
- 🚀 **Lightweight Runtime**: Based on `public.ecr.aws/lambda/python:3.11`

---

## 🧱 Architecture & Workflow

```plaintext
User / API Client
      |
      v
[API Gateway (Optional)]
      |
      v
[Lambda (Containerized)]
      |
      v
[IP Geolocation API]
```


## Local Development & Testing
```
# Clone the repo
git clone https://github.com/aswinsagar12/serverip.git
cd serverip

# (Optional) Create and activate a virtual environment
python3 -m venv venv && source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py
```
## 🐋 Docker Workflow
```
# Build the Docker image
docker build -t serverip .

# Tag the image for ECR
docker tag serverip:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/serverip:latest

# Authenticate Docker with ECR
aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

# Push the Docker image to ECR
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/serverip:latest
```

## 🏗️ Terraform Infrastructure Setup
✅ Prerequisites
AWS CLI configured (aws configure)

IAM User with permissions for Lambda, ECR, IAM

Terraform installed (>=1.5.x)

🗂️ Directory Structure
```plaintext
infra/
├── main.tf         # Lambda, IAM, ECR setup
├── variables.tf    # Configurable variables
├── outputs.tf      # Output values post-deployment
├── ecr.tf          # ECR repo definition

```
## 🚀 Usage

```
cd infra
terraform init
terraform plan
terraform apply
```

## ✅ Terraform Will:
Create an ECR repository

Set up an IAM role with required permissions

Deploy a Lambda function using your Docker image

## 📁 Project Structure
```plaintext
serverip/
├── app.py                  # Python Lambda handler
├── Dockerfile              # Docker config with python:3.11 runtime
├── requirements.txt        # Python dependencies
├── infra/                  # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ecr.tf

```

## ✅ Deployment Verification
Open AWS Console → Lambda

Choose your deployed function

Click Test

Use the following JSON as input:


## ✅ Confirm the response includes fields like city, region, country, and org (ISP)
## 🧑‍💻 Developer Notes
Lambda handler function is app.lambda_handler

Terraform region and names are hardcoded — can be parameterized

Ideal for CI/CD integrations using GitHub Actions

Extendable via API Gateway & monitoring integrations

🔮 Future Enhancements
📈 CloudWatch alarms for Lambda errors

🛠️ GitHub Actions pipeline for Docker build + ECR push

🚫 Reject private/internal IPs from being queried

🔐 Secure API Gateway layer with auth

## 🤝 Contact & Collaboration
Contributions and feedback are welcome! Feel free to fork and submit a PR.

📧 Email: aswinsagar12@gmail.com

🔗 LinkedIn: linkedin.com/in/aswinsagar12

🌐 Portfolio: [aswinsagar](https://aswinsagar12.github.io/AswinSagar-Portfolio/)
