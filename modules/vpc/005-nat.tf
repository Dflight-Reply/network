
resource "aws_eip" "this" {
  for_each = { for key, val in try(var.vpc.subnets.public, {}) : key => val if val.attach_nat_gateway }
  domain   = "vpc"

  tags = {
    "Name" = "${each.value.name} ${each.value.availability_zone} EIP NAT"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}


resource "aws_nat_gateway" "this" {
  for_each      = { for key, val in try(var.vpc.subnets.public, {}) : key => val if val.attach_nat_gateway }
  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    "Name" = "${each.value.name} ${each.value.availability_zone} NAT"
  }

}