data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

data "aws_ec2_managed_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.id}.s3"
}

data "aws_ec2_managed_prefix_list" "dynamodb" {
  name = "com.amazonaws.${data.aws_region.current.id}.dynamodb"
}

# data "aws_acm_certificate" "client_vpn_server" {
#   count  = try(var.client_vpn.enabled, false) ? 1 : 0
#   domain = var.client_vpn.certificate.acm.server.arn
# }

# data "aws_acm_certificate" "client_vpn_client" {
#   count  = try(var.client_vpn.enabled, false) ? 1 : 0
#   domain = var.client_vpn.certificate.acm.client.arn
# }