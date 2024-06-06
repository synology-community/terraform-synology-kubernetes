# data "template_cloudinit_config" "config" {
#   gzip          = false
#   base64_encode = false
#   part {
#     content_type = "text/cloud-config"
#     content      = format("#cloud-config\n%s", yamlencode(local.cloud_init))
#   }
# }
