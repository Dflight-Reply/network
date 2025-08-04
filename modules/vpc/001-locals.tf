locals {
  all_subnet = merge(aws_subnet.public, aws_subnet.private-logic, aws_subnet.private-data)

  # Common tags for all resources in this module
  common_tags = var.tags.default

  # ALB specific tags
  alb_tags = merge(local.common_tags, {
    Service       = "elbv2"
    Component     = "application-load-balancer"
    Purpose       = "traffic-distribution"
    Scheme        = "internet-facing"
    IPAddressType = "ipv4"
  })

  # WAF specific tags
  waf_tags = merge(local.common_tags, {
    Service   = "wafv2"
    Component = "web-application-firewall"
    Purpose   = "security-protection"
    Scope     = "regional"
  })
}
