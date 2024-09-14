terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }
  backend "s3" {
    bucket         = "ugl-expense-mum"
    key            = "frontend/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "expense-ugl-mum"
  }
}

provider "aws" {
  profile = "ap-south-1"
  region  = "ap-south-1"
}