locals {
  runcmd = concat(
    formatlist("modprobe %s", local.modules),
    [
      "sysctl --system",
      "swapoff -a"
    ],
    var.runcmd
  )

  cloud_init = {
    apt_update                 = true
    apt_upgrade                = true
    package_update             = true
    package_upgrade            = true
    package_reboot_if_required = false
    ssh_import_id              = var.ssh_import_id
    hostname                   = var.hostname
    fqdn                       = join(".", [var.hostname, var.domain])
    apt = {
      sources = var.apt_sources
    }
    packages = local.packages
    write_files = concat(
      [
        {
          content = join("\n", local.modules)
          path    = "/etc/modules-load.d/k8s.conf"
        },
        {
          content = join("\n", local.sysctl)
          path    = "/etc/sysctl.d/k8s.conf"
        }
      ],
      [for f in fileset(path.module, "files/*") : {
        path        = "/etc/systemd/system/${basename(f)}"
        permissions = "755"
        content = file("${path.module}/${f}") }
      ],
      var.write_files,
    )

    runcmd = local.runcmd

    users = [
      "default",
      {
        name          = "terraform"
        groups        = ["users", "sudo"]
        shell         = "/bin/bash"
        lock_passwd   = true
        ssh_import_id = var.ssh_import_id
    }]
  }

  modules = [
    "br_netfilter",
    "ceph",
    "ip_vs",
    "ip_vs_rr",
    "nbd",
    "overlay",
    "rbd",
  ]

  sysctl = [
    "net.ipv4.ip_forward = 1",
    "net.bridge.bridge-nf-call-iptables = 1",
    "net.bridge.bridge-nf-call-ip6tables = 1",
    "net.bridge.bridge-nf-call-arptables = 1",
    "fs.inotify.max_queued_events = 65536",
    "fs.inotify.max_user_watches = 524288",
    "fs.inotify.max_user_instances = 8192",
  ]

  packages = [
    "apt-transport-https",
    "ca-certificates",
    "software-properties-common",
    "net-tools",
    "curl",
    "kexec-tools",
    "kubectl",
    "containerd",
    "helm",
  ]
}
