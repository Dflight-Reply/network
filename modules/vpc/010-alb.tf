resource "aws_lb" "dflight-alb" {
  name               = "dflight-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  tags = local.alb_tags
}

resource "aws_lb_listener" "dflight-listener" {
  load_balancer_arn = aws_lb.dflight-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dflight-tg-eks.arn
  }

  depends_on = [aws_lb_target_group.dflight-tg-eks]
  tags       = local.alb_tags
}

resource "aws_lb_target_group" "dflight-tg-eks" {
  name        = "dflight-tg-eks"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    protocol            = "HTTP"
    port                = "traffic-port"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.alb_tags
}

#resource "aws_security_group_rule" "alb_to_private_logic" {
#  type                     = "egress"
#  from_port                = 8000
#  to_port                  = 8000
#  protocol                 = "tcp"
#  source_security_group_id = aws_security_group.private-logic.id 
#  security_group_id        = aws_security_group.public.id
#}
