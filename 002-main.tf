module "vpc_noprod" {
  source = "./modules/vpc"
  providers = {
    aws = aws
  }

  vpc = var.vpc
  # client_vpn = var.vpc.client_vpn
  tags = var.tags
}