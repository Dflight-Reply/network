# resource "aws_wafv2_web_acl" "name" {
#   scope = "REGIONAL"
#   name  = "demo-dflight-waf"
#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }
#   default_action {
#     allow {} #block
#   }
# }