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