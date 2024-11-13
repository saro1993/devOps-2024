terraform {
  required_version = ">= 1.9"
  backend "s3" {
    bucket = "sa-2024-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}


provider "aws" {
  region = var.region
}
