variable "name" {
  description = "Name of the cluster."
  type        = string
  default     = null
  nullable    = true
}

variable "network_id" {
  type = string
  description = "ID of the network"
}

variable "domain" {
  type        = string
  description = "Domain of the node"
}

variable "dns_prefix" {
  description = "DNS prefix of the cluster."
  type        = string
  default     = "k3s"
  nullable    = false
}

variable "cluster_address" {
  type        = string
  description = "IP address of the cluster"
  default     = null
}

variable "k3s" {
  type = object({
    channel     = string
    channel_url = string
  })
  description = "K3S configuration."
}

variable "subnet" {
  type        = string
  description = "Subnet of the node"
  nullable    = false
}

variable "cluster_cidr" {
  type        = string
  description = "Pod CIDR of the cluster."
}

variable "service_cidr" {
  description = "Service CIDR of the cluster."
  type        = string
  default     = null
  nullable    = true
}

variable "addons" {
  description = "Addons of the cluster."
  type        = list(string)
  default     = null
  nullable    = true
}

variable "endpoint" {
  type        = string
  description = "Endpoint of the cluster."
  default     = null
}

variable "default_node_pool" {
  description = "Default node pool"
  type = object({
    name = optional(string, "kube")
    nodes = optional(list(object({
      name      = optional(string)
      address   = optional(string)
      exec_args = optional(any, {})
    })), [{}, {}, {}])
    taints = optional(list(object({
      key    = optional(string)
      value  = optional(string)
      effect = optional(string)
    })), [])
    labels = optional(list(object({
      key   = optional(string)
      value = optional(string)
    })), [])
    annotations = optional(list(object({
      key   = optional(string)
      value = optional(string)
    })), [])
  })
  default = {}
}

variable "worker_node_pools" {
  description = "Worker node pool"
  type = list(object({
    name = optional(string, "worker")
    nodes = optional(list(object({
      name      = optional(string)
      address   = optional(string)
      exec_args = optional(any, {})
    })), [])
    taints = optional(list(object({
      key    = optional(string)
      value  = optional(string)
      effect = optional(string)
    })), [])
    labels = optional(list(object({
      key   = optional(string)
      value = optional(string)
    })), [])
    annotations = optional(list(object({
      key   = optional(string)
      value = optional(string)
    })), [])
  }))
  default = []
}
