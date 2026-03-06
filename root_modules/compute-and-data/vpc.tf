locals {
  enable_vpc = anytrue([for definition in local.service_definitions : definition.create_ecs])
}

module "vpc" {
  source = "../../modules/vpc"
  count  = local.enable_vpc ? 1 : 0
  region = var.region
}
