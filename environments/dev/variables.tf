variable "stage_name" {
  description = "The name of the deployment stage for API Gateway"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Base name used for all resources"
  type        = string
  default     = "dev-forbee"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}
