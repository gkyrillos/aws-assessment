data "aws_cognito_user_pools" "user_pools" {
  provider = aws.us_east_1
  name     = "aws-assessment-prod-us-east-1"
}

data "aws_cognito_user_pool" "user_pool" {
  provider     = aws.us_east_1
  count        = length(data.aws_cognito_user_pools.user_pools) > 0 ? 1 : 0
  user_pool_id = tolist(data.aws_cognito_user_pools.user_pools.ids)[0]
}

data "aws_caller_identity" "current" {}

locals {
  api_gateway_definitions = {
    for k, v in local.service_definitions : k => {
      path             = v.path
      http_method      = v.http_method
      lambda_code_file = v.lambda_code_file
    }
  }
  enable_api_gateway = var.enable_api_gateway && length(local.api_gateway_definitions) > 0
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  count  = local.enable_api_gateway ? 1 : 0

  region                  = var.region
  env                     = "prod"
  api_gateway_definitions = local.api_gateway_definitions
  cognito_user_pool_arn   = try(data.aws_cognito_user_pool.user_pool[0].arn, null)
  lambda_invoke_arns      = module.lambda[0].lambda_invoke_arns
}
