resource "aws_lambda_function" "lambda_function" {
  for_each = var.lambda_definitions

  filename         = var.lambda_archive_data[each.key].output_path
  function_name    = "${each.key}_${var.region}_lambda"
  role             = aws_iam_role.lambda_assume_role[each.key].arn
  handler          = "lambda_${each.key}.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = var.lambda_archive_data[each.key].output_base64sha256

  environment {
    variables = merge(
      each.value.lambda_environment_vars,
      each.key == "dispatch" ? {
        SECURITY_GROUP_ID = var.ecs_security_group_id,
        SUBNET_ID         = var.public_subnet_id
      } : {}
    )
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each = var.lambda_definitions

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}
