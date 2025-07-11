provider "aws" {
  region  = var.region
  #profile = "${var.aws_profile}"
  default_tags {
    tags = try(var.tags.default, null)
  }
}