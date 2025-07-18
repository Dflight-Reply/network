locals {
  all_subnet = merge(aws_subnet.public, aws_subnet.private-logic, aws_subnet.private-data)
}
