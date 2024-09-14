module "vpc" {
  source               = "git::https://github.com/ullagallu123/vpc.git?ref=main"
  environment          = var.environment
  project_name         = var.project_name
  common_tags          = var.common_tags
  availability_zones   = var.availability_zones
  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks

  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  db_subnet_cidr_blocks = var.db_subnet_cidr_blocks

  enable_nat_gateway = false

  enable_vpc_peering = false

  enable_vpc_flow_logs = false
}