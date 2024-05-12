resource "aws_eks_fargate_profile" "this" {
  cluster_name         = var.cluster_name
  fargate_profile_name = var.name

  pod_execution_role_arn = var.iam_role
  subnet_ids             = var.subnets

  dynamic "selector" {
    for_each = var.selectors

    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = var.name,
    },
    var.tags
  )
}
