resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits = 1024
}

resource "tls_self_signed_cert" "ca" {
  #key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    country = "BR"
    locality = "Sao_Paulo"
    organizational_unit = "DataPlatform"
    common_name  = "*.us-east-1.compute.internal"
    organization = "Itau"
  }

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth",
  ]

  validity_period_hours = 24000
  early_renewal_hours   = 720
  is_ca_certificate     = false
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "tls_cert_request" "default" {
  private_key_pem = "${tls_private_key.default.private_key_pem}"

  subject {
    country = "BR"
    locality = "Sao_Paulo"
    organizational_unit = "DataPlatform"
    common_name  = "*.us-east-1.compute.internal"
    organization = "Itau"
  }
}

resource "tls_locally_signed_cert" "default" {
  cert_request_pem   = "${tls_cert_request.default.cert_request_pem}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 43830

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

data "archive_file" "keys" {
  type        = "zip"
  output_path = "${path.module}/certs/cert_files.zip"

  source {
    content = "${tls_locally_signed_cert.default.cert_pem}"
    filename = "trustedCertificates.pem"
  }

  source {
    content = "${tls_locally_signed_cert.default.cert_pem}"
    filename = "certificateChain.pem"
  }

  source {
    content = "${tls_private_key.default.private_key_pem}"
    filename = "privateKey.pem"
  }
}

