locals {
  owner       = "myself"
  project     = "demo"
  environment = "dev"
}

#############################################################
#
# Cluster configuration
#
#############################################################
module "redis" {
  source  = "binxio/redis/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  instances = {
    "cache" = {
      authorized_network = module.vpc.vpc
    }
  }
}

#############################################################
#
# Set up prerequisite services
#
#############################################################

module "vpc" {
  source  = "binxio/network-vpc/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  network_name = "private"
  subnets = {
    "demo" = {
      ip_cidr_range = "10.10.0.0/25"
      region        = "europe-west4"
    }
  }
}
