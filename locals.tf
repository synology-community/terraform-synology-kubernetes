locals {
  api_server_ip = cidrhost(var.subnet, 254)
  api_endpoint  = format("https://%s:6443", local.api_server_ip)

  kube_config = {
    apiVersion      = "v1"
    kind            = "Config"
    preferences     = {}
    current-context = "kubernetes-admin@maas-kubernetes"
    clusters = [
      {
        cluster = {
          certificate-authority-data = module.cluster.cluster_ca_certificate
          server                     = module.cluster.api_endpoint
        }
        name = "maas-kubernetes"
      }
    ]
    users = [{
      user = {
        client-certificate-data = module.cluster.client_certificate
        client-key-data         = module.cluster.client_key
      }
      name = "kubernetes-admin"
    }]
    contexts = [{
      context = {
        user    = "kubernetes-admin"
        cluster = "maas-kubernetes"
      }
      name = "kubernetes-admin@maas-kubernetes"
    }]
  }
}
