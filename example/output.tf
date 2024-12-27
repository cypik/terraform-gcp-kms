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

output "keys" {
  value       = module.kms_key.keys
  description = "Map of key name => key self link."
}