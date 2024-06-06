# MaaS K3S Terraform Module

Provisions a functional kubernetes cluster using Canonical MaaS and K3S.

<!-- BEGIN_TF_DOCS -->


## Resources


## Examples

```hcl
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
```

## Providers

No providers.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The endpoint for the Kubernetes API server. |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Base64 encoded private key used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | The kubeconfig file as a string. |
| <a name="output_kubeconfig_yaml"></a> [kubeconfig\_yaml](#output\_kubeconfig\_yaml) | The kubeconfig file as YAML. |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_cidr"></a> [cluster\_cidr](#input\_cluster\_cidr) | CIDR of the cluster | `string` | `"10.32.0.0/16"` | no |
| <a name="input_connect"></a> [connect](#input\_connect) | 1Password Connect configuration. | <pre>object({<br>    enabled     = bool<br>    host        = optional(string, "http://onepassword-connect.kube-system.svc.cluster.local:8080")<br>    token       = optional(string)<br>    secret_name = optional(string, "op-credentials")<br>    credentials = optional(object({<br>      version = optional(string, "2")<br>      verifier = object({<br>        salt      = string<br>        localHash = string<br>      })<br>      healthVerifier = optional(string)<br>      encCredentials = object({<br>        kid  = string<br>        enc  = string<br>        cty  = string<br>        iv   = string<br>        data = string<br>      })<br>      uniqueKey = object({<br>        alg = string<br>        kid = string<br>        k   = string<br>        key_ops = optional(list(string), [<br>          "encrypt",<br>          "decrypt"<br>        ])<br>        ext = optional(bool, false)<br>        kty = string<br>      })<br>      deviceUuid = string<br>    }))<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain of the cluster | `string` | n/a | yes |
| <a name="input_github"></a> [github](#input\_github) | Github configuration. | <pre>object({<br>    access_token  = string<br>    org           = string<br>    client_id     = optional(string)<br>    client_secret = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_k3s"></a> [k3s](#input\_k3s) | K3s configuration. | <pre>object({<br>    channel     = optional(string, "v1.28")<br>    channel_url = optional(string, "https://update.k3s.io/v1-release/channels")<br>  })</pre> | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets to create in the cluster. | <pre>list(object({<br>    name      = string<br>    namespace = optional(string, "kube-system")<br>    type      = optional(string, "Opaque")<br>    data      = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | CIDR of the cluster | `string` | `"10.33.0.0/16"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Subnet of the node | `string` | `"10.1.40.0/24"` | no |
<!-- END_TF_DOCS -->
