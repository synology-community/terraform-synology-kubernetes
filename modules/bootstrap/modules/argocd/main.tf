resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "secret" {

  metadata {
    name      = "github"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = { for k, v in var.github : replace(k, "_", "-") => v if v != null }

  type = "Opaque"

  lifecycle {
    ignore_changes = [metadata[0].annotations, metadata[0].labels, data]
  }
}


resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.50.1"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode(local.values)
  ]

  depends_on = [kubernetes_secret.secret]
}

resource "helm_release" "apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "1.4.1"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode(local.apps_values)
  ]

  depends_on = [helm_release.argocd]
}
