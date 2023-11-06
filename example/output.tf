output "key_id" {
  value       = module.kms_key.key_id
  description = "An identifier for the resource with format"
}

output "keyring" {
  value       = module.kms_key.keyring
  description = "Self link of the keyring."
}

output "keyring_name" {
  value       = module.kms_key.keyring_name
  description = "Name of the keyring."
}

output "etag" {
  value       = module.kms_key.etag
  description = "The etag of the project's IAM policy."
}