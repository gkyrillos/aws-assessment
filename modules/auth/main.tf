resource "aws_cognito_user_pool" "pool" {
  count = var.enable_auth ? 1 : 0
  name  = "${var.user_pool_prefix}-${var.env}-${var.region}"

  deletion_protection = var.env == "prod" ? "ACTIVE" : "INACTIVE"


  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  mfa_configuration = var.mfa_enabled

  dynamic "software_token_mfa_configuration" {
    for_each = var.mfa_enabled == "ON" ? [1] : []
    content {
      enabled = true
    }
  }

  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }

  lifecycle {
    ignore_changes = [schema]
  }
}

resource "aws_cognito_user_pool_client" "client" {
  count = var.enable_auth ? 1 : 0
  name  = "${var.user_pool_prefix}-client-${var.env}-${var.region}"

  user_pool_id = aws_cognito_user_pool.pool[count.index].id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "random_password" "user_password" {
  for_each = var.enable_auth && length(var.users) > 0 ? var.users : {}

  length      = 12
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1

  special = true
}

resource "aws_ssm_parameter" "user_password" {
  for_each = var.enable_auth && length(var.users) > 0 ? var.users : {}

  name  = "/cognito/${each.key}/password"
  type  = "SecureString"
  value = random_password.user_password[each.key].result

  overwrite = true
}

resource "aws_cognito_user" "user" {
  for_each = var.enable_auth && length(var.users) > 0 ? var.users : {}

  user_pool_id = aws_cognito_user_pool.pool[0].id
  username     = each.value.username
  password     = random_password.user_password[each.key].result

  attributes = {
    email          = each.value.email
    email_verified = "true"
  }
  message_action = "SUPPRESS"
}
