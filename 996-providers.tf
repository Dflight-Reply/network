provider "aws" {
  region  = var.region
  default_tags {
    tags = try(var.tags.default, null)
  }
}