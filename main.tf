terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.24.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  # We will pass the token via environment variable for security
}

resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "Transit engine for Kubernetes auto-unseal"
}

resource "vault_transit_secret_backend_key" "k8s_unseal_key" {
  backend = vault_mount.transit.path
  name    = "k8s-unseal-key"
  deletion_allowed = false 
}

resource "vault_policy" "k8s_autounseal" {
  name = "k8s-autounseal"

  policy = <<EOT
path "transit/encrypt/k8s-unseal-key" {
  capabilities = ["update"]
}

path "transit/decrypt/k8s-unseal-key" {
  capabilities = ["update"]
}
EOT
}

resource "vault_token" "k8s_bootstrap" {
  policies          = [vault_policy.k8s_autounseal.name]
  no_parent         = true
  period            = "24h"
  renewable         = true
}

output "kubernetes_bootstrap_token" {
  value     = vault_token.k8s_bootstrap.client_token
  sensitive = true
}
