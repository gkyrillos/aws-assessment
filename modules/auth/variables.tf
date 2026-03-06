variable "user_pool_prefix" {
  type        = string
  description = "Name prefix of the Cognito User Pool"
  default     = "myuserpool"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "mfa_enabled" {
  type        = string
  description = "Wheather to enable MFA or not"
  default     = "OFF"
}

variable "region" {
  type        = string
  description = "Enviroment region"
  default     = "us-east-1"
}

variable "enable_auth" {
  type        = bool
  description = "Wheather to create the auth env or not"
  default     = false
}

variable "users" {
  type = map(object({
    username = string
    email    = string
  }))
  description = "Map of users to be created"
  default     = {}
}
