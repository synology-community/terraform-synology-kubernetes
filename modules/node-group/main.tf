module "addons" {
  count = var.type == "system" ? 1 : 0

  source = "./modules/addons"

  cluster_cidr  = var.cluster_cidr
  subnet        = var.subnet
  service_cidr  = var.service_cidr
  api_server_ip = var.api_server.ip
}

module "node" {
  for_each = local.nodes

  source = "./modules/node"

  name   = each.key
  domain = var.domain

  network_id = var.network_id

  primary_control_node = each.value.primary
  control_plane        = each.value.control_plane

  write_files = each.value.primary ? concat(
    var.certificates_files,
    module.addons[0].files,
  ) : []

  subnet       = var.subnet
  cluster_cidr = var.cluster_cidr
  service_cidr = var.service_cidr

  apt_sources = var.apt_sources

  node_ip = each.value.address

  node_token   = var.node_token
  server_token = var.server_token

  api_server = var.api_server
  dns_prefix = var.dns_prefix

  annotations = concat(each.value.annotations, var.annotations)
  labels      = concat(each.value.labels, var.labels)
  taints      = concat(each.value.taints, var.taints)

  k3s = var.k3s
}
