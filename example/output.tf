output "keyring" {
  value = module.kms_key.keyring
}
output "keyring_resource" {
  value = module.kms_key.keyring_resource
}
output "keyring_name" {
  value = module.kms_key.keyring_name
}
output "key" {
  value = module.kms_key.key
}
