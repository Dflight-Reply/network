#resource "aws_cloudwatch_log_group" "client_vpn" {
#  count = try(var.client_vpn.enabled, false) && try(var.client_vpn.connection_log_options.enabled, false) ? 1 : 0
#  name  = "vpc/${var.vpc.name}/client_vpn"
#}
#
#
#resource "aws_ec2_client_vpn_endpoint" "client_vpn_endpoint" {
#  count                  = try(var.client_vpn.enabled, false) ? 1 : 0
#  description            = "${var.vpc.name} client VPN endpoint"
#  dns_servers            = var.client_vpn.dns_servers
#  server_certificate_arn = var.client_vpn.certificate.acm.server.arn
#  vpc_id                 = aws_vpc.this.id
#  client_cidr_block      = var.client_vpn.client_cidr_block
#  split_tunnel           = var.client_vpn.split_tunnel
#  security_group_ids     = [aws_security_group.private-data.id, aws_security_group.private-logic.id, aws_security_group.public.id, aws_default_security_group.default.id]
#  authentication_options {
#    type                       = "certificate-authentication"
#    root_certificate_chain_arn = var.client_vpn.certificate.acm.client.arn
#  }
#
#  connection_log_options {
#    enabled              = try(var.client_vpn.connection_log_options.enabled, false)
#    cloudwatch_log_group = try(var.client_vpn.connection_log_options.enabled, false) ? aws_cloudwatch_log_group.client_vpn[0].name : null
#    # cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
#  }
#
#  tags = {
#    "Name" = "Client VPN ${var.vpc.name}"
#  }
#}

#resource "aws_ec2_client_vpn_network_association" "association" {
#  for_each               = try(var.client_vpn.enabled, false) && length(try(var.client_vpn.associations, {})) > 0 ? var.client_vpn.associations : {}
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint[0].id
#  subnet_id              = local.all_subnet[each.key].id
#}

# resource "aws_ec2_client_vpn_network_association" "public_association" {
#   for_each                  = try(var.client_vpn.enabled, false) && length(var.client_vpn.associations.public) > 0 ? var.client_vpn.associations.public : {}
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint[0].id
#   subnet_id              = aws_subnet.public[each.key]
# }

# resource "aws_ec2_client_vpn_network_association" "private_association" {
#   for_each                  = try(var.client_vpn.enabled, false) && length(var.client_vpn.associations.private) > 0 ? var.client_vpn.associations.private : {}
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint[0].id
#   subnet_id              = aws_subnet.private[each.key]
# }
#resource "aws_ec2_client_vpn_authorization_rule" "authorization_rule" {
#  for_each               = try(var.client_vpn.enabled, false) && length(try(var.client_vpn.authorization_rules, {})) > 0 ? var.client_vpn.authorization_rules : {}
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint[0].id
#  target_network_cidr    = each.key
#  authorize_all_groups   = true
#}
#
#resource "aws_ec2_client_vpn_route" "route" {
#  for_each               = try(var.client_vpn.enabled, false) && length(try(var.client_vpn.routes, {})) > 0 ? var.client_vpn.routes : {}
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint[0].id
#  destination_cidr_block = each.value.destination_cidr_block
#  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.association[each.value.subnet_id].subnet_id
#}