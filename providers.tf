terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "dev"
  default_tags {
    tags = {
      CreatedBy = "Terraform"
    }
  }
}