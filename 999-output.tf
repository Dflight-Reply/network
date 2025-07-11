output "vpc_id" {
  value = module.vpc_noprod.vpc.id
}

output "subnet_ids" {
  value = [for s in module.vpc_noprod.subnet_public : s.id]
}