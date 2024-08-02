locals {
  eni_config_subnets = {
    for subnet in module.subnet_group["parksm-secondary-subnet"].subnets :
    subnet.availability_zone => subnet.id...
  }
}

resource "kubectl_manifest" "eni_config" {
  for_each = toset(["ap-northeast-2a", "ap-northeast-2c"])
  yaml_body = yamlencode(
    {
      apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
      kind       = "ENIConfig"
      metadata = {
        name = each.key
      }
      spec = {
        securityGroups = [module.node_sg.id]
        subnet         = local.eni_config_subnets[each.key][0]
      }
    }
  )
  depends_on = [module.eks_addon]
}
