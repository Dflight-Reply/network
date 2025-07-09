module "vpc_noprod" {
  source = "./modules/vpc"
  providers = {
    aws = aws
  }

  vpc = var.vpc
  # client_vpn = var.vpc.client_vpn
  tags = var.tags
}

# module "ecr_efs" {
#   source               = "./modules/ecr_efs"
#   subnet_ids           = [for k, v in module.vpc_noprod.subnet_private-logic : v.id]
#   logic_security_group = module.vpc_noprod.securitygroup_private_logic.id
#   providers = {
#     aws = aws
#   }
# }

# module "rds" {
#   source = "./modules/rds"
#   data_sg = [module.vpc_noprod.securitygroup_private_data.id]
#   subnet_ids =  [for k, v in module.vpc_noprod.subnet_private-data : v.id]
#   providers = {
#     aws = aws
#   }
# }

# module "eks" {
#   source             = "./modules/eks"
#   subnet_ids         = [for k, v in module.vpc_noprod.subnet_private-logic : v.id]
#   DateOfDecommission = "15/03/2025"
#   logic_sg_id        = module.vpc_noprod.securitygroup_private_logic.id
#   vpc_id             = module.vpc_noprod.vpc.id
#   ProjectName        = "demo-dflight"
#   providers = {
#     aws = aws
#   }
# }