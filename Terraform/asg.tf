resource "aws_appautoscaling_target" "rearcQuest-ecs-target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.rearc-quest-ecs-cl.name}/${aws_ecs_service.rearc-quest-app-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.rearc-quest-ecs-cl.name}/${aws_ecs_service.rearc-quest-app-service.name}"
  scalable_dimension = aws_appautoscaling_target.rearcQuest-ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.rearcQuest-ecs-target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}