variable "validity_period_years" {
  type        = number
  description = "Number of years the certificate is valid for"
  default     = 100
}

variable "subject" {
  description = "The subject of the certificate. This is a map of string to string. The keys are the names of the subject fields, and the values are the values for those fields. The following keys are supported: country, locality, organization, organizational_unit, postal_code, province, serial_number, street_address."
  type = object({
    country             = optional(string, "US")
    locality            = optional(string, "San Francisco")
    organization        = optional(string, "Cloudflare, Inc.")
    organizational_unit = optional(string, "Cloudflare, Inc.")
    postal_code         = optional(string, "94107")
    province            = optional(string, "California")
    serial_number       = optional(string, "5157550")
    street_address      = optional(string, "101 Townsend St")
  })
  default  = {}
  nullable = false
}

variable "tls_san" {
  type        = list(string)
  description = "Extra IPs to add to the TLS SAN list."
  default     = []
  nullable    = false
}
