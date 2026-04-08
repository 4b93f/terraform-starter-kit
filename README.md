# terraform-starter-kit

A Terraform starter kit for deploying a serverless AWS stack.

## Stack

- **API Gateway** — REST API with `/health` and `/test` endpoints and deployment triggers
- **Lambda (health)** — returns 200, used as a health check, CloudWatch logs enabled
- **Lambda (test)** — sends a message to SQS, CloudWatch logs enabled, optional SQS IAM policy
- **SQS** — Message queue fed by the test Lambda
- **DynamoDB** — NoSQL table with on-demand (PAY_PER_REQUEST) billing
- **S3** — Storage bucket with versioning, AES256 encryption, and public access blocked

## Architecture

```
GET /health  →  lambda_health  →  200 ok
GET /test    →  lambda_test    →  SQS queue
```

## Project Structure

```
.
├── bootstrap.py           # One-time script to create S3 remote state bucket on AWS
├── environments/
│   └── dev/
│       ├── main.tf        # Module composition and local name
│       ├── outputs.tf     # Exposed outputs (API URL, Lambda names, SQS URL)
│       ├── provider.tf    # AWS provider, Terraform version, S3 backend
│       ├── variables.tf
│       └── src/
│           ├── health.py  # Health Lambda code
│           ├── health.zip # Health Lambda deployment package
│           ├── index.py   # Test Lambda code
│           └── dummy.zip  # Test Lambda deployment package
└── modules/
    ├── api_gateway/       # REST API, /health and /test routes, Lambda integrations, stage
    ├── lambda/            # Lambda function + IAM role (SQS policy optional)
    ├── sqs/               # SQS queue
    ├── dynamodb/          # DynamoDB table
    └── s3/                # S3 bucket
```

## Prerequisites

- [Terraform >= 1.9](https://developer.hashicorp.com/terraform/install)
- AWS account with credentials configured (`aws configure`)
- Python 3.10+ with dependencies:
```bash
pip install -r requirements.txt
```

## Remote State

State is stored in an S3 bucket on AWS. This keeps sensitive data out of the repo and allows team collaboration.

> The state file contains resource IDs, IPs, and secrets — never commit it to git.

Create the bucket once before your first deploy:
```bash
python3 bootstrap.py
```

## Getting Started (real AWS)

```bash
cd environments/dev
terraform init
terraform apply
```

Test the API:
```bash
curl $(terraform output -raw api_gateway_url)/health
curl $(terraform output -raw api_gateway_url)/test
```

## Local Development (LocalStack)

`tflocal` deploys resources to LocalStack and automatically redirects state to LocalStack S3 — state is ephemeral and resets when LocalStack restarts. This is expected for local dev.

```bash
localstack start
cd environments/dev
tflocal init -reconfigure
tflocal apply
```

Test the API:
```bash
curl http://localhost:4566/restapis/<API_ID>/dev/_user_request_/health
curl http://localhost:4566/restapis/<API_ID>/dev/_user_request_/test
```

> Get the API ID from `tflocal output api_gateway_url`

## Outputs

| Output | Description |
|---|---|
| `api_gateway_url` | Invoke URL of the API Gateway stage |
| `lambda_health_name` | Name of the health Lambda function |
| `lambda_test_name` | Name of the test Lambda function |
| `sqs_url` | URL of the SQS queue |

## Naming

All resource names are derived from a single `local.name` in `environments/dev/main.tf`:

```hcl
locals {
  name = var.project_name
}
```

Override via `-var`:
```bash
terraform apply -var="project_name=my-project"
# or for LocalStack:
tflocal apply -var="project_name=my-project"
```
