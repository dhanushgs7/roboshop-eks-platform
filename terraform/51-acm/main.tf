data "aws_acm_certificate" "roboshop" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  key_types   = ["EC_prime256v1"]
  most_recent = true
}