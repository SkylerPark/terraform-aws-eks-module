locals {
  provisioner_yaml = yamlencode({
    apiVersion = "karpenter.sh/v1alpha5"
    kind       = "Provisioner"
    metadata = {
      name = var.provisioner.name
    }
    spec = {
      requirements  = var.provisioner.requirements
      providerRef   = var.provisioner.provider_ref
      consolidation = var.provisioner.consolidation
    }
  })
  aws_node_template_yaml = yamlencode({
    apiVersion = "karpenter.k8s.aws/v1alpha1"
    kind       = "AWSNodeTemplate"
    metadata = {
      name = var.aws_node_template.name
    }
    spec = {
      subnetSelector        = var.aws_node_template.subnet_selector
      securityGroupSelector = var.aws_node_template.security_group_selector
      amiFamily             = var.aws_node_template.ami_family
      blockDeviceMappings   = var.aws_node_template.block_device_mappings
      tags                  = var.aws_node_template.tags
    }
  })
}

resource "kubectl_manifest" "provisioner" {
  yaml_body  = local.provisioner_yaml
  apply_only = true
  depends_on = [
    module.helm_karpenter
  ]
}

resource "kubectl_manifest" "aws_node_template" {
  yaml_body  = local.aws_node_template_yaml
  apply_only = true
  depends_on = [
    kubectl_manifest.provisioner
  ]
}
