locals {
  tls_path = "/var/lib/rancher/k3s/server/tls"

  certificates_names = ["client-ca", "server-ca", "request-header-key-ca"]
  certificates       = { for s in local.certificates_names : s => s }
  certificates_files = flatten(
    [for s in local.certificates_names :
      flatten([
        {
          path    = "${local.tls_path}/${s}.key"
          content = tls_private_key.ca[s].private_key_pem
        },
        {
          path    = "${local.tls_path}/${s}.crt"
          content = tls_self_signed_cert.ca[s].cert_pem
        }
      ])
    ]
  )
  cluster_ca_certificate = tls_self_signed_cert.ca["server-ca"].cert_pem
  client_certificate     = tls_locally_signed_cert.client_admin.cert_pem
  client_key             = tls_private_key.client_admin.private_key_pem
}
