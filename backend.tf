terraform {
  # DO NOT CHANGE THIS
  # pin down versions
  required_version = "1.3.3"

  backend "s3" {
    # To store state files
    bucket  = "aws-terraform-s3-bucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "dev"

    # To hold state file locks
    dynamodb_table = "aws-terraform--state-live-lock"
    encrypt        = true
  }
}