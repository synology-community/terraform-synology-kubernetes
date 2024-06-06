variable "subnet" {
  type        = string
  description = "Subnet of the node"
  nullable    = false
}

variable "api_server_ip" {
  type        = string
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
