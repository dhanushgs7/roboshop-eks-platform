output "state_bucket_name" {
  description = "Terraform remote state S3 bucket."
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "Terraform remote state bucket ARN."
  value       = aws_s3_bucket.terraform_state.arn
}

output "state_bucket_region" {
  description = "Terraform remote state bucket region."
  value       = var.aws_region
}