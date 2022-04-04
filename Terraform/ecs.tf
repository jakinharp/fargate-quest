resource "aws_ecs_cluster" "rearc-quest-ecs-cl" {
  name = "rearc-quest-ecs-cluster"
}

#data "template_file" "rearcQuestApp" {
#  template = file("./templates/image/image.json")

#  vars = {
#    app_image      = var.app-image
#    app_port       = var.app-port
#    fargate_cpu    = var.fargate-cpu
#    fargate_memory = var.fargate-memory
#    aws_region     = var.region-main
#  }
#}

resource "aws_ecs_task_definition" "rearc-quest-ecs-task-def" {
  family                   = "rearc-quest-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate-cpu
  memory                   = var.fargate-memory
  #container_definitions    = data.template_file.rearcQuestApp.rendered
  container_definitions = jsonencode([
    {
      "name" : "${var.app-name}",
      "image" : "${var.app-image}",
      "cpu" : "${var.fargate-cpu}",
      "memory" : "${var.fargate-memory}",
      "networkMode" : "awsvpc",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/rearcQuestApp",
          "awslogs-region" : "${var.region-main}",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : "${var.app-port}",
          "hostPort" : "${var.app-port}"
        }
      ],
      "environment" : [
        { "name" : "SECRET_WORD", "value" : "TwelveFactor" }
      ]
    }
  ])

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

resource "aws_ecs_service" "rearc-quest-app-service" {
  name                              = "rearc-quest-app-service"
  cluster                           = aws_ecs_cluster.rearc-quest-ecs-cl.id
  task_definition                   = aws_ecs_task_definition.rearc-quest-ecs-task-def.arn
  desired_count                     = var.app-count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 200

  network_configuration {
    security_groups  = [aws_security_group.ecs-sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.rearcQuestApp-tg.arn
    container_name   = var.app-name
    container_port   = var.app-port
  }

  depends_on = [aws_alb_listener.rearcQuestApp, aws_iam_role_policy_attachment.ecs_task_execution_role]
}