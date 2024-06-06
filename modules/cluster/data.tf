data "http" "repos" {
  for_each = local.repos

  url = each.value.key_url
}

data "http" "k3s_channels" {
  url = "https://update.k3s.io/v1-release/channels"
}
