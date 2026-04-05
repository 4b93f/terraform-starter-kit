# terraform-starter-kit (WIP)

A Terraform starter kit for deploying a serverless AWS stack.

## Stack

- **API Gateway** — REST API with `/health` and `/test` endpoints
- **Lambda (health)** — returns 200, used as a health check
- **Lambda (test)** — sends a message to SQS
- **SQS** — Message queue fed by the test Lambda
- **DynamoDB** — NoSQL table
- **S3** — Storage bucket

## Architecture

```
GET /health  →  lambda_health  →  200 ok
GET /test    →  lambda_test    →  SQS queue
```

## Project Structure

```
.
├── environments/
│   └── dev/
│       ├── main.tf        # Module composition and local name
│       ├── outputs.tf     # Exposed outputs (API URL, Lambda names, SQS URL)
│       ├── provider.tf    # AWS provider + Terraform version
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

- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS account with credentials configured (`aws configure`)

## Getting Started

1. Initialize Terraform:
```bash
cd environments/dev
terraform init
```

2. Deploy:
```bash
terraform apply
```

3. Test the API:
```bash
curl $(terraform output -raw api_gateway_url)/health
curl $(terraform output -raw api_gateway_url)/test
```

## Local Development

To test locally without incurring AWS costs, you can use [LocalStack](https://docs.localstack.cloud/getting-started/installation/) with [tflocal](https://github.com/localstack/terraform-local):

```bash
localstack start
pip install terraform-local
tflocal init && tflocal apply
```

## Outputs

| Output | Description |
|---|---|
| `api_gateway_url` | Invoke URL of the API Gateway stage |
| `lambda_health_name` | Name of the health Lambda function |
| `lambda_test_name` | Name of the test Lambda function |
| `sqs_url` | URL of the SQS queue |

## Naming

All resource names are derived from a single `local.name` value in `environments/dev/main.tf`:

```hcl
locals {
  name = "dev-forbee"
}
```

Change this to rename all resources at once.
