locals {
  secrets = concat(
    var.secrets,
    var.connect.enabled ? [{
      name      = var.connect.secret_name
      namespace = "kube-system"
      type      = "Opaque"
      data = {
        token                        = var.connect.token
        "1password-credentials.json" = base64encode(jsonencode(var.connect.credentials))
      }
    }] : []
  )
}
