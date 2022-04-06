#Set up CloudWatch group and log stream and retain logs for 1 days
resource "aws_cloudwatch_log_group" "rearcQuestApp-log-group" {
  name              = "/ecs/rearcQuestApp"
  retention_in_days = 30

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "rearcQuestApp-log-stream" {
  name           = "rearcQuestApp-log-stream"
  log_group_name = aws_cloudwatch_log_group.rearcQuestApp-log-group.name
}