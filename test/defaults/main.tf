locals {
  owner       = "myself"
  project     = var.project
  environment = var.environment
}

module "redis" {
  source = "../../"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  instances = {
    "cache" = {
      authorized_network = var.network
    }
  }
}

output "redis" {
  value = module.redis.map.cache
}
