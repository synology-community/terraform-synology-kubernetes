resource "synology_filestation_file" "noble" {
  url  = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  path = "/vm/images/noble-server-cloudimg-amd64.img"
}

resource "synology_virtualization_image" "noble" {
  name       = "noble"
  path       = synology_filestation_file.noble.path
  image_type = "disk"
  auto_clean = true

  depends_on = [synology_filestation_file.noble]
}

module "certificates" {
  source = "../certificates"
}

resource "terraform_data" "apt_sources" {
  input = {
    apt_sources = { for k, v in local.repos : "${k}.list" =>
      {
        source = v.source
        key    = data.http.repos[k].body
      }
    }
  }
}

module "default_node_group" {
  source       = "../node-group"
  api_server   = local.api_server
  name         = var.default_node_pool.name
  node_token   = module.certificates.node_token
  server_token = module.certificates.server_token
  type         = "system"
  nodes        = local.default_nodes
  taints       = var.default_node_pool.taints
  labels       = var.default_node_pool.labels
  annotations  = var.default_node_pool.annotations
  domain       = var.domain

  subnet       = var.subnet
  cluster_cidr = var.cluster_cidr
  service_cidr = var.service_cidr

  apt_sources        = terraform_data.apt_sources.output.apt_sources
  certificates_files = module.certificates.files
  dns_prefix         = var.dns_prefix

  k3s = var.k3s

  network_id = var.network_id
}

# module "worker_node_group" {
#   for_each        = { for node in var.worker_node_pools : node.name => node }
#   source          = "../node-group"
#   cluster_address = terraform_data.cluster.output.advertise_address
#   name            = each.value.name
#   token           = terraform_data.cluster.output.token
#   type            = "worker"
#   nodes = [for node in each.value.nodes : {
#     name    = module.metadata.name
#     address = node.address
#     exec_args = {
#       node_type = "worker"
#       node_ip   = node.address
#       server    = terraform_data.cluster.output.advertise_address
#       token     = terraform_data.cluster.output.token
#     }
#   }]
#   taints      = var.default_node_pool.taints
#   labels      = var.default_node_pool.labels
#   annotations = var.default_node_pool.annotations
# }

resource "terraform_data" "cluster" {
  input = {
    api_endpoint           = local.cluster_api_address
    client_certificate     = base64encode(module.certificates.client_certificate)
    client_key             = base64encode(module.certificates.client_key)
    cluster_ca_certificate = base64encode(module.certificates.cluster_ca_certificate)
  }

  depends_on = [module.default_node_group]
}
