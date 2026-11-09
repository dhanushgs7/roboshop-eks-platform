resource "aws_ssm_parameter" "public_nlb_arn" {
  name      = "/${var.project}/${var.environment}/public_nlb_arn"
  type      = "String"
  value     = aws_lb.public_nlb.arn
  overwrite = true
}

resource "aws_ssm_parameter" "public_nlb_dns_name" {
  name      = "/${var.project}/${var.environment}/public_nlb_dns_name"
  type      = "String"
  value     = aws_lb.public_nlb.dns_name
  overwrite = true
}

resource "aws_ssm_parameter" "public_nlb_eip" {
  name      = "/${var.project}/${var.environment}/public_nlb_eip"
  type      = "String"
  value     = aws_eip.nlb.public_ip
  overwrite = true
}

resource "aws_ssm_parameter" "public_nlb_listener_arn" {
  name      = "/${var.project}/${var.environment}/public_nlb_listener_arn"
  type      = "String"
  value     = aws_lb_listener.https.arn
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_target_group_arn" {
  name      = "/${var.project}/${var.environment}/frontend_target_group_arn"
  type      = "String"
  value     = aws_lb_target_group.frontend.arn
  overwrite = true
}