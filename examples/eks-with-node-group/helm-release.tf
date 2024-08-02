locals {
  helm_releases = {
    "aws-load-balancer-controller" = {
      description   = "A Helm chart to deploy aws-load-balancer-controller for ingress resources"
      namespace     = "kube-system"
      repository    = "https://aws.github.io/eks-charts"
      chart         = "aws-load-balancer-controller"
      chart_version = "1.8.1"
      wait          = true
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
          value = module.cluster.name
        }
      ]
    }
  }
}

module "helm_releases" {
  source           = "../../modules/helm-release"
  for_each         = local.helm_releases
  name             = each.key
  description      = each.value.description
  namespace        = each.value.namespace
  create_namespace = try(each.value.create_namespace, false)
  wait             = try(each.value.wait, true)
  repository       = each.value.repository
  chart            = each.value.chart
  chart_version    = each.value.chart_version
  set              = each.value.set
}
