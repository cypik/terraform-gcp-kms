data "google_client_config" "current" {}

module "labels" {
  source      = "cypik/labels/google"
  version     = "1.0.2"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
  extra_tags  = var.extra_tags
}

locals {
  keys_list = ["key1"]

  # Determine the KMS key IDs based on whether to prevent destruction
  keys_ids = var.prevent_destroy ? google_kms_crypto_key.key[*].id : google_kms_crypto_key.key_ephemeral[*].id

  # Ensure we have enough IDs
  keys_ids_final = length(local.keys_ids) == 0 ? [for _ in local.keys_list : ""] : local.keys_ids

  # Create a map of keys by name with corresponding IDs
  keys_by_name = zipmap(local.keys_list, local.keys_ids_final)
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
  count                         = var.prevent_destroy ? 1 : 0 # Create only one key if not preventing destruction
  name                          = format("%s-key", module.labels.id)
  key_ring                      = google_kms_key_ring.key_ring[0].id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  lifecycle {
    prevent_destroy = false
  }

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}
#####==============================================================================
# A CryptoKey represents logical key that can be used for cryptographic operations.
#####==============================================================================
resource "google_kms_crypto_key" "key_ephemeral" {
  count                         = var.prevent_destroy ? 1 : 0
  name                          = format("%s-cryptokey", module.labels.id)
  key_ring                      = google_kms_key_ring.key_ring[0].id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  lifecycle {
    prevent_destroy = false
  }

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

#####==============================================================================
#####Three different resources help you manage your IAM policy for KMS crypto key.
#####==============================================================================
resource "google_kms_crypto_key_iam_binding" "owners" {
  count = length(var.set_owners_for) > 0 && length(local.keys_by_name) >= length(var.set_owners_for) ? length(var.set_owners_for) : 0

  role          = "roles/owner"
  crypto_key_id = lookup(local.keys_by_name, var.set_owners_for[count.index], null)

  members = length(var.owners) > count.index ? compact(split(",", var.owners[count.index])) : []
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  count = length(var.set_decrypters_for) > 0 && length(local.keys_by_name) >= length(var.set_decrypters_for) ? length(var.set_decrypters_for) : 0

  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = lookup(local.keys_by_name, var.set_decrypters_for[count.index], null)

  members = length(var.decrypters) > count.index ? compact(split(",", var.decrypters[count.index])) : []
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  count = length(var.set_encrypters_for) > 0 && length(local.keys_by_name) >= length(var.set_encrypters_for) ? length(var.set_encrypters_for) : 0

  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = lookup(local.keys_by_name, var.set_encrypters_for[count.index], null)

  members = length(var.encrypters) > count.index ? compact(split(",", var.encrypters[count.index])) : []
}