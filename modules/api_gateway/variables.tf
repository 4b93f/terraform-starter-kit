variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "The name of the deployment stage for API Gateway"
  type        = string
}

variable "health_lambda_uri" {
  description = "The invoke URI of the health Lambda function"
  type        = string
}

variable "health_lambda_function_name" {
  description = "The name of the health Lambda function"
  type        = string
}

variable "test_lambda_uri" {
  description = "The invoke URI of the test Lambda function"
  type        = string
}

variable "test_lambda_function_name" {
  description = "The name of the test Lambda function"
  type        = string
}
