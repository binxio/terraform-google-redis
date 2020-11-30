output "instance_defaults" {
  description = "The generic defaults used for Redis instances"
  value       = local.module_instance_defaults
}

output "map" {
  description = "outputs for all redis_instances created"
  value       = google_redis_instance.map
}

