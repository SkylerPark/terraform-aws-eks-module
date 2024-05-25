locals {
  eks_name         = "parksm"
  eks_version      = "1.29"
  eks_cluster_name = replace("${local.eks_name}-${local.eks_version}", ".", "-")
}

module "node_sg" {
  source = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/?ref=tags/1.1.5"
  name   = "${local.eks_name}-eks-node-sg"
  vpc_id = module.vpc.id

  revoke_rules_on_delete = true

  ingress_rules = [
    {
      id          = "all/all"
      description = "Allow nodes to communicate each others."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      self = true
    },
    {
      id          = "all/all"
      description = "Allow nodes to communicate from the cluster security group."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [module.cluster.cluster_security_group]
    },
    {
      id          = "tcp/ephemeral"
      description = "Allow nodes to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.control_plane_sg.id]
    },
    {
      id          = "tcp/kubelet"
      description = "Allow nodes to receive communication from the cluster control plane or pod for kubelet."
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250

      security_groups = [module.control_plane_sg.id, module.pod_sg.id]
    },
    {
      id          = "tcp/node-exporter"
      description = "Allow nodes to receive communication from the pods for node-exporter."
      protocol    = "tcp"
      from_port   = 9100
      to_port     = 9100

      security_groups = [module.pod_sg.id]
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow nodes egress access."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      ipv4_cidrs      = ["0.0.0.0/0"]
      ipv6_cidrs      = ["::/0"]
      security_groups = [module.cluster.cluster_security_group]
    }
  ]
  tags = {
    "karpenter.sh/discovery" = local.eks_name
  }
}

module "pod_sg" {
  source = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/?ref=tags/1.1.5"
  name   = "${local.eks_name}-eks-pod-sg"
  vpc_id = module.vpc.id

  revoke_rules_on_delete = true

  ingress_rules = [
    {
      id          = "all/all"
      description = "Allow pods to communicate each others."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      self = true
    },
    {
      id          = "all/all"
      description = "Allow pods to communicate from the nodes or cluster security group."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [module.node_sg.id, module.cluster.cluster_security_group]
    },
    {
      id          = "tcp/443"
      description = "Allow pods to receive metrics-server communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443

      security_groups = [module.control_plane_sg.id]
    },
    {
      id          = "tcp/ephemeral"
      description = "Allow pods to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.control_plane_sg.id]
    }
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow pods to communicate to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      ipv4_cidrs = ["0.0.0.0/0"]
      ipv6_cidrs = ["::/0"]
    },
  ]
}

module "control_plane_sg" {
  source = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/?ref=tags/1.1.5"
  name   = "${local.eks_name}-eks-control-plane-sg"
  vpc_id = module.vpc.id

  revoke_rules_on_delete = true

  ingress_rules = [
    {
      id              = "tcp/443"
      description     = "Allow HTTPS from API server"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      ipv4_cidrs      = ["192.168.0.0/16", "10.0.0.0/8", "172.168.0.0/24"]
      security_groups = []
    }
  ]
  egress_rules = [
    {
      id          = "tcp/ephemeral"
      description = "Allow control plane to ephemrally communicate with nodes or pods."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.node_sg.id, module.pod_sg.id]
    }
  ]
}

module "cluster_kms" {
  source = "git::https://github.com/SkylerPark/terraform-aws-kms-module.git//modules/key/?ref=tags/1.0.2"
  name   = "${local.eks_name}-key"
  aliases = [
    "alias/eks/${local.eks_name}"
  ]
  policy = jsonencode(
    {
      "Statement" : [
        {
          "Sid" : "KeyUsage",
          "Effect" : "Allow",
          "Actions" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey",
          ],
          "Resource" : "*",
          "Principals" : {
            "type" : "AWS",
            "identifiers" : [
              module.cluster_role.arn
            ]
          }
        }
      ]
    }
  )
}

module "cluster_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "${local.eks_name}-role"
  trusted_service_policies = [
    {
      services = ["eks.amazonaws.com"]
    }
  ]
  policies              = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  force_detach_policies = true
  inline_policies = {
    "${local.eks_name}-policy" = jsonencode({
      Statement = [
        {
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ListGrants",
            "kms:DescribeKey"
          ]
          Effect   = "Allow"
          Resource = module.cluster_kms.arn
        }
      ]
    })
  }
}

module "cluster" {
  source = "../../modules/cluster"
  name   = local.eks_cluster_name

  kubernetes_version = local.eks_version
  iam_role           = module.cluster_role.arn

  subnets         = concat(module.subnet_group["parksm-public-subnet"].ids, module.subnet_group["parksm-private-subnet"].ids)
  security_groups = [module.control_plane_sg.id]

  endpoint_access = {
    private_access_enabled = true
    public_access_enabled  = true
  }

  secrets_encryption = {
    enabled = true
    kms_key = module.cluster_kms.arn
  }
}

module "oidc_provider" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-oidc-identity-provider/?ref=tags/1.0.1"

  url       = module.cluster.irsa_oidc_provider_url
  audiences = ["sts.amazonaws.com"]

  auto_thumbprint_enabled = true
}
