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
    token = string
    host  = string
  })
  description = "Onepassword connect configuration."
}
