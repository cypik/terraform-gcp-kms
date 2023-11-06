output "keyring" {
  value       = join("", google_kms_key_ring.key_ring[*].id)
  description = "Self link of the keyring."
}

output "keyring_name" {
  value       = join("", google_kms_key_ring.key_ring[*].name)
  description = "Name of the keyring."
}

output "key_id" {
  value       = join("", google_kms_crypto_key.key[*].id)
  description = "An identifier for the resource with format"
}

output "etag" {
  value       = join("", compact(google_kms_crypto_key_iam_binding.owners[*].etag))
  description = "The etag of the project's IAM policy."
}