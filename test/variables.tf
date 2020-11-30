variable "environment" {
  description = "Allows us to use random environment for our tests"
  type        = string
}

variable "project" {
  description = "Allows us to use random project for our tests"
  type        = string
}

variable "location" {
  description = "Allows us to use random location for our tests"
  type        = string
}

variable "owner" {
  description = "Owner used for tagging"
  type        = string
}

variable "subnetwork" {
  description = "The name output of created subnet for GKE"
  type        = string
}

variable "network" {
  description = "The self_link output of created vpc for GKE"
  type        = string
}
