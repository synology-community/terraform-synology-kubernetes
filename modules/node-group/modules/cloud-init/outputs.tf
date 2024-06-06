output "rendered" {
  value = format("#cloud-config\n%s", yamlencode(local.cloud_init))
}
