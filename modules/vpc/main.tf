resource "aws_vpc" "vpc_use1" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    env = var.env
  }
}