#ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      #Added 1d to test 
      #"ssm:DescribeParameters"
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#Added to enable LB connectivity
resource "aws_iam_role_policy" "ecs-role-policy" {
  name = "ecs-service"
  role = aws_iam_role.ecs_task_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress",
          "s3:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



##Added following statement to enable logging
#statement {
#  sid    = "logActions"
#  effect = "Allow"
#  actions = [
#    "logs:CreateLogStream",
#    "logs:PutLogEvents",
#    "ecr:BatchCheckLayerAvailability",
#    "ecr:GetDownloadUrlForLayer",
#    "ecr:BatchGetImage"
#  ]

#  principals {
#    type = "Service"
#    identifiers = [
#      "streams.metrics.cloudwatch.amazonaws.com",
#      "ecs-tasks.amazonaws.com",
#      "ecs.amazonaws.com",
#      "ecs.application-autoscaling.amazonaws.com",
#      "application-autoscaling.amazonaws.com",
#      "autoscaling.amazonaws.com",
#      "appstream.application-autoscaling.amazonaws.com",
#      "elasticloadbalancing.amazonaws.com"
#    ]
#  }
#}
#}

#ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "myEcsPolicyRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

#ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#### AmazonECSTaskExecutionRolePolicy
#            "Effect": "Allow",
#            "Action": [
#                "ecr:GetAuthorizationToken",
#                "ecr:BatchCheckLayerAvailability",
#                "ecr:GetDownloadUrlForLayer",
#                "ecr:BatchGetImage",
#                "logs:CreateLogStream",
#                "logs:PutLogEvents"
#            ],
#            "Resource": "*"


#Fixing error "aws_ecs_service.rearc-quest-app-service rrequires a service linked role"
#resource "aws_iam_service_linked_role" "ecs" {
#  aws_service_name = "ecs.amazonaws.com"
#}