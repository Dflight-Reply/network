variable "subnet_ids" {
  type = list(string)
}

variable "email" {
  type    = string
  default = "g.sello@reply.it"
}

variable "DateOfDecommission" {
  type = string
}

variable "Schedule" {
  type    = string
  default = "reply-office-hours"
}

variable "logic_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ProjectName" {
  type = string
}