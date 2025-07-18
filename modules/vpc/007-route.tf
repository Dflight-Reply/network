resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # route {
  #   cidr_block = var.vpc.cidr_block
  #   gateway_id = "local"
  # }

  # dynamic "route" {
  #   for_each = try(aws_internet_gateway.this, {})
  #   content {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_internet_gateway.this[0].id

  #   }

  # }

  tags = {
    Name = "public route table"
  }
}

resource "aws_route_table" "private-logic" {
  for_each = try(var.vpc.subnets.private-logic, {})

  vpc_id = aws_vpc.this.id

  # route {
  #   cidr_block = var.vpc.cidr_block
  #   gateway_id = "local"
  # }

  # #add this route if in the same AZ there is a public subnet with NAT
  # dynamic "route" {
  #   for_each = var.vpc.subnets.public[each.key].attach_nat_gateway ? [true] : []
  #   content {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_nat_gateway.this[each.key].id
  #   }

  # }


  tags = {
    Name = "private-logic ${each.key} route table"
  }
}

resource "aws_route_table" "private-data" {
  for_each = try(var.vpc.subnets.private-data, {})

  vpc_id = aws_vpc.this.id

  # route {
  #   cidr_block = var.vpc.cidr_block
  #   gateway_id = "local"
  # }

  # #add this route if in the same AZ there is a public subnet with NAT
  # dynamic "route" {
  #   for_each = var.vpc.subnets.public[each.key].attach_nat_gateway ? [true] : []
  #   content {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_nat_gateway.this[each.key].id
  #   }

  # }


  tags = {
    Name = "private-data ${each.key} route table"
  }
}

resource "aws_route" "igw" {
  count                  = length(aws_internet_gateway.this)
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "nat-logic" {
  for_each               = var.vpc.subnets.private-logic
  route_table_id         = aws_route_table.private-logic[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.route_to_nat_subnet_id].id
}

resource "aws_route" "nat-data" {
  for_each               = var.vpc.subnets.private-data
  route_table_id         = aws_route_table.private-data[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.route_to_nat_subnet_id].id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-logic" {
  for_each       = aws_route_table.private-logic
  subnet_id      = aws_subnet.private-logic[each.key].id
  route_table_id = aws_route_table.private-logic[each.key].id
}

resource "aws_route_table_association" "private-data" {
  for_each       = aws_route_table.private-data
  subnet_id      = aws_subnet.private-data[each.key].id
  route_table_id = aws_route_table.private-data[each.key].id
}
