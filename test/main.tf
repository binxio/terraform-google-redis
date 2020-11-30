locals {
  owner       = "myself"
  project     = var.project
  environment = var.environment

  vpc = {
    network_name = "private-redis"
    subnets = {
      "redis-asserts" = {
        ip_cidr_range = "10.20.0.0/25"
        region        = "europe-west4"
      }
      "redis-instances" = {
        ip_cidr_range = "10.10.0.0/25"
        region        = "europe-west4"
      }
    }

    service_networking_connection = {
      "google-managed-services-cloudsql" = {
        private_ip_address = {
          purpose       = "VPC_PEERING"
          prefix_length = 24
          address_type  = "INTERNAL"
        }
      }
    }
  }
}

module "vpc" {
  source  = "binxio/network-vpc/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  network_name                  = local.vpc.network_name
  subnets                       = local.vpc.subnets
  service_networking_connection = local.vpc.service_networking_connection
}
