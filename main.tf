#---------------------------------------------------------------------------------------------
# Locals for readability
#---------------------------------------------------------------------------------------------

locals {
  project     = var.project
  environment = var.environment
  owner       = var.owner

  # Startpoint for our redis instance defaults
  module_instance_defaults = {
    display_name            = null
    tier                    = "STANDARD_HA"
    memory_size_gb          = 2
    redis_version           = "REDIS_5_0"
    auth_enabled            = true
    region                  = "europe-west4"
    location_id             = null
    alternative_location_id = null
    authorized_network      = null
    reserved_ip_range       = null
    connect_mode            = "PRIVATE_SERVICE_ACCESS"
    labels                  = {}
    owner                   = var.owner
  }

  # Merge module defaults with the user provided defaults
  instance_defaults = var.instance_defaults == null ? local.module_instance_defaults : merge(local.module_instance_defaults, var.instance_defaults)

  labels = {
    "creator"     = "terraform"
    "project"     = substr(replace(lower(local.project), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
    "environment" = substr(replace(lower(local.environment), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  }

  # Merge redis global default settings with redis specific settings and generate instance name
  # Example generated name: "myproject-dev-cache"
  instances = {
    for instance, settings in var.instances : instance => merge(
      local.instance_defaults,
      settings,
      {
        name                    = replace(lower(format("%s-%s-%s", local.project, local.environment, instance)), " ", "-")
        display_name            = try(settings.display_name, format("%s %s %s", local.project, local.environment, instance))
        alternative_location_id = try(settings.tier, local.instance_defaults.tier) == "STANDARD_HA" ? try(settings.alternative_location_id, local.instance_defaults.alternative_location_id) : null
        labels = merge(
          local.labels,
          {
            purpose = substr(replace(lower(instance), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
            owner   = substr(replace(lower(try(settings.owner, local.instance_defaults.owner)), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
          },
          try(settings.labels, {})
        )
      }
    )
  }
}

#---------------------------------------------------------------------------------------------
# Redis Instance
#---------------------------------------------------------------------------------------------

resource "google_redis_instance" "map" {
  provider = google-beta
  for_each = local.instances

  name           = each.value.name
  display_name   = each.value.display_name
  tier           = each.value.tier
  memory_size_gb = each.value.memory_size_gb
  redis_version  = each.value.redis_version
  auth_enabled   = each.value.auth_enabled

  region                  = each.value.region
  location_id             = each.value.location_id
  alternative_location_id = each.value.alternative_location_id

  authorized_network = each.value.authorized_network
  reserved_ip_range  = each.value.reserved_ip_range
  connect_mode       = each.value.connect_mode

  labels = each.value.labels
}
