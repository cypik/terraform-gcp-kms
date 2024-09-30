variable "name" {
  type        = string
  default     = "test"
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the resource."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'"
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-google-kms"
  description = "Terraform current module repo"
}

variable "kms_key_ring_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable service-account ."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location for the keyring."
}

variable "key_algorithm" {
  type        = string
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
}

variable "key_protection_level" {
  type        = string
  default     = "SOFTWARE"
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
}

variable "key_rotation_period" {
  description = "Generate a new key every time this period passes."
  type        = string
  default     = "100000s"
}

variable "purpose" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  description = "The immutable purpose of the CryptoKey. Possible values are ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, and ASYMMETRIC_DECRYPT."
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  type        = bool
  default     = true
}

variable "key_destroy_scheduled_duration" {
  description = "Set the period of time that versions of keys spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED."
  type        = string
  default     = null
}

variable "set_owners_for" {
  description = "Name of keys for which owners will be set."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of comma-separated owners for each key declared in set_owners_for."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "decrypters" {
  description = "List of comma-separated owners for each key declared in set_decrypters_for."
  type        = list(string)
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "import_only" {
  type        = bool
  description = "Whether these keys may contain imported versions only."
  default     = false
}

variable "skip_initial_version_creation" {
  type        = bool
  description = "If set to true, the request will create CryptoKeys without any CryptoKeyVersions."
  default     = false
}

variable "crypto_key_backend" {
  type        = string
  description = "(Optional) The resource name of the backend environment associated with all CryptoKeyVersions within this CryptoKey. The resource name is in the format 'projects//locations//ekmConnections/*' and only applies to 'EXTERNAL_VPC' keys."
  default     = null
}