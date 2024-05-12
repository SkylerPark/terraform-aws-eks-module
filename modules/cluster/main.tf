resource "aws_eks_cluster" "this" {
  name     = var.name
  versions = var.kubernetes_version
  role_arn = var.iam_role

  enabled_cluster_log_types = var.log_types

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.security_groups

    endpoint_private_access = var.endpoint_access.private_access_enabled
    endpoint_public_access  = var.endpoint_access.public_access_enabled
    public_access_cidrs     = var.endpoint_access.public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    ip_family         = lower(var.kubernetes_network_config.ip_family)
  }

  dynamic "encryption_config" {
    for_each = var.secrets_encryption.enabled ? [var.secrets_encryption] : []

    content {
      provider {
        key_arn = encryption_config.value.kms_key
      }
      resources = ["secrets"]
    }
  }

  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? [var.outpost_config] : []

    content {
      outpost_arns = outpost_config.value.outposts

      control_plane_instance_type = outpost_config.value.control_plane_instance_type

      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement_group != null ? [outpost_config.value.control_plane_placement_group] : []

        content {
          group_name = control_plane_placement.value
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}
