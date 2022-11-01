module "vpc" {
    source = "./modules/vpc"
    cidr_block = local.config.netblocks.cidr_supernet
    env = local.config.env
}