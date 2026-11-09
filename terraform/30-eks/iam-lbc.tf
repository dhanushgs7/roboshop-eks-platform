data "aws_iam_policy_document" "lbc_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "lbc" {
  name               = "${local.common_name}-aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.lbc_assume_role.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "lbc_tgb" {
  statement {
    sid    = "DescribeNetworkResources"
    effect = "Allow"

    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageTargetGroupRegistrations"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "lbc_tgb" {
  name        = "${local.common_name}-aws-load-balancer-controller-tgb"
  description = "Permissions for AWS Load Balancer Controller TargetGroupBinding"
  policy      = data.aws_iam_policy_document.lbc_tgb.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "lbc_tgb" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc_tgb.arn
}

resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.lbc.arn

  depends_on = [
    aws_iam_role_policy_attachment.lbc_tgb
  ]
}
