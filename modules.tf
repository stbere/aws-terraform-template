module "vpc" {
  source = "./modules/vpc"
  env    = local.config.env
  vpcs   = local.config.regions[0].vpcs
}
