provider "google" {
  project = "soy-smile-435017-c5"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### kms_key module call .
#####==============================================================================
module "kms_key" {
  source      = "./../"
  name        = "apcdssdfdp"
  environment = "test"
  location    = "global"
  keys        = ["test"]
  role        = ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/cloudkms.cryptoKeyViewer"]
}