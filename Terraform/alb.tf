#ALB and target group and ALB HTTP listener
resource "aws_alb" "alb" {
  name            = "rearcQuestApp-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_alb_target_group" "rearcQuestApp-tg" {
  # name= "rearcQuestApp-tg"
  name_prefix = "RQA-TG"
  #port = Port on which instances receive traffic
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main-vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 90
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health-check-path
    interval            = 180
    port                = var.app-port
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name,
    ]
  }
}