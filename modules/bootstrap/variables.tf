variable "secrets" {
  type = list(object({
    name      = string
    namespace = string
    type      = string
    data      = map(string)
  }))
  description = "Secrets to create in the cluster."
}

variable "domain" {
  type        = string
  description = "Domain of the node"
}

variable "github" {
  type = object({
    access_token  = string
    org           = string
    client_id     = string
    client_secret = string
  })
  description = "Github configuration."
}

variable "connect" {
  type = object({
    enabled     = bool
    host        = string
    token       = string
    secret_name = string
    credentials = object({
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
    })
  })
  description = "1Password Connect configuration."
}
