variable "stage_name" {
  description = "The name of the deployment stage for API Gateway"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Base name used for all resources"
  type        = string
  default     = "dev-forbee"
}
