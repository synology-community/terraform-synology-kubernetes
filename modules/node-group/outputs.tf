output "nodes" {
  description = "Nodes"
  value       = { for k, node in local.nodes : k => module.node[k] }
}
