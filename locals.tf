# Fetching all the variables from config.yml
locals {
  config = yamldecode(file("${path.module}/env/dev/config.yml"))
}