resource "aws_iam_role" "lambda_assume_role" {
  for_each = var.lambda_definitions

  name = "${each.key}_${var.region}_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "policy" {
  for_each = var.lambda_definitions

  name = "${each.key}_${var.region}_lambda_policy"
  role = aws_iam_role.lambda_assume_role[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      for key, policy in each.value.lambda_iam_policy : {
        Effect   = "Allow"
        Action   = policy.action
        Resource = policy.resources
      }
      ],
      [
        {
          Effect   = "Allow"
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Resource = ["arn:aws:logs:*:*:*"]
        }
      ]
    )
  })
}
