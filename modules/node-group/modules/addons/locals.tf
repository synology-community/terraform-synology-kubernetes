locals {
  manifests_dir = "/var/lib/rancher/k3s/server/manifests"
  manifests = {
    cert-manager-crds     = "https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.crds.yaml"
    prometheus-crds       = "https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.68.0/stripped-down-crds.yaml"
    csi-addons-crds       = "https://raw.githubusercontent.com/csi-addons/kubernetes-csi-addons/main/deploy/controller/crds.yaml"
    csi-addons-rbac       = "https://raw.githubusercontent.com/csi-addons/kubernetes-csi-addons/main/deploy/controller/rbac.yaml"
    csi-addons-config     = "https://raw.githubusercontent.com/csi-addons/kubernetes-csi-addons/main/deploy/controller/csi-addons-config.yaml"
    csi-addons-controller = "https://raw.githubusercontent.com/csi-addons/kubernetes-csi-addons/main/deploy/controller/setup-controller.yaml"
    external-secrets-crds = "https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml"
  }

  addon_files = concat(
    [for v in fileset(path.module, "templates/*.yaml.tmpl") : {
      path        = format("${local.manifests_dir}/%s", replace(v, "/templates\\/(.+\\.yaml)\\.tmpl/", "$1"))
      permissions = "755"
      content = templatefile("${path.module}/${v}", {
        cluster_cidr             = var.cluster_cidr
        k3s_registration_address = var.api_server_ip
        subnet_cidr              = var.subnet
        cluster_ip               = cidrhost(var.service_cidr, 10)
      })
      }], [for k in keys(local.manifests) : {
      path        = "${local.manifests_dir}/${k}.yaml"
      permissions = "755"
      content     = data.http.manifests[k].body
  }])
}
