output "vpc_id" {
  value = module.vpc_noprod.vpc.id
}

output "public_subnet_ids" {
  description = "IDs subnet pubbliche per ALB e NAT Gateway"
  value       = [for s in module.vpc_noprod.subnet_public : s.id]
}

# Legacy output for backward compatibility
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

# ALB outputs removed - ALB is managed by EKS project
# output "alb_target_group_arn" {
#   value = module.vpc_noprod.alb_target_group_arn
# }
# output "alb_dns_name" {
#   value = module.vpc_noprod.alb_dns_name
# }

# Output to be red from remote state from other projects (e.g. eks)
output "private_logic_subnet_ids" {
  description = "IDs subnet private logic for EKS/ECR/EFS"
  value       = [for s in module.vpc_noprod.subnet_private-logic : s.id]
}

output "private_data_subnet_ids" {
  description = "IDs subnet private data for databases and storage"
  value       = [for s in module.vpc_noprod.subnet_private-data : s.id]
}

output "private_logic_security_group_id" {
  description = "security group ID for private logic resources"
  value       = module.vpc_noprod.securitygroup_private_logic.id
}

output "private_data_security_group_id" {
  description = "security group ID for private data resources"
  value       = module.vpc_noprod.securitygroup_private_data.id
}

# WAF outputs for EKS project integration
output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN for ALB association in EKS project"
  value       = module.vpc_noprod.waf_web_acl_arn
}

output "waf_web_acl_id" {
  description = "WAF Web ACL ID for reference"
  value       = module.vpc_noprod.waf_web_acl_id
}
