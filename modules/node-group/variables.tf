variable "network_id" {
  type = string
  description = "ID of the network"
}

variable "api_server" {
  type = object({
    ip   = string
    port = number
  })
  description = "IP and port of the API server"
}

variable "k3s" {
  type = object({
    channel     = string
    channel_url = string
  })
  description = "K3S configuration."
}

variable "domain" {
  type        = string
  description = "Domain of the node"
}

variable "dns_prefix" {
  description = "DNS prefix of the cluster."
  type        = string
}

variable "addons" {
  description = "Addons of the cluster."
  type        = list(string)
  default     = ["cilium", "prometheus"]
  nullable    = false
}

variable "name" {
  description = "Name of the node group."
  type        = string
  default     = null
  nullable    = true
}

variable "type" {
  description = "Type of the node group."
  type        = string
  default     = "worker"
  nullable    = false

  validation {
    condition     = contains(["system", "worker"], var.type)
    error_message = "Type must be either system or worker."
  }
}

variable "apt_sources" {
  type = map(object({
    source = string
    key    = string
  }))
  description = "APT sources to add to the node"
}

variable "certificates_files" {
  type = list(object({
    path    = string
    content = string
  }))
  description = "Certificate file data"
}

variable "tls_san" {
  type        = list(string)
  description = "Extra IPs to add to the TLS SAN list."
  default     = null
}

variable "nodes" {
  description = "Nodes of the node group."
  type = list(object({
    name      = optional(string)
    exec_args = optional(any)
    address   = optional(string)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = optional(string)
    })), [])
    labels = optional(list(object({
      key   = string
      value = string
    })), [])
    annotations = optional(list(object({
      key   = string
      value = string
    })), [])
  }))
  default  = []
  nullable = false
}

variable "taints" {
  description = "Taints of the node group."
  type = list(object({
    key    = string
    value  = string
    effect = optional(string)
  }))
  default  = []
  nullable = false
}

variable "labels" {
  description = "Labels of the node group."
  type = list(object({
    key   = string
    value = string
  }))
  default  = []
  nullable = false
}

variable "annotations" {
  description = "Annotations of the node group."
  type = list(object({
    key   = string
    value = string
  }))
  default  = []
  nullable = false
}

variable "subnet" {
  type        = string
  description = "Subnet of the node"
  nullable    = false
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR of the cluster"
}

variable "service_cidr" {
  type        = string
  description = "CIDR of the cluster"
}

variable "server_token" {
  type        = string
  description = "Token"

  validation {
    condition     = can(regex("^[a-z0-9]{6}\\.[a-z0-9]{16}$", base64decode(var.server_token)))
    error_message = "Token must be in the form of 6 lowercase letters, followed by a dot, followed by 16 lowercase letters and numbers. For example: 5didvk.d09sbcov8ph2amjw"
  }
}

variable "node_token" {
  type        = string
  description = "Token"
}
