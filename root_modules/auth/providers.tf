terraform {
  required_version = ">= 1.14"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Region     = "us-east-1"
      ManagedBy  = "Terraform"
      RootModule = "auth"
    }
  }
}
