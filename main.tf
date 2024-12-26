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

data "google_storage_project_service_account" "gcs_account" {
  project = data.google_client_config.current.project
}

locals {

  keys_by_name = zipmap(
    var.keys,
    var.prevent_destroy ?
    slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)) :
    slice(google_kms_crypto_key.key_ephemeral[*].id, 0, length(var.keys))
  )
}

resource "google_kms_key_ring" "key_ring" {
  count    = var.kms_key_ring_enabled && var.enabled ? 1 : 0
  name     = format("%s-ring", module.labels.id)
  project  = data.google_client_config.current.project
  location = var.location
}

resource "google_kms_crypto_key" "key" {
  count                         = var.prevent_destroy ? 1 : 0 # Create only one key if not preventing destruction
  name                          = format("%s-key", module.labels.id)
  key_ring                      = google_kms_key_ring.key_ring[0].id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count                         = var.prevent_destroy ? 1 : 0
  name                          = format("%s-cryptokey", module.labels.id)
  key_ring                      = google_kms_key_ring.key_ring[0].id
  rotation_period               = var.key_rotation_period
  purpose                       = var.purpose
  import_only                   = var.import_only
  skip_initial_version_creation = var.skip_initial_version_creation
  crypto_key_backend            = var.crypto_key_backend

  destroy_scheduled_duration = var.key_destroy_scheduled_duration

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = length(var.set_owners_for)
  role          = "roles/owner"
  crypto_key_id = local.keys_by_name[var.set_owners_for[count.index]]
  members       = compact(split(",", var.owners[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  count         = length(var.set_decrypters_for)
  role          = var.role[count.index]
  crypto_key_id = local.keys_by_name[var.set_decrypters_for[count.index]]
  members       = compact(split(",", var.decrypters[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  count         = length(var.set_encrypters_for)
  role          = var.role[count.index]
  crypto_key_id = local.keys_by_name[element(var.set_encrypters_for, count.index)]
  members       = compact(split(",", var.encrypters[count.index]))
}

resource "google_kms_crypto_key_iam_member" "key_encryption_role" {
  crypto_key_id = google_kms_crypto_key.key[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_kms_key_ring_iam_member" "kms_key_access" {
  key_ring_id = google_kms_key_ring.key_ring[0].id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}