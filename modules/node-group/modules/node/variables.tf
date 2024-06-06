variable "name" {
  type        = string
  description = "Name of the node"
}

variable "domain" {
  type        = string
  description = "Domain of the node"
}

variable "network_id" {
  type        = string
  description = "ID of the network"
}

variable "dns_prefix" {
  description = "DNS prefix of the cluster."
  type        = string
}

variable "k3s" {
  type = object({
    channel     = string
    channel_url = string
  })
  description = "K3S configuration."
}

variable "node_ip" {
  type        = string
  description = "IP address of the node"
  validation {
    condition     = can(regex("^10|192|178\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", var.node_ip))
    error_message = "node_ip must be internal"
  }
}

variable "interface" {
  type        = string
  description = "Primary interface of the node"
  default     = "eno1"
  nullable    = false
}

variable "subnet" {
  type        = string
  description = "Subnet of the node"
  nullable    = false

  validation {
    condition     = can(regex("^10|192|178\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,3}$", var.subnet))
    error_message = "Invalid subnet cidr"
  }
}

variable "tags" {
  type        = list(string)
  description = "Tags to add to the node"

  default = ["kubernetes"]

  nullable = false
}

variable "image_id" {
  type = string
  description = "ID of the image to use for the node"
  nullable    = false
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

variable "write_files" {
  type = list(object({
    path    = string
    content = string
  }))
  description = "Files to be created on the server."
}

variable "apt_sources" {
  type = map(object({
    source = string
    key    = string
  }))
  description = "APT sources to add to the node"
}

variable "ssh_import_id" {
  type        = list(string)
  description = "SSH keys to import to the node"
  default     = ["gh:appkins"]
  nullable    = false
}

variable "primary_control_node" {
  type        = bool
  description = "Whether this node is the primary control node"
  default     = false
}

variable "control_plane" {
  type        = bool
  description = "Whether this node is a control plane node"
}

variable "api_server" {
  type = object({
    ip   = string
    port = number
  })
  description = "IP and port of the API server"
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR of the cluster"
}

variable "service_cidr" {
  type        = string
  description = "CIDR of the cluster"
}

variable "taints" {
  description = "Taints of the node group."
  type = list(object({
    key    = string
    value  = string
    effect = optional(string)
  }))
  nullable = false
}

variable "labels" {
  description = "Labels of the node group."
  type = list(object({
    key   = string
    value = string
  }))
  nullable = false
}

variable "annotations" {
  description = "Annotations of the node group."
  type = list(object({
    key   = string
    value = string
  }))
  nullable = false
}
