locals {
  eni_config_yaml = yamlencode(
    {
      apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
      kind       = "ENIConfig"
      metadata = {
        name = var.name
      }
      spec = {
        securityGroups = var.security_groups
        subnet         = var.subnet
      }
    }
  )
}

resource "kubectl_manifest" "this" {
  yaml_body  = local.eni_config_yaml
  apply_only = true
}
