output "key_id" {
  value       = module.kms_key.key_id
  description = "An identifier for the resource with format"
}

output "keyring_name" {
  value       = module.kms_key.keyring_names
  description = "Name of the keyring."
}

output "etag" {
  value       = module.kms_key.etag
  description = "The etag of the project's IAM policy."
}

output "keyring_ids" {
  value       = module.kms_key.keyring_ids
  description = "List of key ring IDs created in Google Cloud KMS."
}

output "keyring_resource" {
  description = "Keyring resource."
  value       = module.kms_key.keyring_resource

  # The grants are important to the key be ready to use.
  depends_on = [
    module.kms_key.google_kms_crypto_key_iam_binding_owners,
    module.kms_key.google_kms_crypto_key_iam_binding_decrypters,
    module.kms_key.google_kms_crypto_key_iam_binding_encrypters,
  ]
}

output "keys" {
  description = "Map of key name => key self link."
  value       = module.kms_key.keys

  # The grants are important to the key be ready to use.
  depends_on = [
    module.kms_key.google_kms_crypto_key_iam_binding_owners,
    module.kms_key.google_kms_crypto_key_iam_binding_decrypters,
    module.kms_key.google_kms_crypto_key_iam_binding_encrypters,
  ]
}
