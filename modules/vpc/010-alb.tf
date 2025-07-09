# resource "aws_lb" "dflight-alb" {
#   name               = "dflight-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.public.id]
#   subnets            = [for subnet in aws_subnet.public : subnet.id]
# }

# resource "aws_lb_listener" "dflight-listener" {
#   load_balancer_arn = aws_lb.dflight-alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dflight-tg-eks.arn
#   }
# }

# resource "aws_lb_target_group" "dflight-tg-eks" {
#   name     = "dflight-tg-eks"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.this.id
#   target_type = "ip"
#   health_check {
#     path                = "/health"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 3
#   }
# }