data "http" "manifests" {
  for_each = local.manifests

  url = each.value
}
