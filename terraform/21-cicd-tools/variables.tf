variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}


variable "sonar" {
  default = false
}

variable "jenkins" {
  default = false
}

variable "runner" {
  default = true
}
variable "zone_id" {
  description = "Existing Route 53 hosted zone ID for optional CI/CD tool DNS records"
  type        = string
  default     = "Z07086101C1CVP7AT2UK4"
}

variable "domain_name" {
  description = "Domain used by optional CI/CD tool DNS records"
  type        = string
  default     = "daws90s.shop"
}
