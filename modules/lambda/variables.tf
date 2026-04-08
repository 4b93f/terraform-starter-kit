variable "name" {
  description = "The name of the Lambda function to create"
  type        = string
}

variable "handler" {
  description = "The handler of the Lambda function to create"
  type        = string
}

variable "runtime" {
  description = "Runtime of the Lambda function"
  type        = string
}

variable "zip_filename" {
  description = "Path to the zip code containing the Lambda function code"
  type        = string
}

variable "role_tag" {
  description = "Tag for the lambda role"
  type        = map(string)
  default     = {}
}

variable "enable_sqs" {
  description = "Whether to enable SQS permissions for this Lambda"
  type        = bool
  default     = false
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue that the Lambda function will send messages to"
  type        = string
  default     = null
}

variable "sqs_url" {
  description = "The URL of the SQS queue that the Lambda function will send messages to"
  type        = string
  default     = null
}