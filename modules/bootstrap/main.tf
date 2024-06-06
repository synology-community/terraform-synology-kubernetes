module "secrets" {
  count = length(local.secrets) > 0 ? 1 : 0

  source = "./modules/secrets"

  secrets = local.secrets
}

module "connect" {
  count = var.connect.enabled ? 1 : 0

  source = "./modules/connect"

  domain      = var.domain
  secret_name = var.connect.secret_name

  depends_on = [module.secrets]
}

module "argocd" {
  source = "./modules/argocd"

  domain  = var.domain
  github  = var.github
  connect = var.connect

  depends_on = [module.connect]
}
