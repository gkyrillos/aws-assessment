locals {
  enable_dynamodb = var.enable_dynamodb && length(local.dynamodb_tables) > 0
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  count  = local.enable_dynamodb ? 1 : 0

  region          = var.region
  dynamodb_tables = local.dynamodb_tables
}
