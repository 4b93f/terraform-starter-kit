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
├── bootstrap.py           # Optional: create an S3 remote state bucket on AWS
├── environments/
│   └── dev/
│       ├── main.tf        # Module composition and local name
│       ├── outputs.tf     # Exposed outputs (API URL, Lambda names, SQS URL)
│       ├── provider.tf    # AWS provider and Terraform version constraint
│       ├── variables.tf
│       └── src/
│           ├── health.py  # Health Lambda code
│           └── index.py   # Test Lambda code
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

## Build Lambda packages

Lambda zip files are gitignored and must be built before deploying:

```bash
cd environments/dev/src
zip health.zip health.py
zip dummy.zip index.py
```

## Getting Started (real AWS)

```bash
cd environments/dev
terraform init
terraform apply
```

State is stored locally in `terraform.tfstate`. If you need remote state for team use, run `bootstrap.py` to create an S3 bucket and follow the printed instructions.

Test the API:
```bash
curl $(terraform output -raw api_gateway_url)/health
curl $(terraform output -raw api_gateway_url)/test
```

## Local Development (LocalStack)

LocalStack lets you test the stack locally without an AWS account. It is intended for testing purposes only — state is ephemeral and resets when deleted.

LocalStack endpoints are configured via `environments/dev/override.tf`, which is gitignored. Create it before your first local run:

```hcl
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "eu-west-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    apigateway     = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    s3             = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    sts            = "http://localhost:4566"
    cloudwatchlogs = "http://localhost:4566"
  }
}
```

```bash
localstack start
cd environments/dev
terraform init
terraform apply
```

Test the API:
```bash
curl http://localhost:4566/restapis/<API_ID>/dev/_user_request_/health
curl http://localhost:4566/restapis/<API_ID>/dev/_user_request_/test
```

> Get the API ID from `terraform output api_gateway_url`

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
```
