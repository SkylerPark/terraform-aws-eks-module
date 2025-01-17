locals {
  auto_mode_enabled = try(var.compute_config.enabled, false)
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  version  = var.kubernetes_version
  role_arn = var.iam_role

  enabled_cluster_log_types = var.log_types

  access_config {
    authentication_mode = var.authentication_mode

    bootstrap_cluster_creator_admin_permissions = false
  }

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.security_groups

    endpoint_private_access = var.endpoint_access.private_access_enabled
    endpoint_public_access  = var.endpoint_access.public_access_enabled
    public_access_cidrs     = var.endpoint_access.public_access_cidrs
  }

  dynamic "kubernetes_network_config" {
    for_each = var.outpost_config != null ? [1] : []

    content {
      dynamic "elastic_load_balancing" {
        for_each = local.auto_mode_enabled ? [1] : []

        content {
          enabled = local.auto_mode_enabled
        }
      }
      service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
      ip_family         = lower(var.kubernetes_network_config.ip_family)
    }
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

  dynamic "compute_config" {
    for_each = length(var.compute_config) > 0 ? [var.compute_config] : []

    content {
      enabled       = local.auto_mode_enabled
      node_pools    = local.auto_mode_enabled ? try(compute_config.value.node_pools, []) : null
      node_role_arn = local.auto_mode_enabled && length(try(compute_config.value.node_pools, [])) > 0 ? try(compute_config.value.node_role, null) : null
    }
  }

  dynamic "storage_config" {
    for_each = local.auto_mode_enabled ? [1] : []

    content {
      block_storage {
        enabled = local.auto_mode_enabled
      }
    }
  }

  dynamic "upgrade_policy" {
    for_each = length(var.upgrade_policy) > 0 ? [var.upgrade_policy] : []

    content {
      support_type = upgrade_policy.value.support_type
    }
  }

  dynamic "zonal_shift_config" {
    for_each = var.zonal_shift_config.enabled ? [1] : []

    content {
      enabled = try(zonal_shift_config.value.enabled, null)
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
