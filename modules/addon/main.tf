locals {
  addon_version = {
    "custom"  = var.addon_version
    "default" = data.aws_eks_addon_version.default.version
    "latest"  = data.aws_eks_addon_version.latest.version
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_addon_version" "default" {
  addon_name         = var.name
  kubernetes_version = data.aws_eks_cluster.this.version
}

data "aws_eks_addon_version" "latest" {
  addon_name         = var.name
  kubernetes_version = data.aws_eks_cluster.this.version
  most_recent        = true
}

resource "aws_eks_addon" "this" {
  cluster_name = var.cluster_name

  addon_name    = var.name
  addon_version = local.addon_version[local.addon_version_type]

  configuration_values = var.configuration

  service_account_role_arn = var.service_account_role

  resolve_conflicts_on_create = var.conflict_resolution_strategy_on_create
  resolve_conflicts_on_update = var.conflict_resolution_strategy_on_update
  preserve                    = var.preserve_on_delete

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}
