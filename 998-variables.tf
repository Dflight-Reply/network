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