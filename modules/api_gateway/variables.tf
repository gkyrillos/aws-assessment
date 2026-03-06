variable "api_gateway_definitions" {
  type = map(object({
    path             = string
    http_method      = string
    lambda_code_file = string
  }))
  description = "api gateway definitions"
  default     = {}
}

variable "api_gateway_prefix" {
  type        = string
  description = "Name prefix for the api gateway name"
  default     = "aws-assessment"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Enviroment region"
  default     = "us-east-1"
}

variable "cognito_user_pool_arn" {
  type        = string
  description = "Cognito user pool arn"
  default     = ""
}

variable "lambda_invoke_arns" {
  type        = map(string)
  description = "invoke arns output from lambda module"
  default     = {}
}
