variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "lambda_uri" {
  description = "The URI of the Lambda function to integrate with API Gateway"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to allow API Gateway to invoke"
  type        = string
}

variable "stage_name" {
  description = "The name of the deployment stage for API Gateway"
  type        = string
}
