resource "aws_iam_role" "ecs_task_role" {
  count = var.enable_ecs ? 1 : 0
  name  = "ecs_task_sns_role_${var.region}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "ecs_sns_policy" {
  count = var.enable_ecs ? 1 : 0
  name  = "ecs_sns_publish_${var.region}"
  role  = aws_iam_role.ecs_task_role[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sns:Publish"
      Resource = var.sns_topic_arn
    }]
  })
}

# The Role the ECS Service uses to pull images and push logs
resource "aws_iam_role" "ecs_execution_role" {
  count = var.enable_ecs ? 1 : 0
  name  = "ecs_execution_role_${var.region}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_standard" {
  count      = var.enable_ecs ? 1 : 0
  role       = aws_iam_role.ecs_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
