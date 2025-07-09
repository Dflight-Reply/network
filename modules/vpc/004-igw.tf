resource "aws_internet_gateway" "this" {
  count  = length(try(var.vpc.subnets.public, {})) > 0 ? 1 : 0 #if there is at least one public subnet
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc.name} IGW"
  }
}