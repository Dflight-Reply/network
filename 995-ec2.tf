# Testing machine
# This configutation are NOT part of network configurations
# Use this machines just for testing purpose

locals {
  turn_on = false

  ec2_tags = {
    Owner              = "g.sello@reply.it"
    Schedule           = "reply-office-hours"
    DateOfDecommission = "12/03/2025"
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
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_public.id]

  tags = merge(local.ec2_tags, { Name = "PING PUBLIC ${each.key}" })

  volume_tags = local.ec2_tags
}

resource "aws_instance" "private-logic" {
  for_each      = local.turn_on ? module.vpc_noprod.subnet_private-logic : {}
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id     = each.value.id
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/AmazonSSMRoleForInstancesQuickSetup"
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_private_logic.id]

  tags = merge(local.ec2_tags, { Name = "PING PRIVATE ${each.key}" })

  volume_tags = local.ec2_tags
}

resource "aws_instance" "private-data" {
  for_each      = local.turn_on ? module.vpc_noprod.subnet_private-data : {}
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"
  subnet_id     = each.value.id
  #   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/AmazonSSMRoleForInstancesQuickSetup"
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.vpc_noprod.securitygroup_private_data.id]

  tags = merge(local.ec2_tags, { Name = "PING PRIVATE ${each.key}" })

  volume_tags = local.ec2_tags
}
