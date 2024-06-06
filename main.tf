/**
 # Synology Kubernetes Cluster
*/

module "cluster" {
  source = "./modules/cluster"
  subnet = var.subnet

  cluster_address = local.api_endpoint
  domain          = var.domain

  network_id = var.network_id

  cluster_cidr = var.cluster_cidr
  service_cidr = var.service_cidr

  k3s = {
    channel     = var.k3s.channel
    channel_url = var.k3s.channel_url
  }
}

module "bootstrap" {
  source = "./modules/bootstrap"

  secrets = var.secrets

  github  = var.github
  domain  = var.domain
  connect = var.connect

  depends_on = [module.cluster]
}
