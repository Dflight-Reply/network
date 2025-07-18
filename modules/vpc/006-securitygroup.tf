# Default Security Group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  # Ingress Rules
  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    description = "all communication within security group"
  }

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    description = "all communication within security group"
  }

  # Egress Rules
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr_block]
  }
}

# VPCE Security Group
resource "aws_security_group" "vpce-sg" {
  name        = "${var.vpc.name} vpce"
  description = "vpce security group for ${var.vpc.name}"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.vpc.name} vpce-sg"
  }
}

# VPCE Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "vpce-ingress" {
  security_group_id = aws_security_group.vpce-sg.id
  description       = "allow incoming https traffic"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "10.0.0.0/17"
}

# Private Logic Security Group
resource "aws_security_group" "private-logic" {
  name        = "${var.vpc.name} private-logic"
  description = "private-logic security group for ${var.vpc.name}"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.vpc.name} private-logic"
  }
}

# Private Logic Security Group Rules

resource "aws_vpc_security_group_egress_rule" "private_logic_icmp" {
  security_group_id = aws_security_group.private-logic.id
  description       = "allows icmp towards 0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
}

resource "aws_vpc_security_group_ingress_rule" "private-logic_internal" {
  security_group_id            = aws_security_group.private-logic.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.private-logic.id
}

resource "aws_vpc_security_group_egress_rule" "private-logic_internal" {
  security_group_id            = aws_security_group.private-logic.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.private-logic.id
}

resource "aws_vpc_security_group_egress_rule" "private-logic_all_https" {
  security_group_id = aws_security_group.private-logic.id
  description       = "allows TCP port 443 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# La regola sotto serve per MGN, da togliere in prod
resource "aws_vpc_security_group_egress_rule" "private-logic_1500" {
  security_group_id = aws_security_group.private-logic.id
  description       = "allows TCP port 1500 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 1500
  ip_protocol       = "tcp"
  to_port           = 1500
}

# NodePort del cluster usato per test
#resource "aws_vpc_security_group_ingress_rule" "NodePort-ingress" {
#  security_group_id            = aws_security_group.private-logic.id
#  description                  = "allows TCP port 30080 from public"
#  from_port                    = 30080
#  ip_protocol                  = "tcp"
#  to_port                      = 30080
#  referenced_security_group_id = aws_security_group.public.id
#}

resource "aws_vpc_security_group_egress_rule" "private-logic_all_http" {
  security_group_id = aws_security_group.private-logic.id
  description       = "allows TCP port 80 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "private-logic_s3_pl" {
  security_group_id = aws_security_group.private-logic.id
  description       = "all communication to s3 prefix list"
  prefix_list_id    = data.aws_ec2_managed_prefix_list.s3.id
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "private-logic_dynamodb_pl" {
  security_group_id = aws_security_group.private-logic.id
  description       = "all communication to dynamodb prefix list"
  prefix_list_id    = data.aws_ec2_managed_prefix_list.dynamodb.id
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "private-logic_mysql_egress" {
  security_group_id            = aws_security_group.private-logic.id
  description                  = "Allow MySQL traffic to private-data"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.private-data.id
}


# Private Data Security Group
resource "aws_security_group" "private-data" {
  name        = "${var.vpc.name} private-data"
  description = "private-data security group for ${var.vpc.name}"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.vpc.name} private-data"
  }
}

# Private Data Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "private-data_internal-ingress" {
  security_group_id            = aws_security_group.private-data.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.private-data.id
}

resource "aws_vpc_security_group_egress_rule" "private-data_internal-egress" {
  security_group_id            = aws_security_group.private-data.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.private-data.id
}

resource "aws_vpc_security_group_ingress_rule" "private-data_mysql_ingress" {
  security_group_id            = aws_security_group.private-data.id
  description                  = "Allow MySQL traffic from private-logic"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.private-logic.id
}

resource "aws_vpc_security_group_egress_rule" "private-data_all_https" {
  security_group_id = aws_security_group.private-data.id
  description       = "allows TCP port 443 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Public Security Group
resource "aws_security_group" "public" {
  name        = "${var.vpc.name} public"
  description = "public security group for ${var.vpc.name}"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.vpc.name} public"
  }
}

# Public Security Group Rules
resource "aws_vpc_security_group_egress_rule" "public_internal_egress" {
  security_group_id            = aws_security_group.public.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.public.id
}

resource "aws_vpc_security_group_ingress_rule" "public_internal_ingress" {
  security_group_id            = aws_security_group.public.id
  description                  = "all communication within security group"
  ip_protocol                  = -1
  referenced_security_group_id = aws_security_group.public.id
}

resource "aws_vpc_security_group_egress_rule" "public_all_https" {
  security_group_id = aws_security_group.public.id
  description       = "allows TCP port 443 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "public_all_http" {
  security_group_id = aws_security_group.public.id
  description       = "allows TCP port 80 towards 0.0.0.0/0"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "public_icmp" {
  security_group_id = aws_security_group.public.id
  description       = "allows icmp towards 0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
}

resource "aws_vpc_security_group_ingress_rule" "public_https_ingress" {
  security_group_id = aws_security_group.public.id
  description       = "allows https from 0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "public_http_ingress" {
  security_group_id = aws_security_group.public.id
  description       = "allows http from 0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

# NodePort del cluster usato per test
resource "aws_vpc_security_group_egress_rule" "NodePort-egress" {
  security_group_id            = aws_security_group.public.id
  description                  = "allows TCP port 30080 from public"
  from_port                    = 30080
  ip_protocol                  = "tcp"
  to_port                      = 30080
  referenced_security_group_id = aws_security_group.private-logic.id
}