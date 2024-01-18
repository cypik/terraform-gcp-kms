provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### kms_key module call .
#####==============================================================================
module "kms_key" {
  source           = ".././"
  name             = "avddfpp"
  environment      = "test"
  location         = "asia-northeast1"
  service_accounts = ["serviceAccount:985070905024-compute@developer.gserviceaccount.com"]
  role             = "roles/editor"
}