variable "project_name" {
  description = "Base name used for all resources"
  type        = string
  default     = "dev-forbee"
}

variable "s3_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-bucket"
}

variable "dynamodb_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "my-table"
}

variable "sqs_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = "my-queue"
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my-lambda"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.13"
}

variable "lambda_zip" {
  description = "Path to the Lambda zip file"
  type        = string
  default     = "./src/dummy.zip"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "my-api"
}
