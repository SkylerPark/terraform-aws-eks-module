locals {
  subnet_groups = {
    "parksm-public-subnet" = {
      public_ipv4_address_assignment = {
        enabled = true
      }
      subnets = [
        {
          ipv4_cidr = "10.70.11.0/24"
          az        = "ap-northeast-2a"
        },
        {
          ipv4_cidr = "10.70.12.0/24"
          az        = "ap-northeast-2c"
        }
      ]
      tags = {
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
        "kubernetes.io/role/elb"                          = 1
      }
    }
    "parksm-private-subnet" = {
      subnets = [
        {
          ipv4_cidr = "10.70.21.0/24"
          az        = "ap-northeast-2a"
        },
        {
          ipv4_cidr = "10.70.22.0/24"
          az        = "ap-northeast-2c"
        }
      ]
      tags = {
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"                 = 1
      }
    }
    "parksm-secondary-subnet" = {
      subnets = [
        {
          ipv4_cidr = "100.70.0.0/18"
          az        = "ap-northeast-2a"
        },
        {
          ipv4_cidr = "10.70.64.0/18"
          az        = "ap-northeast-2c"
        }
      ]
      tags = {
        "karpenter.sh/discovery" = local.eks_name
      }
    }
  }
}

module "subnet_group" {
  source   = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/subnet-group/?ref=tags/1.1.3"
  for_each = local.subnet_groups

  name   = each.key
  vpc_id = module.vpc.id
  public_ipv4_address_assignment = {
    enabled = try(each.value.public_ipv4_address_assignment.enabled, false)
  }

  subnets = {
    for subnet in try(each.value.subnets, []) :
    "${each.key}-${subnet.az}" => {
      availability_zone = subnet.az
      ipv4_cidr         = subnet.ipv4_cidr
    }
  }
  tags = each.value.tags
}
