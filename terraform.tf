terraform {
  backend "gcs" {
    bucket = "ca-kitano-study-sandbox-state"
    prefix = "inspec_research"
  }
}

provider "google" {
  project = terraform.workspace
  region  = "asia-northeast1"
}

provider "google-beta" {
  project = terraform.workspace
  region  = "asia-northeast1"
}
