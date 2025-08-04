# Testing machine
# This configutation are NOT part of network configurations
# Use this machines just for testing purpose

locals {
  turn_on = false

  ec2_tags = {
    scope = "networkTest"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "public" {
  for_each      = local.turn_on ? module.vpc_noprod.subnet_public : {}
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id     = each.value.id
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/AmazonSSMRoleForInstancesQuickSetup"
  iam_instance_profile   = "networkTestSSMRole"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_public.id]
  tags                   = merge(local.ec2_tags, { Name = "PING PUBLIC ${each.key}" })
  volume_tags            = local.ec2_tags
  user_data              = file("${path.module}/TestFiles/networkTest.bash")
  key_name               = "networkTestKey"
}

resource "aws_instance" "private-logic" {
  for_each      = local.turn_on ? module.vpc_noprod.subnet_private-logic : {}
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id     = each.value.id
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/AmazonSSMRoleForInstancesQuickSetup"
  iam_instance_profile   = "networkTestSSMRole"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_private_logic.id]
  tags                   = merge(local.ec2_tags, { Name = "PING PRIVATE ${each.key}" })
  volume_tags            = local.ec2_tags
  user_data              = file("${path.module}/TestFiles/networkTest.bash")
  key_name               = "networkTestKey"
}

resource "aws_security_group_rule" "private_logic_alb_ingress" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = module.vpc_noprod.securitygroup_public.id
  security_group_id        = module.vpc_noprod.securitygroup_private_logic.id
}

# ALB target group attachment removed - ALB is managed by EKS project
# resource "aws_lb_target_group_attachment" "test-private" {
#   for_each         = aws_instance.private-logic
#   target_group_arn = module.vpc_noprod.alb_target_group_arn
#   target_id        = each.value.private_ip
#   port             = 8000
# }

resource "aws_instance" "private-data" {
  for_each      = local.turn_on ? module.vpc_noprod.subnet_private-data : {}
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id     = each.value.id
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/AmazonSSMRoleForInstancesQuickSetup"
  iam_instance_profile   = "networkTestSSMRole"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_private_data.id]
  tags                   = merge(local.ec2_tags, { Name = "PING PRIVATE ${each.key}" })
  volume_tags            = local.ec2_tags
  user_data              = file("${path.module}/TestFiles/networkTest.bash")
  key_name               = "networkTestKey"

}
