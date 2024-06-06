resource "helm_release" "connect" {
  name       = "connect"
  repository = "https://1password.github.io/connect-helm-charts"
  chart      = "connect"
  version    = "1.14.0"
  namespace  = "kube-system"

  values = [
    yamlencode(local.values)
  ]
}
