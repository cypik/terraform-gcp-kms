output "key_id" {
  value       = join("", google_kms_crypto_key.key[*].id)
  description = "An identifier for the resource with format"
}

output "etag" {
  value       = join("", compact(google_kms_crypto_key_iam_binding.owners[*].etag))
  description = "The etag of the project's IAM policy."
}

output "keyring_ids" {
  value       = google_kms_key_ring.key_ring[*].id
  description = "List of key ring IDs created in Google Cloud KMS."
}

output "keyring_names" {
  value       = google_kms_key_ring.key_ring[*].name
  description = "List of key ring names created in Google Cloud KMS."
}

output "keyring_resource" {
  description = "Keyring resource."
  value       = google_kms_key_ring.key_ring

  # The grants are important to the key be ready to use.
  depends_on = [
    google_kms_crypto_key_iam_binding.owners,
    google_kms_crypto_key_iam_binding.decrypters,
    google_kms_crypto_key_iam_binding.encrypters,
  ]
}

output "keys" {
  description = "Map of key name => key self link."
  value       = local.keys_by_name

  # The grants are important to the key be ready to use.
  depends_on = [
    google_kms_crypto_key_iam_binding.owners,
    google_kms_crypto_key_iam_binding.decrypters,
    google_kms_crypto_key_iam_binding.encrypters,
  ]
}