output "name" {
  description = "Cluster name"
  value       = "kubernetes"
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = var.cluster_address
}

output "client_certificate" {
  value = terraform_data.cluster.output.client_certificate
}

output "client_key" {
  value = terraform_data.cluster.output.client_key
}

output "cluster_ca_certificate" {
  value = terraform_data.cluster.output.cluster_ca_certificate
}

output "api_endpoint" {
  value = terraform_data.cluster.output.api_endpoint
}

output "kubeconfig" {
  value = terraform_data.cluster.output
}
