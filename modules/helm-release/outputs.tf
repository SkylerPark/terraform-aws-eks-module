output "chart" {
  description = "chart 이름"
  value       = helm_release.this.chart
}

output "name" {
  description = "release 이름"
  value       = helm_release.this.metadata[0].name
}

output "namespace" {
  description = "Kubernetes namespace 이름"
  value       = helm_release.this[0].metadata[0].namespace
}

output "revision" {
  description = "release revision"
  value       = helm_release.this[0].metadata[0].revision
}

output "version" {
  description = "chart version"
  value       = helm_release.this[0].metadata[0].version
}

output "app_version" {
  description = "application deploy version"
  value       = helm_release.this[0].metadata[0].app_version
}

output "values" {
  description = "helm values 값"
  value       = helm_release.this[0].metadata[0].values
}
