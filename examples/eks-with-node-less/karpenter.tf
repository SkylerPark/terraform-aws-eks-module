module "karpenter_node_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "karpenter-node-role"
  trusted_service_policies = [
    {
      services = ["ec2.amazonaws.com"]
    }
  ]
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]
  force_detach_policies = true
  instance_profile = {
    enabled = true
  }
}

module "karpenter_controller_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "karpenter-controller-role"
  trusted_oidc_provider_policies = [
    {
      url = module.cluster.irsa_oidc_provider_url
      conditions = [
        {
          key       = "sub"
          condition = "StringEquals"
          values    = ["system:serviceaccount:karpenter:karpenter"]
        },
        {
          key       = "aud"
          condition = "StringEquals"
          values    = ["sts.amazonaws.com"]
        }
      ]
    }
  ]
  force_detach_policies = true
  inline_policies = {
    "karpenter-controller-policy" = jsonencode(
      {
        "Statement" : [
          {
            "Action" : [
              "ssm:GetParameter",
              "iam:PassRole",
              "ec2:DescribeImages",
              "ec2:RunInstances",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeLaunchTemplates",
              "ec2:DescribeInstances",
              "ec2:DescribeInstanceTypes",
              "ec2:DescribeInstanceTypeOfferings",
              "ec2:DescribeAvailabilityZones",
              "ec2:DeleteLaunchTemplate",
              "ec2:CreateTags",
              "ec2:CreateLaunchTemplate",
              "ec2:CreateFleet",
              "ec2:DescribeSpotPriceHistory",
              "pricing:GetProducts"
            ],
            "Effect" : "Allow",
            "Resource" : "*",
            "Sid" : "Karpenter"
          },
          {
            "Action" : "ec2:TerminateInstances",
            "Condition" : {
              "StringLike" : {
                "ec2:ResourceTag/Name" : "${local.eks_name}-*"
              }
            },
            "Effect" : "Allow",
            "Resource" : "*",
            "Sid" : "ConditionalEC2Termination"
          }
        ],
        "Version" : "2012-10-17"
      }
    )
  }
}

module "karpenter" {
  source = "../../modules/karpenter"
  provisioner = {
    name = "default"
    requirements = [
      {
        key      = "karpenter.k8s.aws/instance-family"
        operator = "In"
        values   = ["c5", "m5", "r5"]
      },
      {
        key      = "karpenter.k8s.aws/instance-size"
        operator = "NotIn"
        values   = ["nano", "micro", "small", "large"]
      },
      {
        key      = "topology.kubernetes.io/zone"
        operator = "In"
        values   = ["ap-northeast-2a", "ap-northeast-2c"]
      },
      {
        key      = "karpenter.sh/capacity-type"
        operator = "In"
        values   = ["spot"]
      },
      {
        key      = "kubernetes.io/arch"
        operator = "In"
        values : ["arm64"]
      }
    ]
    provider_ref = {
      name = "default"
    }
    consolidation = {
      enabled = true
    }
  }
  aws_node_template = {
    name = "default"
    subnet_selector = {
      "karpenter.sh/discovery" = local.eks_name
    }
    security_group_selector = {
      "karpenter.sh/discovery" = local.eks_name
    }
    ami_family = "AL2"
    block_device_mappings = [
      {
        deviceName = "/dev/xvda"
        ebs = {
          amiFamily           = "AL2"
          volumeSize          = "50G"
          volumeType          = "gp3"
          iops                = 3000
          throughput          = 125
          deleteOnTermination = true
          encrypted           = true
        }
      }
    ]
    tags = {
      Name = "${local.eks_cluster_name}-node"
    }
  }
}
