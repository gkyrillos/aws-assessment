terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Region     = var.region
      ManagedBy  = "Terraform"
      RootModule = "compute-and-data"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
