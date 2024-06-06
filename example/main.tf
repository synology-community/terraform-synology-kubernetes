module "kubernetes" {
  source = "../"

  domain = "appkins.io"

  secrets = [
    {
      name = "cloudflare-secret"
      data = {
        tunnel-id = var.cloudflare_tunnel_id
        zone-id   = var.cloudflare_zone_id
        api-token = var.cloudflare_api_token

        "credentials.json" = jsonencode({
          AccountTag   = var.cloudflare_account
          TunnelID     = var.cloudflare_tunnel_id
          TunnelSecret = var.cloudflare_tunnel_secret
          }
        )
      }
    }
  ]

  github = {
    access_token  = var.github_access_token
    org           = "appkins-org"
    client_id     = var.github_client_id
    client_secret = var.github_client_secret
  }

  connect = {
    enabled     = true
    credentials = var.op_credentials
    token       = var.op_token
  }
}

output "kubeconfig" {
  value = module.kubernetes.kubeconfig
}

output "client_key" {
  value = module.kubernetes.client_key
}

output "cluster_ca_certificate" {
  value = module.kubernetes.cluster_ca_certificate
}

output "client_certificate" {
  value = module.kubernetes.client_certificate
}
