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
      url = replace(module.cluster.irsa_oidc_provider_url, "https://", "")
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
                "ec2:ResourceTag/Name" : "${local.eks_name}-node"
              }
            },
            "Effect" : "Allow",
            "Resource" : "*",
            "Sid" : "ConditionalEC2Termination"
          },
          {
            "Effect" : "Allow",
            "Action" : "iam:PassRole",
            "Resource" : module.karpenter_node_role.arn,
            "Sid" : "PassNodeIAMRole"
          },
          {
            "Effect" : "Allow",
            "Action" : "eks:DescribeCluster",
            "Resource" : module.cluster.arn,
            "Sid" : "EKSClusterEndpointLookup"
          }
        ],
        "Version" : "2012-10-17"
      }
    )
  }
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

locals {
  karpenter_config = {
    "on-demand-default-amd64" = {
      spec = {
        disruption = {
          consolidateAfter    = "10m"
          consolidationPolicy = "WhenEmpty"
          expireAfter         = "Never"
        }
        template = {
          spec = {
            nodeClassRef = {
              apiVersion = "karpenter.k8s.aws/v1beta1"
              kind       = "EC2NodeClass"
              name       = "default"
            }
            requirements = [
              {
                key      = "node.kubernetes.io/instance-family"
                operator = "In"
                values   = ["c5a", "m5a", "r5a"]
              },
              {
                key      = "karpenter.k8s.aws/instance-size"
                operator = "In"
                values   = ["xlarge", "2xlarge", "4xlarge", "8xlarge"]
              },
              {
                key      = "topology.kubernetes.io/zone"
                operator = "In"
                values   = ["ap-northeast-2a", "ap-northeast-2c"]
              },
              {
                key      = "karpenter.sh/capacity-type"
                operator = "In"
                values   = ["on-demand"]
              },
              {
                key      = "kubernetes.io/os"
                operator = "In"
                values   = ["linux"]
              },
              {
                key      = "capacity-spread"
                operator = "In"
                values   = ["1", "2"]
              }
            ]
          }
        }
      }
    }
    "spot-default-amd64" = {
      spec = {
        disruption = {
          consolidateAfter    = "10m"
          consolidationPolicy = "WhenEmpty"
          expireAfter         = "Never"
        }
        template = {
          spec = {
            nodeClassRef = {
              apiVersion = "karpenter.k8s.aws/v1beta1"
              kind       = "EC2NodeClass"
              name       = "default"
            }
            requirements = [
              {
                key      = "node.kubernetes.io/instance-family"
                operator = "In"
                values   = ["c5a", "m5a", "r5a"]
              },
              {
                key      = "karpenter.k8s.aws/instance-size"
                operator = "In"
                values   = ["xlarge", "2xlarge", "4xlarge", "8xlarge"]
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
                key      = "kubernetes.io/os"
                operator = "In"
                values   = ["linux"]
              },
              {
                key      = "capacity-spread"
                operator = "In"
                values   = ["3"]
              }
            ]
          }
        }
      }
    }
  }
}

resource "kubectl_manifest" "node_pool" {
  for_each = local.karpenter_config
  yaml_body = yamlencode(
    {
      apiVersion = "karpenter.sh/v1beta1"
      kind       = "NodePool"
      metadata = {
        name = each.key
      }
      spec = each.value.spec
    }
  )
  depends_on = [module.helm_releases]
}


resource "kubectl_manifest" "ec2_node_class" {
  yaml_body = yamlencode(
    {
      apiVersion = "karpenter.k8s.aws/v1beta1"
      kind       = "EC2NodeClass"
      metadata = {
        name = "default"
      }
      spec = {
        amiFamily = "AL2"
        subnetSelectorTerms = [
          {
            tags = {
              "karpenter.sh/discovery" = "${local.eks_cluster_name}"
            }
          }
        ]
        securityGroupSelectorTerms = [
          {
            tags = {
              "karpenter.sh/discovery" = "${local.eks_cluster_name}"
            }
          }
        ]
        instanceProfile = module.karpenter_node_role.name
        metadataOptions = {
          httpEndpoint            = "enabled"
          httpProtocolIPv6        = "disabled"
          httpPutResponseHopLimit = 1
          httpTokens              = "required"
        }
        blockDeviceMappings = [
          {
            deviceName = "/dev/xvda"
            ebs = {
              volumeSize          = "50Gi"
              volumeType          = "gp3"
              iops                = 3000
              throughput          = 125
              deleteOnTermination = true
              encrypted           = true
            }
          }
        ]
        detailedMonitoring = true
        userData           = null
      }
    }
  )
  depends_on = [module.helm_releases]
}
