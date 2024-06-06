# output "nodes" {
#   value = { for i in range(0, 1) : "kube-${i}" => {
#     "hostname" = "kube-${i}"
#     "ip"       = cidrhost(var.subnet, i + 10)
#     cloud_init = module.node[i].cloud_init_config
#   } }
# }

output "kubeconfig" {
  description = "The kubeconfig file as a string."
  value       = module.cluster.kubeconfig
}

output "kubeconfig_yaml" {
  description = "The kubeconfig file as YAML."
  value       = yamlencode(local.kube_config)
}

output "api_endpoint" {
  description = "The endpoint for the Kubernetes API server."
  value       = module.cluster.api_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  value       = module.cluster.cluster_ca_certificate
}

output "client_certificate" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  value       = module.cluster.client_certificate
}

output "client_key" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  value       = module.cluster.client_key
}
