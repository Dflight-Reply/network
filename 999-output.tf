output "vpc_id" {
  value = module.vpc_noprod.vpc.id
}

output "subnet_ids" {
  value = [for s in module.vpc_noprod.subnet_public : s.id]
}

# output for ec2 test instances
output "ec2_public_private_ips" {
  value = { for k, v in aws_instance.public : k => v.private_ip }
}

output "ec2_private_logic_private_ips" {
  value = { for k, v in aws_instance.private-logic : k => v.private_ip }
}

output "ec2_private_data_private_ips" {
  value = { for k, v in aws_instance.private-data : k => v.private_ip }
}

output "alb_target_group_arn" {
  value = module.vpc_noprod.alb_target_group_arn
}

output "alb_dns_name" {
  value = module.vpc_noprod.alb_dns_name
}