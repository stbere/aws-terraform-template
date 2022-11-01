# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc_use1" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    env = var.env
  }
}
