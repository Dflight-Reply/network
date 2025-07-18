variable "region" {
  type = string
}

variable "tags" {
  default = {}
  type    = any
}
variable "vpc" {
  default = {}
  type    = any
}

#variable "aws_profile" {
#  type    = string
#  default = "storm-roma-lab"
#}