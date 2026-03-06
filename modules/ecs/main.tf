resource "aws_ecs_cluster" "main" {
  name = "aws-assessment-${var.region}"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/sns-publisher"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "sns_task" {
  family                   = "${var.region}-sns-publisher"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role[0].arn
  task_role_arn            = aws_iam_role.ecs_task_role[0].arn

  container_definitions = jsonencode([{
    name  = "sns-builder"
    image = "amazon/aws-cli:latest"

    # Using entryPoint + command ensures the shell parses the JSON correctly
    entryPoint = ["sh", "-c"]
    command = [
      "aws sns publish --region ${var.sns_topic_region} --topic-arn ${var.sns_topic_arn} --message '{\"email\":\"kyrillosgr@live.com\",\"source\":\"ECS\",\"region\":\"${var.region}\",\"repo\":\"https://github.com/gkyrillos/aws-assessment\"}'"
    ]
    environment = [
      {
        name  = "AWS_REGION"
        value = var.region
      },
      {
        name  = "SNS_TOPIC_REGION"
        value = var.sns_topic_region
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}
