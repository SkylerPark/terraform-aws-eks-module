resource "helm_release" "this" {
  name             = var.name
  description      = var.description
  namespace        = var.namespace
  create_namespace = var.create_namespace
  chart            = var.chart
  version          = var.chart_version
  repository       = var.repository
  values           = var.values

  timeout                    = var.timeout
  repository_key_file        = var.repository_key_file
  repository_cert_file       = var.repository_cert_file
  repository_ca_file         = var.repository_ca_file
  repository_username        = var.repository_username
  repository_password        = var.repository_password
  devel                      = var.devel
  verify                     = var.verify
  keyring                    = var.keyring
  disable_webhooks           = var.disable_webhooks
  reuse_values               = var.reuse_values
  reset_values               = var.reset_values
  force_update               = var.force_update
  recreate_pods              = var.recreate_pods
  cleanup_on_fail            = var.cleanup_on_fail
  max_history                = var.max_history
  atomic                     = var.atomic
  skip_crds                  = var.skip_crds
  render_subchart_notes      = var.render_subchart_notes
  disable_openapi_validation = var.disable_openapi_validation
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs
  dependency_update          = var.dependency_update
  replace                    = var.replace
  lint                       = var.lint

  dynamic "postrender" {
    for_each = length(var.postrender) > 0 ? [var.postrender] : []

    content {
      binary_path = postrender.value.binary_path
      args        = try(postrender.value.args, null)
    }
  }

  dynamic "set" {
    for_each = var.set

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }
}
