#Set up CloudWatch group and log stream and retain logs for 1 days
resource "aws_cloudwatch_log_group" "rearcQuestApp-log-group" {
  name              = "/ecs/rearc-quest-app"
  retention_in_days = 1

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "rearcQuestApp-log-stream" {
  name           = "rearcQuestApp-log-stream"
  log_group_name = aws_cloudwatch_log_group.rearcQuestApp-log-group.name
}