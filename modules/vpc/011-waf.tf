# DFlight WAF v2 Web ACL with AWS Managed Rules
resource "aws_wafv2_web_acl" "dflight_waf" {
  name  = "dflight-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # AWS Managed Rules - Common Rule Set (Baseline Protection)
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rules - Known Bad Inputs Rule Set
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Rate-Based Rule (DoS Protection Lite)
  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "DFlightWAF"
    sampled_requests_enabled   = true
  }

  tags = local.waf_tags
}

# WAF Association with ALB is managed by EKS project
# The EKS project will associate this WAF with the ALB via Kubernetes Ingress annotations
# Example: alb.ingress.kubernetes.io/wafv2-acl-arn: <waf_web_acl_arn>

# resource "aws_wafv2_web_acl_association" "dflight_waf_alb_association" {
#   resource_arn = aws_lb.dflight-alb.arn
#   web_acl_arn  = aws_wafv2_web_acl.dflight_waf.arn
#   depends_on = [
#     aws_lb.dflight-alb,
#     aws_wafv2_web_acl.dflight_waf
#   ]
# }
