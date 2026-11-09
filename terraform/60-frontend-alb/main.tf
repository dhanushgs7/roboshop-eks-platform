
resource "aws_eip" "nlb" {
  domain = "vpc"

  tags = merge(
    {
      Name = "${local.common_name}-frontend-nlb"
    },
    local.common_tags
  )
}

resource "aws_lb" "public_nlb" {
  name               = "${local.common_name}-frontend-nlb"
  internal           = false
  load_balancer_type = "network"
  ip_address_type    = "ipv4"

  security_groups = [local.public_nlb_sg_id]

  subnet_mapping {
    subnet_id     = local.public_subnet_ids[0]
    allocation_id = aws_eip.nlb.id
  }

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = merge(
    {
      Name = "${local.common_name}-frontend-nlb"
    },
    local.common_tags
  )
}

resource "aws_lb_target_group" "frontend" {
  name        = "${local.common_name}-frontend"
  port        = 80
  protocol    = "TCP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  deregistration_delay = 30

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 10
    protocol            = "HTTP"
    path                = "/health"
    port                = "80"
    matcher             = "200-299"
    timeout             = 6
    unhealthy_threshold = 2
  }

  tags = merge(
    {
      Name = "${local.common_name}-frontend"
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = local.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  tags = local.common_tags
}
