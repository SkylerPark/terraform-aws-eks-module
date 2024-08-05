output "manifest" {
  description = "manifest Yaml 내용."
  value       = yamlencode(var.manifest)
}
