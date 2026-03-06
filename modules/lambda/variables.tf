variable "region" {
  type        = string
  description = "Enviroment region"
  default     = "us-east-1"
}

variable "lambda_definitions" {
  type = map(object({
    lambda_code_file = string
    lambda_iam_policy = map(object({
      action    = set(string),
      resources = set(string)
    }))
    lambda_environment_vars = map(string)
  }))
  description = "lambda definitions"
  default     = {}
}

variable "api_execution_arn" {
  type        = string
  description = "api gateway api_execution_arn output"
  default     = ""
}

variable "lambda_archive_data" {
  description = "Map of archive_file data objects"
  type        = any
}

variable "ecs_security_group_id" {
  type        = any
  description = "pass output from vpc module"
}
variable "public_subnet_id" {
  type        = any
  description = "pass output from vpc module"
}
