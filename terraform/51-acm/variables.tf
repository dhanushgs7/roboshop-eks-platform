variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "domain_name" {
  description = "DuckDNS hostname used by the RoboShop application"
  type        = string
  default     = "roboshop-dev.duckdns.org"
}
