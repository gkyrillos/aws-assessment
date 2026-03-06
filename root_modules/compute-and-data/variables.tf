variable "region" {
  type        = string
  description = "Enviroment region"
}

variable "enable_lambda" {
  type        = bool
  description = "wheather to enable lambda or not"
  default     = false
}

variable "enable_api_gateway" {
  type        = bool
  description = "Wheather to enable api gateway or not"
  default     = false
}

variable "enable_dynamodb" {
  type        = bool
  description = "Wheather to enable dynamodb or not"
  default     = false
}

variable "enable_ecs" {
  type        = bool
  description = "wheather to enable ECS or not"
  default     = false
}

variable "sns_topic_arn" {
  type        = string
  description = "the sns topic arn"
  default     = "arn:aws:sns:us-east-1:566866004670:myTestTopic"
}

variable "sns_topic_region" {
  type        = string
  description = "sns topic region"
  default     = "us-east-1"
}
