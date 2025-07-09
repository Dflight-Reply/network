resource "aws_efs_file_system" "dflight-efs" {
  creation_token = "dflight-token"
  # encrypted = 
  tags = {
    Name               = "demo-dflight-efs"
    Owner              = "g.sello@reply.it"
    Schedule           = "reply-office-hours"
    DateOfDecommission = "12/03/2025"
  }
}

resource "aws_efs_mount_target" "efs-mount-target" {
  count           = length(var.subnet_ids)
  subnet_id       = var.subnet_ids[count.index]
  file_system_id  = aws_efs_file_system.dflight-efs.id
  security_groups = [var.logic_security_group]
}