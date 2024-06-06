resource "kubernetes_secret" "secret" {
  for_each = zipmap(var.secrets[*].name, var.secrets)

  metadata {
    name      = each.value.name
    namespace = each.value.namespace
  }

  data = each.value.data

  type = each.value.type

  lifecycle {
    ignore_changes = [metadata[0].annotations, metadata[0].labels, data]
  }
}
