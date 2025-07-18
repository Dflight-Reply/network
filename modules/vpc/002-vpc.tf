resource "aws_vpc" "this" {
  cidr_block                           = var.vpc.cidr_block
  enable_dns_support                   = var.vpc.enable_dns_support
  enable_dns_hostnames                 = var.vpc.enable_dns_hostnames
  enable_network_address_usage_metrics = var.vpc.enable_network_address_usage_metrics

  tags = {
    "Name" : var.vpc.name
  }
}

# resource "aws_cloudwatch_log_group" "vpcflow" {
#   name = "vpc/${var.vpc.name}/flow"
# }

# data "aws_iam_policy_document" "trust_rel_flow" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["vpc-flow-logs.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "flow" {
#   name               = "vpc-flow-logs-role"
#   assume_role_policy = data.aws_iam_policy_document.trust_rel_flow.json
# }



# data "aws_iam_policy_document" "flow" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "flow" {
#   name   = "vpc-flow-logs-policy"
#   role   = aws_iam_role.flow.id
#   policy = data.aws_iam_policy_document.flow.json
# }

# resource "aws_flow_log" "this" {
#   iam_role_arn    = aws_iam_role.flow.arn
#   log_destination = aws_cloudwatch_log_group.vpcflow.arn
#   traffic_type    = "REJECT"
#   vpc_id          = aws_vpc.this.id
# }