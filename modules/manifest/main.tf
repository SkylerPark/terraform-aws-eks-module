resource "kubernetes_manifest" "this" {
  manifest = var.manifest
}
