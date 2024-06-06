locals {
  values = {
    connect = {
      serviceType = "ClusterIP"
      ingress = {
        enabled = true
        hosts = [{
          host  = "connect.${var.domain}"
          paths = []
        }]
        tls = [{
          hosts = ["connect.${var.domain}"]
        }]
      }
      credentialsName = var.secret_name
      credentialsKey  = "1password-credentials.json"
    }
  }
}
