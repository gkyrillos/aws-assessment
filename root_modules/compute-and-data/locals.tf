# variable "service_definitions" {
#   type = map(object({
#     path             = string
#     http_method      = string
#     lambda_code_file = string
#     create_ecs       = bool
#     dynamodb_tables  = set(string)
#     lambda_iam_policy = map(object({
#       action    = set(string),
#       resources = set(string)
#     }))
#     lambda_environment_vars = map(string)
#   }))
#   description = "Service definitions, api gateway routes, lambdas, iam for lambdas etc"
#   default     = {}
# }

locals {
  service_definitions = {
    greet = {
      path             = "greet",
      http_method      = "POST",
      lambda_code_file = "lambda_greet.py",
      create_ecs       = false,
      lambda_iam_policy = {
        dynamodb = {
          action = ["dynamodb:PutItem"]
          resources = [
            "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/GreetingLogs-${var.region}-dynamo-table"
          ]
        },
        sns = {
          action = ["sns:Publish"],
          resources = [
            "arn:aws:sns:us-east-1:566866004670:myTestTopic"
          ]
        }
      },
      lambda_environment_vars = {
        REGION       = var.region
        TABLE_NAME   = "GreetingLogs-${var.region}-dynamo-table"
        TOPIC_ARN    = var.sns_topic_arn
        TOPIC_REGION = var.sns_topic_region
      }
    },
    dispatch = {
      path             = "dispatch",
      http_method      = "POST",
      lambda_code_file = "lambda_dispatch.py",
      create_ecs       = true,
      lambda_iam_policy = {
        sns = {
          action = ["sns:Publish"],
          resources = [
            "arn:aws:sns:us-east-1:566866004670:myTestTopic"
          ]
        },
        run_task = {
          action = ["ecs:RunTask"]
          resources = [
            "arn:aws:ecs:${var.region}:566866004670:task-definition/${var.region}-sns-publisher:*"
          ]
        },
        pass_role = {
          action = ["iam:PassRole"]
          resources = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecs_task_sns_role_${var.region}",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecs_execution_role_${var.region}"
          ]
        }
      },
      lambda_environment_vars = {
        REGION              = var.region
        TABLE_NAME          = "GreetingLogs-${var.region}-dynamo-table"
        TOPIC_ARN           = var.sns_topic_arn
        TOPIC_REGION        = var.sns_topic_region
        CLUSTER_NAME        = "aws-assessment-${var.region}"
        TASK_DEFINITION_ARN = "arn:aws:ecs:${var.region}:566866004670:task-definition/${var.region}-sns-publisher"
        # SUBNET_ID           = "aws-assessment-PublicSubnet-${var.region}"
        # SECURITY_GROUP_ID   = module.vpc[0].ecs_security_group_id
      }
    }
  }

  dynamodb_tables = ["GreetingLogs"]
}
