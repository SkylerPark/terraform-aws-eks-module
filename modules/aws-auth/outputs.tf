output "config_map" {
  description = "`kube-system/aws-auth` ConfigMap 정보."
  value       = kubernetes_config_map.this
}
