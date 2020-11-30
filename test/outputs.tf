output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = module.vpc.map
}

output "vpc_vars" {
  value = local.vpc
}
