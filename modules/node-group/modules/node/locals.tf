locals {
  write_files = concat(
    var.write_files,
    var.control_plane ? local.write_files_control_plane : [],
  )

  config_dir = "/etc/rancher/k3s"
  data_dir   = "/var/lib/rancher/k3s"

  env = {
    install_k3s_exec    = var.control_plane ? "server" : "agent"
    install_k3s_channel = var.k3s.channel
  }

  env_str = join(" ", [for k, v in local.env : "${upper(k)}=${v}"])

  init_cmd = [
    "curl -sfL https://get.k3s.io | ${local.env_str} sh -"
  ]

  write_files_control_plane = [
    {
      path    = "${local.config_dir}/config.yaml"
      content = yamlencode(local.config)
    }
  ]

  config = merge(
    var.primary_control_node ? {
      token        = var.server_token
      cluster-init = true
      } : {
      token  = var.node_token
      server = "https://${var.api_server.ip}:${var.api_server.port}"
    },
    length(var.labels) > 0 ? {
      node-label = [for label in var.labels : "${label.key}=${label.value}"]
    } : {},
    length(var.annotations) > 0 ? {
      node-annotation = [for annotation in var.annotations : "${annotation.key}=${annotation.value}"]
    } : {},
    length(var.taints) > 0 ? {
      node-taint = [for taint in var.taints : "${taint.key}=${taint.value}:${taint.effect}"]
    } : {},
  local.config_base)

  config_base = {
    node-ip = var.node_ip
    tls-san = [
      var.api_server.ip,
      join(".", [var.dns_prefix, var.domain])
    ]
    https-listen-port = 6443
    docker            = false
    flannel-backend   = "none"
    disable = [
      "coredns",
      "flannel",
      "local-storage",
      "metrics-server",
      "servicelb",
      "traefik",
    ]
    disable-network-policy   = true
    disable-cloud-controller = true
    disable-kube-proxy       = true
    cluster-cidr             = var.cluster_cidr
    service-cidr             = var.service_cidr
    write-kubeconfig-mode    = "777"
    etcd-expose-metrics      = true
    etcd-disable-snapshots   = true
    kube-controller-manager-arg = [
      "bind-address=0.0.0.0"
    ]
    kube-scheduler-arg = [
      "bind-address=0.0.0.0"
    ]
    kube-apiserver-arg = [
      "anonymous-auth=true",
      "bind-address=0.0.0.0",
    ]
  }
}
