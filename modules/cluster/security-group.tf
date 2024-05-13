data "aws_default_tags" "this" {}

resource "aws_ec2_tag" "cluster_security_group" {
  for_each = {
    for k, v in merge(
      data.aws_default_tags.this.tags,
      var.tags
    ) :
    k => v
    if !contains(["Name", "kubernetes.io/cluster/${var.name}"], k)
  }

  resource_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}

locals {
  security_group_ingress_rules = concat([], [
    for rule in var.security_group_ingress_rules :
    concat(
      [
        for cidr in rule.ipv4_cidrs :
        {
          id          = "${rule.id}/ipv4/${cidr}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = cidr
          ipv6_cidr      = null
          prefix_list    = null
          security_group = null
        }
      ],
      [
        for cidr in rule.ipv6_cidrs :
        {
          id          = "${rule.id}/ipv6/${cidr}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = cidr
          prefix_list    = null
          security_group = null
        }
      ],
      [
        for prefix_list in rule.prefix_lists :
        {
          id          = "${rule.id}/prefix-list/${prefix_list}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = prefix_list
          security_group = null
        }
      ],
      [
        for security_group in rule.security_groups :
        {
          id          = "${rule.id}/security-group/${security_group}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = null
          security_group = security_group
        }
      ],
      [
        for self in [rule.self] :
        {
          id          = "${rule.id}/self"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = null
          security_group = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
        }
        if self
      ]
    )
  ]...)

  security_group_egress_rules = concat([], [
    for rule in var.security_group_egress_rules :
    concat(
      [
        for cidr in rule.ipv4_cidrs :
        {
          id          = "${rule.id}/ipv4/${cidr}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = cidr
          ipv6_cidr      = null
          prefix_list    = null
          security_group = null
        }
      ],
      [
        for cidr in rule.ipv6_cidrs :
        {
          id          = "${rule.id}/ipv6/${cidr}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = cidr
          prefix_list    = null
          security_group = null
        }
      ],
      [
        for prefix_list in rule.prefix_lists :
        {
          id          = "${rule.id}/prefix-list/${prefix_list}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = prefix_list
          security_group = null
        }
      ],
      [
        for security_group in rule.security_groups :
        {
          id          = "${rule.id}/security-group/${security_group}"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = null
          security_group = security_group
        }
      ],
      [
        for self in [rule.self] :
        {
          id          = "${rule.id}/self"
          description = rule.description

          protocol  = rule.protocol
          from_port = rule.from_port
          to_port   = rule.to_port

          ipv4_cidr      = null
          ipv6_cidr      = null
          prefix_list    = null
          security_group = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
        }
        if self
      ]
    )
  ]...)
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for rule in local.security_group_ingress_rules :
    rule.id => rule
  }
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description       = each.value.description

  ip_protocol = each.value.protocol
  from_port = (contains(["all", "-1"], each.value.protocol)
    ? null
    : each.value.from_port
  )
  to_port = (contains(["all", "-1"], each.value.protocol)
    ? null
    : each.value.to_port
  )

  cidr_ipv4                    = each.value.ipv4_cidr
  cidr_ipv6                    = each.value.ipv6_cidr
  prefix_list_id               = each.value.prefix_list
  referenced_security_group_id = each.value.security_group

  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
  )
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for rule in local.security_group_egress_rules :
    rule.id => rule
  }

  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description       = each.value.description

  ip_protocol = each.value.protocol
  from_port = (contains(["all", "-1"], each.value.protocol)
    ? null
    : each.value.from_port
  )
  to_port = (contains(["all", "-1"], each.value.protocol)
    ? null
    : each.value.to_port
  )

  cidr_ipv4                    = each.value.ipv4_cidr
  cidr_ipv6                    = each.value.ipv6_cidr
  prefix_list_id               = each.value.prefix_list
  referenced_security_group_id = each.value.security_group

  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
  )
}
