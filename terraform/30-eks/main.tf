
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.0"

  name               = var.project
  kubernetes_version = var.eks_version

  # EKS Managed Add-ons
  addons = {
    coredns = {}

    eks-pod-identity-agent = {
      before_compute = true
    }

    kube-proxy = {}

    vpc-cni = {
      before_compute        = true
      enable_network_policy = true
    }

    metrics-server = {}

    # AWS EBS CSI Driver with Pod Identity
    aws-ebs-csi-driver = {
      most_recent = true

      pod_identity_association = [
        {
          role_arn        = terraform_data.ebs_csi_policy_ready.output
          service_account = "ebs-csi-controller-sa"
        }
      ]
    }
  }

  # Private EKS API endpoint
  endpoint_public_access = false

  # Grant cluster creator administrator permissions
  enable_cluster_creator_admin_permissions = true

  # Networking
  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # Existing security groups
  create_node_security_group = false
  create_security_group      = false

  node_security_group_id = local.eks_node_sg_id
  security_group_id      = local.eks_control_plane_sg_id

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    blue = {
      create             = var.enable_blue
      kubernetes_version = var.blue_version

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small", "t3.medium", "m5.xlarge", "m4.xlarge"]
      capacity_type  = "SPOT"

      iam_role_additional_policies = {
        EFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }

      min_size     = 2
      max_size     = 2
      desired_size = 2

      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
      }

      labels = {
        nodegroup = "blue"
      }
    }

    green = {
      create             = var.enable_green
      kubernetes_version = var.green_version

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small", "t3.medium", "m5.xlarge", "m4.xlarge"]
      capacity_type  = "SPOT"

      iam_role_additional_policies = {
        EFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }

      min_size     = 2
      max_size     = 2
      desired_size = 2

      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
      }

      labels = {
        nodegroup = "green"
      }
    }
  }

  tags = local.common_tags
}
