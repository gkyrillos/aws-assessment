# Instructions

## Local tfstates:

The github pipeline uses a pre-existing S3 bucket for storing the tfstates.

If you need to run terraform and have the tfstate stored locally, please uncomment the contents of the following 2 files:
* root_modules/auth/backend_override.tf
* root_modules/compute-and-data/backend_override.tf

Log into your AWS SSO and make sure the profile has sufficient permissions, eg. `AdministratorAccess`, eg:

```
aws sso login --profile <your-profile-name>
```

Export the name of your profile into env variable AWS_PROFILE:

```
export AWS_PROFILE=<your-profile-name>
```

### Authentication root module

The code is split into two root modules.
`auth` builds No. (1) - Authentication part.
In order to build the first part:

Change directory:

```
cd root_modules/auth/
```

Run terraform init:

```
terraform init -reconfigure
```

Run terraform plan:

```
terraform plan -out=tfplan
```

The plan you should get is:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.auth.aws_cognito_user.user["gkyrillos"] will be created
  + resource "aws_cognito_user" "user" {
      + attributes            = {
          + "email"          = "kyrillosgr@live.com"
          + "email_verified" = "true"
        }
      + creation_date         = (known after apply)
      + enabled               = true
      + id                    = (known after apply)
      + last_modified_date    = (known after apply)
      + message_action        = "SUPPRESS"
      + mfa_setting_list      = (known after apply)
      + password              = (sensitive value)
      + preferred_mfa_setting = (known after apply)
      + region                = "us-east-1"
      + status                = (known after apply)
      + sub                   = (known after apply)
      + user_pool_id          = (known after apply)
      + username              = "gkyrillos"
    }

  # module.auth.aws_cognito_user_pool.pool[0] will be created
  + resource "aws_cognito_user_pool" "pool" {
      + alias_attributes           = [
          + "email",
        ]
      + arn                        = (known after apply)
      + auto_verified_attributes   = [
          + "email",
        ]
      + creation_date              = (known after apply)
      + custom_domain              = (known after apply)
      + deletion_protection        = "ACTIVE"
      + domain                     = (known after apply)
      + email_verification_message = (known after apply)
      + email_verification_subject = (known after apply)
      + endpoint                   = (known after apply)
      + estimated_number_of_users  = (known after apply)
      + id                         = (known after apply)
      + last_modified_date         = (known after apply)
      + mfa_configuration          = "OFF"
      + name                       = "aws-assessment-prod-us-east-1"
      + region                     = "us-east-1"
      + sms_verification_message   = (known after apply)
      + tags_all                   = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "auth"
        }
      + user_pool_tier             = (known after apply)

      + account_recovery_setting {
          + recovery_mechanism {
              + name     = "verified_email"
              + priority = 1
            }
        }

      + admin_create_user_config (known after apply)

      + password_policy {
          + minimum_length                   = 12
          + require_lowercase                = true
          + require_numbers                  = true
          + require_symbols                  = true
          + require_uppercase                = true
          + temporary_password_validity_days = 7
        }

      + schema {
          + attribute_data_type = "String"
          + mutable             = true
          + name                = "email"
          + required            = true

          + string_attribute_constraints {
              + max_length = "2048"
              + min_length = "5"
            }
        }

      + sign_in_policy (known after apply)

      + sms_configuration (known after apply)

      + username_configuration (known after apply)

      + verification_message_template (known after apply)
    }

  # module.auth.aws_cognito_user_pool_client.client[0] will be created
  + resource "aws_cognito_user_pool_client" "client" {
      + access_token_validity                         = (known after apply)
      + allowed_oauth_flows                           = (known after apply)
      + allowed_oauth_flows_user_pool_client          = (known after apply)
      + allowed_oauth_scopes                          = (known after apply)
      + auth_session_validity                         = (known after apply)
      + callback_urls                                 = (known after apply)
      + client_secret                                 = (sensitive value)
      + default_redirect_uri                          = (known after apply)
      + enable_propagate_additional_user_context_data = (known after apply)
      + enable_token_revocation                       = (known after apply)
      + explicit_auth_flows                           = [
          + "ALLOW_REFRESH_TOKEN_AUTH",
          + "ALLOW_USER_PASSWORD_AUTH",
        ]
      + generate_secret                               = false
      + id                                            = (known after apply)
      + id_token_validity                             = (known after apply)
      + logout_urls                                   = (known after apply)
      + name                                          = "aws-assessment-client-prod-us-east-1"
      + prevent_user_existence_errors                 = (known after apply)
      + read_attributes                               = (known after apply)
      + refresh_token_validity                        = (known after apply)
      + region                                        = "us-east-1"
      + supported_identity_providers                  = (known after apply)
      + user_pool_id                                  = (known after apply)
      + write_attributes                              = (known after apply)
    }

  # module.auth.aws_ssm_parameter.user_password["gkyrillos"] will be created
  + resource "aws_ssm_parameter" "user_password" {
      + arn            = (known after apply)
      + data_type      = (known after apply)
      + has_value_wo   = (known after apply)
      + id             = (known after apply)
      + insecure_value = (known after apply)
      + key_id         = (known after apply)
      + name           = "/cognito/gkyrillos/password"
      + overwrite      = true
      + region         = "us-east-1"
      + tags_all       = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "auth"
        }
      + tier           = (known after apply)
      + type           = "SecureString"
      + value          = (sensitive value)
      + value_wo       = (write-only attribute)
      + version        = (known after apply)
    }

  # module.auth.random_password.user_password["gkyrillos"] will be created
  + resource "random_password" "user_password" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 12
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 1
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = true
      + upper       = true
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + user_pool_client_id = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

To apply, run:

```
terraform apply tfplan
```
After successfull apply, you should get something like this:

```
module.auth.random_password.user_password["gkyrillos"]: Creating...
module.auth.random_password.user_password["gkyrillos"]: Creation complete after 0s [id=none]
module.auth.aws_ssm_parameter.user_password["gkyrillos"]: Creating...
module.auth.aws_cognito_user_pool.pool[0]: Creating...
module.auth.aws_ssm_parameter.user_password["gkyrillos"]: Creation complete after 2s [id=/cognito/gkyrillos/password]
module.auth.aws_cognito_user_pool.pool[0]: Creation complete after 3s [id=us-east-1_cdkikk0JP]
module.auth.aws_cognito_user.user["gkyrillos"]: Creating...
module.auth.aws_cognito_user_pool_client.client[0]: Creating...
module.auth.aws_cognito_user_pool_client.client[0]: Creation complete after 0s [id=1cvm6706e14cnmr3b015oa25n2]
module.auth.aws_cognito_user.user["gkyrillos"]: Creation complete after 2s [id=us-east-1_cdkikk0JP/gkyrillos]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

user_pool_client_id = "1cvm6706e14cnmr3b015oa25n2"
```

In order to destroy:

```
terraform destroy
```
### Compute and Data root module

For the second part of the infra (compute and data) we need to apply the same code in two regions. We could use terraform workspaces but I don't like them :)
Change to the correct directory:

```
cd ../compute-and-data
```

Again, terraform init:

```
terraform init -reconfigure -backend-config="path=us-east-1.tfstate"
```

Terraform plan (for us-east-1):

```
terraform plan -var="region=us-east-1" -out=us-east.tfplan
```

You should get something like this:

```
data.aws_cognito_user_pools.user_pools: Reading...
data.aws_caller_identity.current: Reading...
data.aws_caller_identity.current: Read complete after 1s [id=566866004670]
data.archive_file.lambda_zip["greet"]: Reading...
data.archive_file.lambda_zip["dispatch"]: Reading...
data.archive_file.lambda_zip["dispatch"]: Read complete after 0s [id=4d87cd66679e3cfa2c9597089b35c7dea88d5c03]
data.archive_file.lambda_zip["greet"]: Read complete after 0s [id=cb28c10b6688a113b866f270e81c6f06f4ea5315]
data.aws_cognito_user_pools.user_pools: Read complete after 1s [id=aws-assessment-prod-us-east-1]
data.aws_cognito_user_pool.user_pool[0]: Reading...
data.aws_cognito_user_pool.user_pool[0]: Read complete after 0s [id=us-east-1_cdkikk0JP]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.api_gateway[0].aws_api_gateway_authorizer.cognito[0] will be created
  + resource "aws_api_gateway_authorizer" "cognito" {
      + arn                              = (known after apply)
      + authorizer_result_ttl_in_seconds = 300
      + id                               = (known after apply)
      + identity_source                  = "method.request.header.Authorization"
      + name                             = "cognito-auth"
      + provider_arns                    = [
          + "arn:aws:cognito-idp:us-east-1:566866004670:userpool/us-east-1_cdkikk0JP",
        ]
      + region                           = "us-east-1"
      + rest_api_id                      = (known after apply)
      + type                             = "COGNITO_USER_POOLS"
    }

  # module.api_gateway[0].aws_api_gateway_deployment.main[0] will be created
  + resource "aws_api_gateway_deployment" "main" {
      + created_date = (known after apply)
      + id           = (known after apply)
      + region       = "us-east-1"
      + rest_api_id  = (known after apply)
      + triggers     = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_integration.lambda_integration["dispatch"] will be created
  + resource "aws_api_gateway_integration" "lambda_integration" {
      + cache_namespace         = (known after apply)
      + connection_type         = "INTERNET"
      + http_method             = "POST"
      + id                      = (known after apply)
      + integration_http_method = "POST"
      + passthrough_behavior    = (known after apply)
      + region                  = "us-east-1"
      + resource_id             = (known after apply)
      + response_transfer_mode  = (known after apply)
      + rest_api_id             = (known after apply)
      + timeout_milliseconds    = 29000
      + type                    = "AWS_PROXY"
      + uri                     = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_integration.lambda_integration["greet"] will be created
  + resource "aws_api_gateway_integration" "lambda_integration" {
      + cache_namespace         = (known after apply)
      + connection_type         = "INTERNET"
      + http_method             = "POST"
      + id                      = (known after apply)
      + integration_http_method = "POST"
      + passthrough_behavior    = (known after apply)
      + region                  = "us-east-1"
      + resource_id             = (known after apply)
      + response_transfer_mode  = (known after apply)
      + rest_api_id             = (known after apply)
      + timeout_milliseconds    = 29000
      + type                    = "AWS_PROXY"
      + uri                     = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_method.gateway_method["dispatch"] will be created
  + resource "aws_api_gateway_method" "gateway_method" {
      + api_key_required = false
      + authorization    = "COGNITO_USER_POOLS"
      + authorizer_id    = (known after apply)
      + http_method      = "POST"
      + id               = (known after apply)
      + region           = "us-east-1"
      + resource_id      = (known after apply)
      + rest_api_id      = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_method.gateway_method["greet"] will be created
  + resource "aws_api_gateway_method" "gateway_method" {
      + api_key_required = false
      + authorization    = "COGNITO_USER_POOLS"
      + authorizer_id    = (known after apply)
      + http_method      = "POST"
      + id               = (known after apply)
      + region           = "us-east-1"
      + resource_id      = (known after apply)
      + rest_api_id      = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_resource.route["dispatch"] will be created
  + resource "aws_api_gateway_resource" "route" {
      + id          = (known after apply)
      + parent_id   = (known after apply)
      + path        = (known after apply)
      + path_part   = "dispatch"
      + region      = "us-east-1"
      + rest_api_id = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_resource.route["greet"] will be created
  + resource "aws_api_gateway_resource" "route" {
      + id          = (known after apply)
      + parent_id   = (known after apply)
      + path        = (known after apply)
      + path_part   = "greet"
      + region      = "us-east-1"
      + rest_api_id = (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_rest_api.main[0] will be created
  + resource "aws_api_gateway_rest_api" "main" {
      + api_key_source               = (known after apply)
      + arn                          = (known after apply)
      + binary_media_types           = (known after apply)
      + created_date                 = (known after apply)
      + description                  = (known after apply)
      + disable_execute_api_endpoint = (known after apply)
      + execution_arn                = (known after apply)
      + id                           = (known after apply)
      + minimum_compression_size     = (known after apply)
      + name                         = "aws-assessment-prod-us-east-1"
      + policy                       = (known after apply)
      + region                       = "us-east-1"
      + root_resource_id             = (known after apply)
      + tags_all                     = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }

      + endpoint_configuration (known after apply)
    }

  # module.api_gateway[0].aws_api_gateway_stage.prod[0] will be created
  + resource "aws_api_gateway_stage" "prod" {
      + arn           = (known after apply)
      + deployment_id = (known after apply)
      + execution_arn = (known after apply)
      + id            = (known after apply)
      + invoke_url    = (known after apply)
      + region        = "us-east-1"
      + rest_api_id   = (known after apply)
      + stage_name    = "prod"
      + tags_all      = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + web_acl_arn   = (known after apply)
    }

  # module.dynamodb[0].aws_dynamodb_table.dynamodb_tables["GreetingLogs"] will be created
  + resource "aws_dynamodb_table" "dynamodb_tables" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "id"
      + id               = (known after apply)
      + name             = "GreetingLogs-us-east-1-dynamo-table"
      + read_capacity    = (known after apply)
      + region           = "us-east-1"
      + stream_arn       = (known after apply)
      + stream_label     = (known after apply)
      + stream_view_type = (known after apply)
      + tags_all         = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + write_capacity   = (known after apply)

      + attribute {
          + name = "id"
          + type = "S"
        }

      + global_secondary_index (known after apply)

      + global_table_witness (known after apply)

      + point_in_time_recovery (known after apply)

      + server_side_encryption (known after apply)

      + ttl (known after apply)

      + warm_throughput (known after apply)
    }

  # module.ecs[0].aws_cloudwatch_log_group.ecs_logs will be created
  + resource "aws_cloudwatch_log_group" "ecs_logs" {
      + arn                         = (known after apply)
      + deletion_protection_enabled = (known after apply)
      + id                          = (known after apply)
      + log_group_class             = (known after apply)
      + name                        = "/ecs/sns-publisher"
      + name_prefix                 = (known after apply)
      + region                      = "us-east-1"
      + retention_in_days           = 7
      + skip_destroy                = false
      + tags_all                    = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
    }

  # module.ecs[0].aws_ecs_cluster.main will be created
  + resource "aws_ecs_cluster" "main" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + name     = "aws-assessment-us-east-1"
      + region   = "us-east-1"
      + tags_all = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }

      + setting (known after apply)
    }

  # module.ecs[0].aws_ecs_task_definition.sns_task will be created
  + resource "aws_ecs_task_definition" "sns_task" {
      + arn                      = (known after apply)
      + arn_without_revision     = (known after apply)
      + container_definitions    = jsonencode(
            [
              + {
                  + command          = [
                      + "aws sns publish --region us-east-1 --topic-arn arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic --message '{\"email\":\"kyrillosgr@live.com\",\"source\":\"ECS\",\"region\":\"us-east-1\",\"repo\":\"https://github.com/gkyrillos/aws-assessment\"}'",
                    ]
                  + entryPoint       = [
                      + "sh",
                      + "-c",
                    ]
                  + environment      = [
                      + {
                          + name  = "AWS_REGION"
                          + value = "us-east-1"
                        },
                      + {
                          + name  = "SNS_TOPIC_REGION"
                          + value = "us-east-1"
                        },
                    ]
                  + image            = "amazon/aws-cli:latest"
                  + logConfiguration = {
                      + logDriver = "awslogs"
                      + options   = {
                          + awslogs-group         = "/ecs/sns-publisher"
                          + awslogs-region        = "us-east-1"
                          + awslogs-stream-prefix = "ecs"
                        }
                    }
                  + name             = "sns-builder"
                },
            ]
        )
      + cpu                      = "256"
      + enable_fault_injection   = (known after apply)
      + execution_role_arn       = (known after apply)
      + family                   = "us-east-1-sns-publisher"
      + id                       = (known after apply)
      + memory                   = "512"
      + network_mode             = "awsvpc"
      + region                   = "us-east-1"
      + requires_compatibilities = [
          + "FARGATE",
        ]
      + revision                 = (known after apply)
      + skip_destroy             = false
      + tags_all                 = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + task_role_arn            = (known after apply)
      + track_latest             = false
    }

  # module.ecs[0].aws_iam_role.ecs_execution_role[0] will be created
  + resource "aws_iam_role" "ecs_execution_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ecs-tasks.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ecs_execution_role_us-east-1"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # module.ecs[0].aws_iam_role.ecs_task_role[0] will be created
  + resource "aws_iam_role" "ecs_task_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ecs-tasks.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ecs_task_sns_role_us-east-1"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # module.ecs[0].aws_iam_role_policy.ecs_sns_policy[0] will be created
  + resource "aws_iam_role_policy" "ecs_sns_policy" {
      + id          = (known after apply)
      + name        = "ecs_sns_publish_us-east-1"
      + name_prefix = (known after apply)
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "sns:Publish"
                      + Effect   = "Allow"
                      + Resource = "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role        = (known after apply)
    }

  # module.ecs[0].aws_iam_role_policy_attachment.ecs_execution_standard[0] will be created
  + resource "aws_iam_role_policy_attachment" "ecs_execution_standard" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
      + role       = "ecs_execution_role_us-east-1"
    }

  # module.lambda[0].aws_iam_role.lambda_assume_role["dispatch"] will be created
  + resource "aws_iam_role" "lambda_assume_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "dispatch_us-east-1_lambda_role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # module.lambda[0].aws_iam_role.lambda_assume_role["greet"] will be created
  + resource "aws_iam_role" "lambda_assume_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "greet_us-east-1_lambda_role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # module.lambda[0].aws_iam_role_policy.policy["dispatch"] will be created
  + resource "aws_iam_role_policy" "policy" {
      + id          = (known after apply)
      + name        = "dispatch_us-east-1_lambda_policy"
      + name_prefix = (known after apply)
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "iam:PassRole",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:iam::566866004670:role/ecs_execution_role_us-east-1",
                          + "arn:aws:iam::566866004670:role/ecs_task_sns_role_us-east-1",
                        ]
                    },
                  + {
                      + Action   = [
                          + "ecs:RunTask",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:ecs:us-east-1:566866004670:task-definition/us-east-1-sns-publisher:*",
                        ]
                    },
                  + {
                      + Action   = [
                          + "sns:Publish",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic",
                        ]
                    },
                  + {
                      + Action   = [
                          + "logs:CreateLogGroup",
                          + "logs:CreateLogStream",
                          + "logs:PutLogEvents",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:logs:*:*:*",
                        ]
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role        = (known after apply)
    }

  # module.lambda[0].aws_iam_role_policy.policy["greet"] will be created
  + resource "aws_iam_role_policy" "policy" {
      + id          = (known after apply)
      + name        = "greet_us-east-1_lambda_policy"
      + name_prefix = (known after apply)
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "dynamodb:PutItem",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:dynamodb:us-east-1:566866004670:table/GreetingLogs-us-east-1-dynamo-table",
                        ]
                    },
                  + {
                      + Action   = [
                          + "sns:Publish",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic",
                        ]
                    },
                  + {
                      + Action   = [
                          + "logs:CreateLogGroup",
                          + "logs:CreateLogStream",
                          + "logs:PutLogEvents",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:logs:*:*:*",
                        ]
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role        = (known after apply)
    }

  # module.lambda[0].aws_lambda_function.lambda_function["dispatch"] will be created
  + resource "aws_lambda_function" "lambda_function" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + code_sha256                    = (known after apply)
      + filename                       = "./src/python/lambda_dispatch.py.zip"
      + function_name                  = "dispatch_us-east-1_lambda"
      + handler                        = "lambda_dispatch.lambda_handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + region                         = "us-east-1"
      + reserved_concurrent_executions = -1
      + response_streaming_invoke_arn  = (known after apply)
      + role                           = (known after apply)
      + runtime                        = "python3.12"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "XSqqc10BE+QQbxgbmrx89jPMkA5NEDTEoFG04eg1+pQ="
      + source_code_size               = (known after apply)
      + tags_all                       = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + timeout                        = 3
      + version                        = (known after apply)

      + environment {
          + variables = (known after apply)
        }

      + ephemeral_storage (known after apply)

      + logging_config (known after apply)

      + tracing_config (known after apply)
    }

  # module.lambda[0].aws_lambda_function.lambda_function["greet"] will be created
  + resource "aws_lambda_function" "lambda_function" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + code_sha256                    = (known after apply)
      + filename                       = "./src/python/lambda_greet.py.zip"
      + function_name                  = "greet_us-east-1_lambda"
      + handler                        = "lambda_greet.lambda_handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + region                         = "us-east-1"
      + reserved_concurrent_executions = -1
      + response_streaming_invoke_arn  = (known after apply)
      + role                           = (known after apply)
      + runtime                        = "python3.12"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "r+cchoIJUQCT6kibVGIuNbk4BvkscdEWzt4li3Bch9E="
      + source_code_size               = (known after apply)
      + tags_all                       = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + timeout                        = 3
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "REGION"       = "us-east-1"
              + "TABLE_NAME"   = "GreetingLogs-us-east-1-dynamo-table"
              + "TOPIC_ARN"    = "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic"
              + "TOPIC_REGION" = "us-east-1"
            }
        }

      + ephemeral_storage (known after apply)

      + logging_config (known after apply)

      + tracing_config (known after apply)
    }

  # module.lambda[0].aws_lambda_permission.apigw_lambda["dispatch"] will be created
  + resource "aws_lambda_permission" "apigw_lambda" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "dispatch_us-east-1_lambda"
      + id                  = (known after apply)
      + principal           = "apigateway.amazonaws.com"
      + region              = "us-east-1"
      + source_arn          = (known after apply)
      + statement_id        = "AllowExecutionFromAPIGateway"
      + statement_id_prefix = (known after apply)
    }

  # module.lambda[0].aws_lambda_permission.apigw_lambda["greet"] will be created
  + resource "aws_lambda_permission" "apigw_lambda" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "greet_us-east-1_lambda"
      + id                  = (known after apply)
      + principal           = "apigateway.amazonaws.com"
      + region              = "us-east-1"
      + source_arn          = (known after apply)
      + statement_id        = "AllowExecutionFromAPIGateway"
      + statement_id_prefix = (known after apply)
    }

  # module.vpc[0].aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + region   = "us-east-1"
      + tags_all = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + vpc_id   = (known after apply)
    }

  # module.vpc[0].aws_route_table.public will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + region           = "us-east-1"
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (11 unchanged attributes hidden)
            },
        ]
      + tags_all         = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + vpc_id           = (known after apply)
    }

  # module.vpc[0].aws_route_table_association.public will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + region         = "us-east-1"
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.vpc[0].aws_security_group.ecs_sg will be created
  + resource "aws_security_group" "ecs_sg" {
      + arn                    = (known after apply)
      + description            = "Allow outbound for ECS tasks"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "ecs-tasks-sg-us-east-1"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags_all               = {
          + "ManagedBy"  = "Terraform"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + vpc_id                 = (known after apply)
    }

  # module.vpc[0].aws_subnet.public will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block                                = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + region                                         = "us-east-1"
      + tags                                           = {
          + "Name" = "aws-assessment-PublicSubnet-us-east-1"
        }
      + tags_all                                       = {
          + "ManagedBy"  = "Terraform"
          + "Name"       = "aws-assessment-PublicSubnet-us-east-1"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.vpc[0].aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + region                               = "us-east-1"
      + tags                                 = {
          + "Name" = "aws-assessment-VPC-us-east-1"
        }
      + tags_all                             = {
          + "ManagedBy"  = "Terraform"
          + "Name"       = "aws-assessment-VPC-us-east-1"
          + "Region"     = "us-east-1"
          + "RootModule" = "compute-and-data"
        }
    }

Plan: 32 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + api_url = (known after apply)
```

Apply:

```
terraform apply "us-east.tfplan"
```

You should get an output like this:

```
module.ecs[0].aws_cloudwatch_log_group.ecs_logs: Creating...
module.lambda[0].aws_iam_role.lambda_assume_role["greet"]: Creating...
module.ecs[0].aws_iam_role.ecs_task_role[0]: Creating...
module.ecs[0].aws_iam_role.ecs_execution_role[0]: Creating...
module.vpc[0].aws_vpc.main: Creating...
module.ecs[0].aws_ecs_cluster.main: Creating...
module.api_gateway[0].aws_api_gateway_rest_api.main[0]: Creating...
module.lambda[0].aws_iam_role.lambda_assume_role["dispatch"]: Creating...
module.dynamodb[0].aws_dynamodb_table.dynamodb_tables["GreetingLogs"]: Creating...
module.ecs[0].aws_cloudwatch_log_group.ecs_logs: Creation complete after 1s [id=/ecs/sns-publisher]
module.lambda[0].aws_iam_role.lambda_assume_role["greet"]: Creation complete after 1s [id=greet_us-east-1_lambda_role]
module.ecs[0].aws_iam_role.ecs_execution_role[0]: Creation complete after 1s [id=ecs_execution_role_us-east-1]
module.ecs[0].aws_iam_role_policy_attachment.ecs_execution_standard[0]: Creating...
module.ecs[0].aws_iam_role.ecs_task_role[0]: Creation complete after 1s [id=ecs_task_sns_role_us-east-1]
module.lambda[0].aws_iam_role.lambda_assume_role["dispatch"]: Creation complete after 1s [id=dispatch_us-east-1_lambda_role]
module.api_gateway[0].aws_api_gateway_rest_api.main[0]: Creation complete after 1s [id=n6ccsa2tj3]
module.api_gateway[0].aws_api_gateway_resource.route["dispatch"]: Creating...
module.api_gateway[0].aws_api_gateway_resource.route["greet"]: Creating...
module.ecs[0].aws_iam_role_policy.ecs_sns_policy[0]: Creating...
module.lambda[0].aws_iam_role_policy.policy["greet"]: Creating...
module.lambda[0].aws_iam_role_policy.policy["dispatch"]: Creating...
module.ecs[0].aws_ecs_task_definition.sns_task: Creating...
module.ecs[0].aws_iam_role_policy_attachment.ecs_execution_standard[0]: Creation complete after 1s [id=ecs_execution_role_us-east-1/arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy]
module.api_gateway[0].aws_api_gateway_authorizer.cognito[0]: Creating...
module.ecs[0].aws_ecs_task_definition.sns_task: Creation complete after 1s [id=us-east-1-sns-publisher]
module.api_gateway[0].aws_api_gateway_resource.route["greet"]: Creation complete after 1s [id=k97s0u]
module.api_gateway[0].aws_api_gateway_resource.route["dispatch"]: Creation complete after 1s [id=kc1qu7]
module.ecs[0].aws_iam_role_policy.ecs_sns_policy[0]: Creation complete after 1s [id=ecs_task_sns_role_us-east-1:ecs_sns_publish_us-east-1]
module.lambda[0].aws_iam_role_policy.policy["greet"]: Creation complete after 1s [id=greet_us-east-1_lambda_role:greet_us-east-1_lambda_policy]
module.lambda[0].aws_iam_role_policy.policy["dispatch"]: Creation complete after 1s [id=dispatch_us-east-1_lambda_role:dispatch_us-east-1_lambda_policy]
module.api_gateway[0].aws_api_gateway_authorizer.cognito[0]: Creation complete after 0s [id=ht9o5w]
module.api_gateway[0].aws_api_gateway_method.gateway_method["greet"]: Creating...
module.api_gateway[0].aws_api_gateway_method.gateway_method["dispatch"]: Creating...
module.api_gateway[0].aws_api_gateway_method.gateway_method["greet"]: Creation complete after 0s [id=agm-n6ccsa2tj3-k97s0u-POST]
module.api_gateway[0].aws_api_gateway_method.gateway_method["dispatch"]: Creation complete after 0s [id=agm-n6ccsa2tj3-kc1qu7-POST]
module.vpc[0].aws_vpc.main: Still creating... [00m10s elapsed]
module.ecs[0].aws_ecs_cluster.main: Still creating... [00m10s elapsed]
module.dynamodb[0].aws_dynamodb_table.dynamodb_tables["GreetingLogs"]: Still creating... [00m10s elapsed]
module.ecs[0].aws_ecs_cluster.main: Creation complete after 12s [id=arn:aws:ecs:us-east-1:566866004670:cluster/aws-assessment-us-east-1]
module.dynamodb[0].aws_dynamodb_table.dynamodb_tables["GreetingLogs"]: Creation complete after 12s [id=GreetingLogs-us-east-1-dynamo-table]
module.vpc[0].aws_vpc.main: Creation complete after 14s [id=vpc-00a4e68f909f263ed]
module.vpc[0].aws_internet_gateway.igw: Creating...
module.vpc[0].aws_subnet.public: Creating...
module.vpc[0].aws_security_group.ecs_sg: Creating...
module.vpc[0].aws_internet_gateway.igw: Creation complete after 1s [id=igw-09de46631bf24adb9]
module.vpc[0].aws_route_table.public: Creating...
module.vpc[0].aws_route_table.public: Creation complete after 2s [id=rtb-099de1ce334d94099]
module.vpc[0].aws_security_group.ecs_sg: Creation complete after 4s [id=sg-031bd9aa53adfc33d]
module.vpc[0].aws_subnet.public: Still creating... [00m10s elapsed]
module.vpc[0].aws_subnet.public: Creation complete after 12s [id=subnet-0bc419dc48c90a13a]
module.vpc[0].aws_route_table_association.public: Creating...
module.lambda[0].aws_lambda_function.lambda_function["greet"]: Creating...
module.lambda[0].aws_lambda_function.lambda_function["dispatch"]: Creating...
module.vpc[0].aws_route_table_association.public: Creation complete after 1s [id=rtbassoc-01c5807bfbdf6f044]
module.lambda[0].aws_lambda_function.lambda_function["greet"]: Creation complete after 7s [id=greet_us-east-1_lambda]
module.lambda[0].aws_lambda_function.lambda_function["dispatch"]: Still creating... [00m10s elapsed]
module.lambda[0].aws_lambda_function.lambda_function["dispatch"]: Creation complete after 14s [id=dispatch_us-east-1_lambda]
module.lambda[0].aws_lambda_permission.apigw_lambda["greet"]: Creating...
module.lambda[0].aws_lambda_permission.apigw_lambda["dispatch"]: Creating...
module.api_gateway[0].aws_api_gateway_integration.lambda_integration["greet"]: Creating...
module.api_gateway[0].aws_api_gateway_integration.lambda_integration["dispatch"]: Creating...
module.lambda[0].aws_lambda_permission.apigw_lambda["greet"]: Creation complete after 0s [id=AllowExecutionFromAPIGateway]
module.lambda[0].aws_lambda_permission.apigw_lambda["dispatch"]: Creation complete after 0s [id=AllowExecutionFromAPIGateway]
module.api_gateway[0].aws_api_gateway_integration.lambda_integration["dispatch"]: Creation complete after 0s [id=agi-n6ccsa2tj3-kc1qu7-POST]
module.api_gateway[0].aws_api_gateway_integration.lambda_integration["greet"]: Creation complete after 0s [id=agi-n6ccsa2tj3-k97s0u-POST]
module.api_gateway[0].aws_api_gateway_deployment.main[0]: Creating...
module.api_gateway[0].aws_api_gateway_deployment.main[0]: Creation complete after 1s [id=e07ipr]
module.api_gateway[0].aws_api_gateway_stage.prod[0]: Creating...
module.api_gateway[0].aws_api_gateway_stage.prod[0]: Creation complete after 0s [id=ags-n6ccsa2tj3-prod]

Apply complete! Resources: 32 added, 0 changed, 0 destroyed.

Outputs:

api_url = "https://n6ccsa2tj3.execute-api.us-east-1.amazonaws.com/prod"
```

Repeat the same process for region eu-west-1

```
terraform init -reconfigure -backend-config="path=eu-west-1.tfstate"
terraform plan -var="region=eu-west-1" -out=eu-west.tfplan
terraform apply "eu-west.tfplan"
```

You should get a similar output as with region us-east-1.

To destroy, issue the following commands:
```
terraform init -reconfigure -backend-config="path=eu-west-1.tfstate"
terraform destroy -var="region=eu-west-1"

and

terraform init -reconfigure -backend-config="path=us-east-1.tfstate"
terraform destroy -var="region=us-east-1"
```

## tfstates in S3

If you have a S3 bucket you can use for keeping the tfstates you don't have to uncomment the backend_override.tf files.
Instead, repeat the process above using the follwing commands:

### Authentication

```
terraform init \
  -reconfigure \
  -backend-config="key=auth.tfstate" \
  -backend-config="region=<region_of_your_bucket>" \
  -backend-config="bucket=<your_bucket_name>"
terraform plan -out=tfplan
terraform apply tfplan
```

To destroy:

```
terraform destroy
```

### Compute and Data
us-east-1:
```
terraform init -reconfigure \
  -backend-config="key=us-east-1.tfstate" \
  -backend-config="region=<region_of_your_bucket>" \
  -backend-config="bucket=<your_bucket_name>" -var="region=us-east-1"
terraform plan -var="region=us-east-1" -out=us-east.tfplan
terraform apply "us-east.tfplan"
```

To destroy:
```
terraform init -reconfigure \
  -backend-config="key=us-east-1.tfstate" \
  -backend-config="region=<region_of_your_bucket>" \
  -backend-config="bucket=<your_bucket_name>" -var="region=us-east-1"
terraform destroy -var="region=us-east-1"
```


eu-west-1:
```
terraform init -reconfigure \
  -backend-config="key=eu-west-1.tfstate" \
  -backend-config="region=<region_of_your_bucket>" \
  -backend-config="bucket=<your_bucket_name>" -var="region=eu-west-1"
terraform plan -var="region=eu-west-1" -out=eu-west.tfplan
terraform apply "eu-west.tfplan"
```

To destroy:

```
terraform init -reconfigure \
  -backend-config="key=eu-west-1.tfstate" \
  -backend-config="region=<region_of_your_bucket>" \
  -backend-config="bucket=<your_bucket_name>" -var="region=eu-west-1"
terraform destroy -var="region=eu-west-1"
```

## Validation script

There are 2 workflows in the repo.
* one to create the infra, which consists of the following jobs:
  * security-scan-and-validation (for checkov and terraform validate)
  * deploy-auth (deploys the cognito auth), and
  * deploy-compute-and-data (runs a matrix for deploying in both regions, eu-west-1 and us-east-1)
* one to destroy the whole infra

The validation script runs automatically when terraform apply succeeds on each region.
A typical output would be:

```
 Trying to get the ssm password for gkyrillos
Password for user gkyrillos retrieved successfully and it took 1188.8ms
Getting the ID token for user gkyrillos
Token for user gkyrillos retrieved successfully and it took 559.2ms
Trying to hit route https://krrezd8p0j.execute-api.eu-west-1.amazonaws.com/prod/greet
I hit https://krrezd8p0j.execute-api.eu-west-1.amazonaws.com/prod/greet successfully and it took 2147.1ms
{"status": "OK", "region": "eu-west-1"}
Trying to hit route https://krrezd8p0j.execute-api.eu-west-1.amazonaws.com/prod/dispatch
I hit https://krrezd8p0j.execute-api.eu-west-1.amazonaws.com/prod/dispatch successfully and it took 2545.6ms
{"message": "ECS Task Dispatched", "taskArn": "arn:aws:ecs:eu-west-1:566866004670:task/aws-assessment-eu-west-1/cf5855f9d4b7413d9ff3393f66ebde54"}
Validation succeeded
```

It acquires a password for the user `gkyrillos`.
It aqcuires a token.
It hits both routes of the Api Gateway, greet and dispatch.
It calculates how much time it took in each step.

In order to run it manually, you need to get the following outputs from your terraform apply step:
`user_pool_client_id`, which is the ClientID of the Cognito user pool, from the authentication root module, eg:

```
user_pool_client_id = "46kceq276j36dqcsejhoit7g0k"
```
and from the compute and data root module, one for each region, the Api-Gateway URL, eg:

```
For us-east-1: api_url = "https://hrpokuqcx9.execute-api.us-east-1.amazonaws.com/prod"
and
For eu-west-1: api_url = "https://krrezd8p0j.execute-api.eu-west-1.amazonaws.com/prod"
```

For each region, run the script:

```
Change directory where the script is: cd scripts/
Create a virtual environment: python -m venv .venv
Install dependencies: pip install boto3 requests
Run script: python validate_deployment.py --client-id <user_pool_client_id> --api-gw-url <api_url>
