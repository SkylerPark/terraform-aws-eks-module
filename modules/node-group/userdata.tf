data "aws_ec2_instance_type" "this" {
  instance_type = var.instance_type
}

locals {
  max_enis               = data.aws_ec2_instance_type.this.maximum_network_interfaces
  max_ipv4_addrs_per_eni = data.aws_ec2_instance_type.this.maximum_ipv4_addresses_per_interface
  vcpu                   = data.aws_ec2_instance_type.this.default_vcpus
  max_pods = min(
    (local.max_enis - (var.cni_custom_networking_enabled ? 1 : 0)) * ((local.max_ipv4_addrs_per_eni - 1) * (var.cni_eni_prefix_mode_enabled ? 16 : 1)) + 2,
    (local.vcpu > 30) ? 250 : 110
  )

  node_labels = [for k, v in var.node_labels : format("%s=%s", k, v)]
  node_taints = var.node_taints

  bootstrap_extra_args = compact(concat(
    [
      var.cni_custom_networking_enabled || var.cni_eni_prefix_mode_enabled ? "--use-max-pods false" : "",
    ],
    var.bootstrap_extra_args,
  ))
  kubelet_extra_args = compact(concat(
    [
      length(local.node_labels) > 0 ? "--node-labels ${join(",", local.node_labels)}" : "",
      length(local.node_taints) > 0 ? "--register-with-taints ${join(",", local.node_taints)}" : "",
      var.cni_custom_networking_enabled || var.cni_eni_prefix_mode_enabled ? "--max-pods ${local.max_pods}" : "",
    ],
    var.kubelet_extra_args,
  ))
  userdata = templatefile("${path.module}/templates/userdata.sh.tpl", {
    cluster_name         = var.cluster_name,
    bootstrap_extra_args = join(" ", local.bootstrap_extra_args),
    kubelet_extra_args   = join(" ", local.kubelet_extra_args)
  })
}
