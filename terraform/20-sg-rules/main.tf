
# MySQL
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mysql_sg_id
}

resource "aws_security_group_rule" "mysql_bastion_az2" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.12.0/24"]
  security_group_id = local.mysql_sg_id
}

resource "aws_security_group_rule" "mysql_bastion_az1" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.11.0/24"]
  security_group_id = local.mysql_sg_id
}

# Public NLB accepts HTTPS traffic only.
resource "aws_security_group_rule" "public_nlb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.public_nlb_sg_id
}

resource "aws_security_group_rule" "bastion_my_public_ip" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  #source_security_group_id = local.vpn_sg_id
  security_group_id = local.bastion_sg_id
}

# EKS Control plane should accept traffic from Bastion
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}

resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1" # All traffic
  source_security_group_id = local.eks_control_plane_sg_id
  security_group_id        = local.eks_node_sg_id
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1" # All traffic
  source_security_group_id = local.eks_node_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}

# Internal traffic of VPC
resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All traffic
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = local.eks_node_sg_id
}

# Jenkins
resource "aws_security_group_rule" "jenkins_public" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.jenkins_sg_id
}

resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.jenkins_sg_id
}

resource "aws_security_group_rule" "jenkins_agent_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.jenkins_agent_sg_id
}

resource "aws_security_group_rule" "jenkins_agent_jenkins" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.jenkins_sg_id
  security_group_id        = local.jenkins_agent_sg_id
}

resource "aws_security_group_rule" "sonar_web" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.sonar_sg_id
}

resource "aws_security_group_rule" "sonar_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.sonar_sg_id
}

resource "aws_security_group_rule" "eks_control_plane_jenkins_agent" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.jenkins_agent_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}

resource "aws_security_group_rule" "runner_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # Where traffic is coming from
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.runner_sg_id
}

# EKS control plane should accept 443 from GitHub runner
resource "aws_security_group_rule" "eks_control_plane_runner" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.runner_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}
