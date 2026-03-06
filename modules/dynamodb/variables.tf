variable "region" {
  type        = string
  description = "Enviroment region"
  default     = "us-east-1"
}

variable "dynamodb_tables" {
  type        = set(string)
  description = "names of dynamodb tables to create"
  default     = []
}
