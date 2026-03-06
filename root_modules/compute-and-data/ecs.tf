locals {
  enable_ecs = var.enable_ecs && anytrue([for definition in local.service_definitions : definition.create_ecs])
}

module "ecs" {
  source = "../../modules/ecs"
  count  = local.enable_ecs ? 1 : 0

  region           = var.region
  enable_ecs       = local.enable_ecs
  sns_topic_arn    = var.sns_topic_arn
  sns_topic_region = var.sns_topic_region
}
