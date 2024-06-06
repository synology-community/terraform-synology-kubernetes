resource "time_static" "ca" {}
# Keys
resource "tls_private_key" "ca" {
  for_each = local.certificates

  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# certs
resource "tls_self_signed_cert" "ca" {
  for_each = local.certificates

  validity_period_hours = (365 * 24 * var.validity_period_years)
  allowed_uses          = ["digital_signature", "key_encipherment", "cert_signing"]
  private_key_pem       = tls_private_key.ca[each.key].private_key_pem
  is_ca_certificate     = true

  subject {
    common_name = format("k3s-%s@%s", each.key, time_static.ca.unix)
  }
}

# client-admin cert
resource "tls_private_key" "client_admin" {

  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "client_admin" {

  private_key_pem = tls_private_key.client_admin.private_key_pem

  subject {
    common_name  = "kube-admin"
    organization = "system:masters"
  }
}

resource "tls_locally_signed_cert" "client_admin" {

  cert_request_pem   = tls_cert_request.client_admin.cert_request_pem
  ca_private_key_pem = tls_private_key.ca["client-ca"].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca["client-ca"].cert_pem

  validity_period_hours = 876600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
}

resource "random_password" "token" {
  length  = 22
  special = false
  upper   = false
}

resource "terraform_data" "token" {
  input = {
    token = base64encode(replace(random_password.token.result, "/^([a-z0-9]{6})([a-z0-9]{16})$/", "$1.$2"))
  }

  lifecycle {
    precondition {
      condition     = can(regex("^([a-z0-9]{6})([a-z0-9]{16})$", nonsensitive(random_password.token.result)))
      error_message = "Invalid input data for token. Token data should be 22 characters long. Data: ${nonsensitive(random_password.token.result)}"
    }

    postcondition {
      condition     = can(regex("^[a-z0-9]{6}\\.[a-z0-9]{16}$", base64decode(self.output.token)))
      error_message = "Invalid token format. Must be in the form of 6 lowercase letters, followed by a dot, followed by 16 lowercase letters and numbers. For example: 5didvk.d09sbcov8ph2amjw"
    }
  }
}
