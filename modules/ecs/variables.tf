variable "region" {
  type        = string
  description = "Enviroment region"
  default     = "us-east-1"
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

variable "enable_ecs" {
  type        = bool
  description = "wheather to enable ECS or not"
  default     = false
}
