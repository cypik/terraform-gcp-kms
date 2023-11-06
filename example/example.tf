provider "google" {
  project = "opz0-397319"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### kms_key module call .
#####==============================================================================
module "kms_key" {
  source           = ".././"
  name             = "app"
  environment      = "test"
  location         = "asia-northeast1"
  service_accounts = ["serviceAccount:xxxxxxxxx-compute@developer.gserviceaccount.com"]
  role             = "roles/editor"
}