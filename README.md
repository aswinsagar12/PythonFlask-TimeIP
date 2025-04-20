# ServerIP - IP Geolocation as a Serverless Containerized Microservice

## 🚀 Overview
**ServerIP** is a fully containerized, serverless IP Geolocation microservice deployed on **AWS Lambda** using **Docker** and provisioned via **Terraform**. It resolves the geographical and network information of any given IP address, making it ideal for analytics, logging, and security audit pipelines.

This project demonstrates complete DevOps lifecycle implementation using:
- Infrastructure as Code with **Terraform**
- Containerization using **Docker**
- Deployment via **AWS Lambda** (with ECR-hosted image)
- Automation-ready and cloud-agnostic design

---

---

## 🧰 Tech Stack

| Layer              | Tools/Services Used |
|-------------------|---------------------|
| Infrastructure     | Terraform, AWS ECR, AWS Lambda |
| Containerization   | Docker, AWS CLI |
| Runtime            | public.ecr.aws/lambda/python:3.11 |
| API Integration    | ipapi.co or ipinfo.io |
| CI/CD (Optional)   | GitHub Actions / Jenkins (if applicable) |

---

## 🔑 Key Features

- 🔎 **Public IP Metadata Lookup**: Returns ISP, region, location, and country for any IP address
- 🐳 **Dockerized Microservice**: Container runs independently and is Lambda-ready
- ⚙️ **Terraform-Powered Infra**: Automates provisioning of Lambda, IAM role, and ECR repo
- ☁️ **AWS ECR + Lambda Deployment**: Image hosted and pulled via AWS Lambda seamlessly
- 🛡️ **Minimal Dependencies**: Built on `public.ecr.aws/lambda/python:3.11` for faster cold starts

---

## 🧱 Architecture & Workflow

```plaintext
User/API Client
     |
     v
[API Gateway (optional)]
     |
     v
[Lambda Function (container)]
     |
     v
[IP Geolocation API]

## 🧱 Local Development and Testing

# Clone the repo
git clone https://github.com/aswinsagar12/serverip.git
cd serverip

# Create a virtual environment (optional)
python3 -m venv venv && source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py

## Docker Build

# Build image
docker build -t serverip .

# Tag image for ECR
docker tag serverip:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/serverip:latest

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

# Push image
docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/serverip:latest


🏗️ Terraform Infrastructure Setup
Prerequisites
AWS CLI configured

IAM user with permissions for Lambda, ECR, IAM

Terraform installed (>=1.5.x)

Structure
css
Copy
Edit
infra/
├── main.tf
├── variables.tf
├── outputs.tf
└── ecr.tf
Usage
bash
Copy
Edit
cd infra
terraform init
terraform plan
terraform apply
Terraform will:

Create an ECR repo

Create an IAM role for Lambda

Create a Lambda function pointing to the container image

📁 Project Structure
bash
Copy
Edit
serverip/
├── app.py                    # Lambda-compatible Python handler
├── Dockerfile                # Docker config with python:3.13-slim
├── requirements.txt          # Dependencies
├── infra/                    # Terraform infrastructure setup
│   ├── main.tf
│   └── ...
⚙️ Deployment Verification
Go to AWS Lambda > Functions > [YourFunctionName]

Click Test

Use the following event:

json
Copy
Edit
{
  "ip": "8.8.8.8"
}
Confirm the JSON response includes city, region, country, ISP.

🧑‍💻 Developer Notes
The Lambda handler is defined in app.lambda_handler

Terraform uses hardcoded regions and can be extended via variables

Future scope includes adding API Gateway, CI/CD GitHub Actions, and monitoring with CloudWatch

🧩 Future Enhancements
Add CloudWatch alarms for invocation errors

Implement GitHub Actions CI for image build & push

Add support for private IP rejection

API Gateway with authentication layer

🤝 Contact & Collaboration
Feel free to fork, clone, or contribute.

📧 Email: aswinsagar12@gmail.com
🔗 LinkedIn: https://linkedin.com/in/aswinsagar12
💼 Portfolio: https://aswinsagar.dev (if available)

