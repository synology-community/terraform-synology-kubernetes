locals {
  interpreter = ["/usr/bin/ssh", "${var.ssh.user}@${var.ssh.host}"]
}
