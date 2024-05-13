output "provisioner" {
  description = "provisioner yaml 내용"
  value       = local.provisioner_yaml
}

output "aws_node_template" {
  description = "aws_node_template yaml 내용"
  value       = local.aws_node_template_yaml
}
