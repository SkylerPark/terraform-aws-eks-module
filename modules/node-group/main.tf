data "aws_default_tags" "this" {}

locals {
  tags = merge(
    {
      "Name"                                      = var.name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.tags,
  )
  default_tags = data.aws_default_tags.this.tags

  indirect_managed_tags = merge(
    local.tags,
    local.default_tags,
  )
}


###################################################
# EKS Node Group
###################################################
resource "aws_launch_template" "this" {
  name_prefix = "${var.name}-"
  description = "Managed by Terraform."

  image_id      = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.instance_key

  ebs_optimized = var.ebs_optimized

  user_data = base64encode(local.userdata)

  instance_initiated_shutdown_behavior = "terminate"

  dynamic "instance_market_options" {
    for_each = var.spot_enabled ? ["go"] : []
    content {
      market_type = "spot"
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    iterator = metadata

    content {
      http_endpoint               = try(metadata.value.http_endpoint_enabled, true) ? "enabled" : "disabled"
      http_tokens                 = try(metadata.value.http_tokens_enabled, true) ? "required" : "optional"
      http_put_response_hop_limit = try(metadata.value.http_put_response_hop_limit, 1)
      instance_metadata_tags      = try(metadata.value.instance_tags_enabled, true) ? "enabled" : "disabled"
    }
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = var.root_volume_type
      volume_size           = var.root_volume_size
      iops                  = var.root_volume_iops
      throughput            = var.root_volume_throughput
      encrypted             = var.root_volume_encryption_enabled
      kms_key_id            = var.root_volume_encryption_kms_key_id
      delete_on_termination = true
    }
  }

  network_interfaces {
    description     = "Managed by Terraform."
    security_groups = var.security_groups

    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
  }

  monitoring {
    enabled = var.monitoring_enabled
  }

  iam_instance_profile {
    name = var.instance_profile
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.indirect_managed_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.indirect_managed_tags
  }

  tags = local.tags
}

resource "aws_autoscaling_group" "this" {
  name_prefix = "${var.name}-"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_size

  vpc_zone_identifier = var.subnets
  target_group_arns   = var.target_group_arns

  force_delete    = var.force_delete
  enabled_metrics = var.enabled_metrics

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    triggers = []
  }

  dynamic "tag" {
    for_each = local.indirect_managed_tags

    content {
      key   = tag.key
      value = tag.value

      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
