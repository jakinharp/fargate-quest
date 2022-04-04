#ALB Security Group
resource "aws_security_group" "alb-sg" {
  name        = "rearc-quest-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    protocol = "tcp"
    #from_port   = var.app-port
    #to_port     = var.app-port
    ##Replaced 2u/2d trying to open 80 and map to 3000
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs-sg" {
  name        = "rearc-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.app-port
    to_port         = var.app-port
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
