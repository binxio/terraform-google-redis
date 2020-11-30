#------------------------------------------------------------------------------------------------------------------------
# 
# Generic variables
#
#------------------------------------------------------------------------------------------------------------------------
variable "owner" {
  description = "Owner of the resource. This variable is used to set the 'owner' label."
  type        = string
}

variable "project" {
  description = "Company project name."
  type        = string
}

variable "environment" {
  description = "Company environment for which the resources are created (e.g. dev, tst, acc, prd, all)."
  type        = string
}

#---------------------------------------------------------------------------------------------
#
# GKE settings related variables
#
#---------------------------------------------------------------------------------------------

variable "instances" {
  description = <<EOF
Map of Redis instances to be created. The key will be used for the instance name so it should describe the purpose. The value can be a map with the following keys to override default settings:
  * display_name
  * tier
  * memory_size_gb
  * redis_version
  * region
  * location_id
  * alternative_location_id
  * authorized_network
  * connect_mode
  * reserved_ip_range
  * labels
  * owner
EOF
  type        = any
}

variable "instance_defaults" {
  description = "Redis instance defaults"
  type = object({
    display_name            = string
    tier                    = string
    memory_size_gb          = number
    redis_version           = string
    region                  = string
    location_id             = string
    alternative_location_id = string
    authorized_network      = string
    connect_mode            = string
    reserved_ip_range       = string
    labels                  = map(string)
    owner                   = string
  })
  default = null
}
