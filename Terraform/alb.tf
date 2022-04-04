#ALB and target group and ALB HTTP listener
resource "aws_alb" "alb" {
  name = "rearcQuestApp-load-balancer"
  #  subnets         = ["${aws_subnet.public-subnet.id}"]
  #-- Added line when adding count function to subnets
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb-sg.id]
}

resource "aws_alb_target_group" "rearcQuestApp-tg" {
  name = "rearcQuestApp-tg"
  #  port        = 80
  port        = 3000
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
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "rearcQuestApp" {
  load_balancer_arn = aws_alb.alb.id
  #  port              = var.app-port
  #Testing lb port on 3000 instead of 80
  port     = 3000
  protocol = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.rearcQuestApp-tg.arn
  }
}