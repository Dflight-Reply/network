resource "aws_subnet" "private-logic" {
  for_each          = var.vpc.subnets.private-logic
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    #"kubernetes.io/cluster/demo-dflight-cluster" = "shared"
    #"kubernetes.io/role/internal-elb"            = "1"
    "Name"                                       = each.value.name
  }
}

resource "aws_subnet" "private-data" {
  for_each          = var.vpc.subnets.private-data
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    "Name" = each.value.name
  }
}

resource "aws_subnet" "public" {
  for_each                = var.vpc.subnets.public
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    "kubernetes.io/role/elb"                     = "1"
    "kubernetes.io/cluster/demo-dflight-cluster" = "shared"
    "Name"                                       = each.value.name
  }
}
