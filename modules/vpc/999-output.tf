output "vpc" {
  value = aws_vpc.this
}

output "subnet_private-logic" {
  value = aws_subnet.private-logic
}

output "subnet_private-data" {
  value = aws_subnet.private-data
}

output "subnet_public" {
  value = aws_subnet.public
}

output "securitygroup_private_logic" {
  value = aws_security_group.private-logic
}

output "securitygroup_private_data" {
  value = aws_security_group.private-data
}

output "securitygroup_public" {
  value = aws_security_group.public
}

output "securitygroup_default" {
  value = aws_default_security_group.default
}

# output "alb" {
#   value = aws_lb.dflight-alb
# }

# output "alb_tg" {
#   value = aws_lb_target_group.dflight-tg-eks
# }

# output "alb_listener" {
#   value = aws_lb_listener.dflight-listener
# }