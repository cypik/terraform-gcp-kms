module "labels" {
  source      = "cypik/labels/google"
  version     = "1.0.1"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
}

data "google_client_config" "current" {
}

#####==============================================================================
#####A KeyRing is a top level logical grouping of CryptoKeys.
#####==============================================================================
resource "google_kms_key_ring" "key_ring" {
  count    = var.kms_key_ring_enabled && var.enabled ? 1 : 0
  name     = format("%s-ring", module.labels.id)
  project  = data.google_client_config.current.project
  location = var.location
}

#####==============================================================================
# A CryptoKey represents logical key that can be used for cryptographic operations.
#####==============================================================================
resource "google_kms_crypto_key" "key" {
  count           = var.kms_crypto_key_enabled && var.enabled ? 1 : 0
  name            = format("%s-key", module.labels.id)
  key_ring        = join("", google_kms_key_ring.key_ring[*].id)
  rotation_period = var.key_rotation_period
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }
}

#####==============================================================================
# A CryptoKey represents logical key that can be used for cryptographic operations.
#####==============================================================================
resource "google_kms_crypto_key" "key_ephemeral" {
  count           = var.kms_crypto_key_enabled && var.enabled ? 1 : 0
  name            = format("%s-cryptokey", module.labels.id)
  key_ring        = join("", google_kms_key_ring.key_ring[*].id)
  rotation_period = var.key_rotation_period
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }
}

#####==============================================================================
#####Three different resources help you manage your IAM policy for KMS crypto key.
#####==============================================================================
resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = var.kms_crypto_key_iam_binding_enabled && var.enabled ? 1 : 0
  role          = var.role
  crypto_key_id = join("", google_kms_crypto_key.key[*].id)
  members       = compact(split(",", var.service_accounts[count.index]))
}