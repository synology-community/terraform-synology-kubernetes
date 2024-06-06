data "shell_script" "default" {
  lifecycle_commands {
    read = file("${path.module}/scripts/read.sh")
  }

  interpreter = local.interpreter
}

resource "terraform_data" "default" {
  input = {
    private_ip = lookup(data.shell_script.default.output, "ip", null)
    public_ip  = lookup(data.shell_script.default.output, "public_ip", null)
    ips        = split(",", lookup(data.shell_script.default.output, "ips", ""))
    device     = lookup(data.shell_script.default.output, "dev", null)
    name       = lookup(data.shell_script.default.output, "host", null)
    os = {
      name    = lookup(data.shell_script.default.output, "os_name", null)
      version = lookup(data.shell_script.default.output, "os_version", null)
    }
  }

  /* lifecycle {
    ignore_changes = [input]
  } */
}
