locals {
  name = "sample"
}

variable "project" {
  type = string
}

module "network" {
  source = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/vpc_network"

  project = var.project

  vpc_network = {
    name = local.name
  }
  subnetworks = [
    {
      name   = local.name
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    }
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = "ingress-sample"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
      log_config_metadata = null
    }
  ]
}

module "gce" {
  source = "github.com/AtsushiKitano/assets/terraform/gcp/modules/compute/gce"

  project        = var.project
  startup_script = "apt-get update && apt-get install -y nginx"

  gce_instance = {
    name         = local.name
    machine_type = "f1-micro"
    zone         = "asia-northeast1-b"
    subnetwork   = module.network.subnetwork_self_link[local.name]
    tags         = []
  }

  boot_disk = {
    name      = local.name
    size      = 20
    interface = null
    image     = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  external_ip        = local.name
  external_ip_region = "asia-northeast1"
}
