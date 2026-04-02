# terraform-starter-kit (WIP)

A Terraform starter kit for deploying a serverless AWS stack.

## Stack

- **API Gateway** — REST API with a `/health` endpoint
- **Lambda** — Python function triggered by API Gateway
- **SQS** — Message queue
- **DynamoDB** — NoSQL table
- **S3** — Storage bucket

## Project Structure

```
.
├── environments/
│   └── dev/
│       ├── main.tf        # Module composition and local name
│       ├── outputs.tf     # Exposed outputs (API URL, Lambda name, SQS URL)
│       ├── provider.tf    # AWS provider + Terraform version
│       ├── variables.tf
│       └── src/
│           ├── index.py   # Lambda function code
│           └── dummy.zip  # Lambda deployment package
└── modules/
    ├── api_gateway/       # REST API, /health route, Lambda integration, stage
    ├── lambda/            # Lambda function + IAM role
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
| `lambda_name` | Name of the deployed Lambda function |
| `sqs_url` | URL of the SQS queue |

## Naming

All resource names are derived from a single `local.name` value in `environments/dev/main.tf`:

```hcl
locals {
  name = "dev-forbee"
}
```

Change this to rename all resources at once.
