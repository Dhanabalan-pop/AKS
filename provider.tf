provider "aws" {
  region = "us-west-2"
  # profile = var.profile
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.33.0"
    }
  }
}