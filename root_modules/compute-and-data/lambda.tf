locals {
  lambda_definitions = {
    for k, v in local.service_definitions : k => {
      lambda_code_file        = v.lambda_code_file
      lambda_iam_policy       = v.lambda_iam_policy
      lambda_environment_vars = v.lambda_environment_vars
    }
  }
  enable_lambda = var.enable_lambda && length(local.lambda_definitions) > 0
}

data "archive_file" "lambda_zip" {
  for_each = local.enable_lambda ? local.lambda_definitions : {}

  type        = "zip"
  source_file = "${path.module}/src/python/${each.value.lambda_code_file}"
  output_path = "${path.module}/src/python/${each.value.lambda_code_file}.zip"
}

module "lambda" {
  source = "../../modules/lambda"
  count  = local.enable_lambda ? 1 : 0

  region                = var.region
  lambda_definitions    = local.lambda_definitions
  lambda_archive_data   = data.archive_file.lambda_zip
  api_execution_arn     = module.api_gateway[0].api_execution_arn
  ecs_security_group_id = module.vpc[0].ecs_security_group_id
  public_subnet_id      = module.vpc[0].public_subnet_id
}
