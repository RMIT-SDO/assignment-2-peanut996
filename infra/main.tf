terraform {
  backend "s3" {
    bucket         = "rmit-tfstate-uznb7w"
    key            = "stage/data-stores/terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "RMIT-locktable-uznb7w"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}