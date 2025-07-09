resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce-sg.id]


  subnet_ids = [for key, val in var.vpc.subnets.private-logic : aws_subnet.private-logic[key].id if try(val.attach_vpce, false)]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce-sg.id]


  subnet_ids = [for key, val in var.vpc.subnets.private-logic : aws_subnet.private-logic[key].id if try(val.attach_vpce, false)]


  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce-sg.id]


  subnet_ids = [for key, val in var.vpc.subnets.private-logic : aws_subnet.private-logic[key].id if try(val.attach_vpce, false)]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.kms"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce-sg.id]

  subnet_ids = [for key, val in var.vpc.subnets.private-logic : aws_subnet.private-logic[key].id if try(val.attach_vpce, false)]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "mgn" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.mgn"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpce-sg.id]

  subnet_ids = [for key, val in var.vpc.subnets.private-logic : aws_subnet.private-logic[key].id if try(val.attach_vpce, false)]

  private_dns_enabled = true

}
