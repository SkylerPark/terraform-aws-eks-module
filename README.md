# terraform-aws-eks-module

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Component

아래 도구를 이용하여 모듈작성을 하였습니다. 링크를 참고하여 OS 에 맞게 설치 합니다.

> **macos** : ./bin/install-macos.sh

- [pre-commit](https://pre-commit.com)
- [terraform](https://terraform.io)
- [tfenv](https://github.com/tfutils/tfenv)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [tfsec](https://github.com/tfsec/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)

## Services

Terraform 모듈을 사용하여 아래 서비스를 관리 합니다.

- **AWS EKS (Elastic Kubernetes Service)**
  - cluster
  - node group
  - aws auth
  - eni config
  - fargate profile
  - addon
  - helm release
  - karpenter

## Usage

아래 예시를 활용하여 작성가능하며 examples 코드를 참고 부탁드립니다.

### Cluster

EKS Cluster 를 생성 하는 예시 입니다.

```hcl
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
```

### Self Managed Node Group

Self Managed Node Group 을 생성 하는 예시 입니다.

```hcl
data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.eks_version}-v*"]
  }
}

data "aws_ami" "eks_default_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-arm64-node-${local.eks_version}-v*"]
  }
}

module "node_group_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "${local.eks_name}-node-role"
  trusted_service_policies = [
    {
      services = ["ec2.amazonaws.com"]
    }
  ]
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  force_detach_policies = true
  instance_profile = {
    enabled = true
  }
}

module "node_group" {
  source           = "../../modules/node-group"
  name             = "${local.eks_cluster_name}-node-group"
  cluster_name     = local.eks_cluster_name
  instance_ami     = data.aws_ami.eks_default_arm.id
  instance_type    = "t4g.medium"
  instance_key     = module.ssh_key.name
  instance_profile = module.node_group_role.instance_profile.name

  spot_enabled = true

  security_groups = [module.node_sg.id]

  subnets = module.subnet_group["parksm-private-subnet"].ids

  min_size     = 2
  max_size     = 10
  desired_size = 2


  metadata_options = {
    http_endpoint_enabled = true
    http_tokens_enabled   = true
    instance_tags_enabled = true
  }

  root_volume_encryption_enabled = true
  root_volume_type               = "gp3"
  root_volume_size               = 50
}
```

### Fargate Profile

Fargate Profile 을 생성 하는 예시 입니다.

```hcl
module "fargate_role" {
  source = "git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/?ref=tags/1.0.1"
  name   = "${local.eks_name}-fargate-role"
  trusted_service_policies = [
    {
      services = ["eks-fargate-pods.amazonaws.com"]
    }
  ]
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]
  force_detach_policies = true
}

module "fargate" {
  source   = "../../modules/fargate-profile"
  for_each = toset(["karpenter", "kube-system"])

  name         = each.key
  cluster_name = local.eks_cluster_name

  subnets  = module.subnet_group["parksm-private-subnet"].ids
  iam_role = module.fargate_role.arn

  selectors = [
    {
      namespace = each.key
    }
  ]
}
```

### Helm Release

helm release 를 이용한 aws load balancer controller 예시 입니다.

```hcl
locals {
  helm_releases = {
    "aws-load-balancer-controller" = {
      description   = "A Helm chart to deploy aws-load-balancer-controller for ingress resources"
      namespace     = "kube-system"
      repository    = "https://aws.github.io/eks-charts"
      chart         = "aws-load-balancer-controller"
      chart_version = "1.6.2"
      set = [
        {
          name  = "serviceAccount.create"
          value = "true"
        },
        {
          name  = "region"
          value = "ap-northeast-2"
        },
        {
          name  = "vpcId"
          value = module.vpc.id
        },
        {
          name  = "image.repository"
          value = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
        },
        {
          name  = "serviceAccount.name"
          value = "aws-load-balancer-controller"
        },
        {
          name  = "clusterName"
          value = local.eks_cluster_name
        },
        {
          name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
          value = module.load_balancer_controller_role.arn
        }
      ]
    }
  }
}

module "helm_releases" {
  source        = "../../modules/helm-release"
  for_each      = local.helm_releases
  name          = each.key
  description   = each.value.description
  namespace     = each.value.namespace
  repository    = each.value.repository
  chart         = each.value.chart
  chart_version = each.value.chart_version
  set           = each.value.set
}
```

### Karpenter

Karpenter 를 이용한 Node Less 예시 입니다.

```hcl
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
          }
        ],
        "Version" : "2012-10-17"
      }
    )
  }
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
```
