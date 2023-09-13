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
  project_id       = "opz0-397319"
  location         = "asia-northeast1"
  service_accounts = ["serviceAccount:testing@xxxxxxx.iam.gserviceaccount.com"]
  role             = "roles/editor"
}
