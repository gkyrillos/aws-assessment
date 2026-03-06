terraform {
  required_version = ">= 1.14.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8"
    }
  }
}
