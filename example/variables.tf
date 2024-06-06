variable "maas_api_key" {
  type        = string
  description = "API Key for MaaS"
}

variable "maas_api_url" {
  type        = string
  description = "API URL for MaaS"
}

variable "github_access_token" {
  type        = string
  description = "Access token"
}

variable "github_client_id" {
  type        = string
  description = "Client ID"
}

variable "github_client_secret" {
  type        = string
  description = "Client secret"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "cloudflare_tunnel_id" {
  type        = string
  description = "Cloudflare tunnel ID"
}

variable "cloudflare_tunnel_secret" {
  type        = string
  description = "Cloudflare tunnel secret"
}

variable "cloudflare_account" {
  type        = string
  description = "Cloudflare account"
}

variable "op_token" {
  type        = string
  description = "Onepassword token"
}

variable "op_credentials" {
  type        = any
  description = "Onepassword credentials json"
}
