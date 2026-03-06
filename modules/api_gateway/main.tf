resource "aws_api_gateway_rest_api" "main" {
  count = length(var.api_gateway_definitions) > 0 ? 1 : 0
  name  = "${var.api_gateway_prefix}-${var.env}-${var.region}"
}

resource "aws_api_gateway_authorizer" "cognito" {
  count         = length(var.api_gateway_definitions) > 0 ? 1 : 0
  name          = "cognito-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.main[0].id
  provider_arns = [var.cognito_user_pool_arn]
}

resource "aws_api_gateway_resource" "route" {
  for_each    = var.api_gateway_definitions
  rest_api_id = aws_api_gateway_rest_api.main[0].id
  parent_id   = aws_api_gateway_rest_api.main[0].root_resource_id
  path_part   = each.value.path
}

# 4. Securing the Route
resource "aws_api_gateway_method" "gateway_method" {
  for_each      = var.api_gateway_definitions
  rest_api_id   = aws_api_gateway_rest_api.main[0].id
  resource_id   = aws_api_gateway_resource.route[each.key].id
  http_method   = each.value.http_method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito[0].id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each = var.api_gateway_definitions

  rest_api_id = aws_api_gateway_rest_api.main[0].id
  resource_id = aws_api_gateway_resource.route[each.key].id
  http_method = aws_api_gateway_method.gateway_method[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arns[each.key]
  # uri                     = aws_lambda_function.lambda_function[each.key].invoke_arn
}

resource "aws_api_gateway_deployment" "main" {
  count       = length(var.api_gateway_definitions) > 0 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.main[0].id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.route,
      aws_api_gateway_method.gateway_method,
      aws_api_gateway_integration.lambda_integration,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  count         = length(var.api_gateway_definitions) > 0 ? 1 : 0
  deployment_id = aws_api_gateway_deployment.main[0].id
  rest_api_id   = aws_api_gateway_rest_api.main[0].id
  stage_name    = "prod"
}
