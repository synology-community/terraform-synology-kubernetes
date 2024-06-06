locals {
  master = var.default_node_pool.nodes[0]

  default_node = module.default_node_group.nodes

  repos = {
    kubernetes = {
      source  = "deb [signed-by=$KEY_FILE] https://pkgs.k8s.io/core:/stable:/${var.k3s.channel}/deb/ /"
      key_url = "https://pkgs.k8s.io/core:/stable:/${var.k3s.channel}/deb/Release.key"
    }
    helm = {
      source  = "deb [arch=amd64 signed-by=$KEY_FILE] https://baltocdn.com/helm/stable/debian/ all main"
      key_url = "https://baltocdn.com/helm/signing.asc"
    }
  }

  default_nodes = [for index, node in var.default_node_pool.nodes : node.address == null ? merge(node, { address = cidrhost(var.subnet, 10 + index) }) : node]

  k3s_channel = one([for v in jsondecode(data.http.k3s_channels.response_body).data : v.name if v.id == var.k3s.channel])

  cluster_address_default = coalesce(var.cluster_address, cidrhost(var.subnet, 254))

  cluster_api_parts = regex("^(?:(?P<scheme>[^:/?#]+)://)?(?:(?P<ip>[^/?#][\\w|\\.]+))?(?::(?P<port>[0-9]{3,4}))?$", local.cluster_address_default)

  api_server = {
    ip     = coalesce(local.cluster_api_parts.ip, cidrhost(var.subnet, 254))
    port   = coalesce(local.cluster_api_parts.port, 6443)
    scheme = coalesce(local.cluster_api_parts.scheme, "https")
  }

  cluster_api_address = format("%s://%s:%s", local.api_server.scheme, local.api_server.ip, local.api_server.port)
}
