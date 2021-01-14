locals {
  enable = true

  prefix  = "research"
  _enable = local.enable ? [local.prefix] : []
}

module "network" {
  for_each = toset(local._enable)
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = local.prefix
  }
  subnetworks = [
    {
      name   = local.prefix
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = local.prefix
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      log_config_metadata = null
    },
  ]
}
