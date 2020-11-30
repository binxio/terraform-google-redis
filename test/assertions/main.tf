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
    "terratest this is way too long and contains invalid chars!!!" = {
    }
  }
}

output "redis" {
  value = module.redis.map.cache
}
