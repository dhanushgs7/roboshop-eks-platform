variable "aws_region" {
  description = "AWS region for Terraform state infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "Expected AWS account ID."
  type        = string
  default     = "357229908934"
}

variable "project_name" {
  description = "Project identifier."
  type        = string
  default     = "roboshop"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
  default     = "dhanushgs7-roboshop-terraform-state-2026"

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "Bucket name must be 3-63 characters, lowercase alphanumeric and hyphens, and start/end with a letter or number."
  }
}