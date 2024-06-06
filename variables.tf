variable "domain" {
  type        = string
  description = "Domain of the cluster"
}

variable "network_id" {
  type = string
  description = "ID of the network"
}

variable "subnet" {
  type        = string
  description = "Subnet of the node"
  default     = "10.1.40.0/24"
  nullable    = false
}

variable "k3s" {
  type = object({
    channel     = optional(string, "v1.28")
    channel_url = optional(string, "https://update.k3s.io/v1-release/channels")
  })
  description = "K3s configuration."
  default     = {}
  nullable    = false
}

variable "cluster_cidr" {
  type        = string
  description = "CIDR of the cluster"
  default     = "10.32.0.0/16"
  nullable    = false
}

variable "service_cidr" {
  type        = string
  description = "CIDR of the cluster"
  default     = "10.33.0.0/16"
  nullable    = false
}

variable "secrets" {
  type = list(object({
    name      = string
    namespace = optional(string, "kube-system")
    type      = optional(string, "Opaque")
    data      = map(string)
  }))
  description = "Secrets to create in the cluster."
  default     = []
  nullable    = false
}

variable "github" {
  type = object({
    access_token  = string
    org           = string
    client_id     = optional(string)
    client_secret = optional(string)
  })
  description = "Github configuration."
}

variable "connect" {
  type = object({
    enabled     = bool
    host        = optional(string, "http://onepassword-connect.kube-system.svc.cluster.local:8080")
    token       = optional(string)
    secret_name = optional(string, "op-credentials")
    credentials = optional(object({
      version = optional(string, "2")
      verifier = object({
        salt      = string
        localHash = string
      })
      healthVerifier = optional(string)
      encCredentials = object({
        kid  = string
        enc  = string
        cty  = string
        iv   = string
        data = string
      })
      uniqueKey = object({
        alg = string
        kid = string
        k   = string
        key_ops = optional(list(string), [
          "encrypt",
          "decrypt"
        ])
        ext = optional(bool, false)
        kty = string
      })
      deviceUuid = string
    }))
  })
  description = "1Password Connect configuration."
  default     = { enabled = false }
  nullable    = false
}
