output "files" {
  value = local.certificates_files
}

output "server_token" {
  value = terraform_data.token.output.token
}

output "node_token" {
  value = format("K10%s::server:%s", sha256(tls_self_signed_cert.ca["server-ca"].cert_pem), terraform_data.token.output.token)
}

output "cluster_ca_certificate" {
  value = local.cluster_ca_certificate
}

output "client_certificate" {
  value = local.client_certificate
}

output "client_key" {
  value = local.client_key
}
