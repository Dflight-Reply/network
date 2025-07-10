provider "aws" {
  region  = var.region
  profile = "storm-roma-lab"
  default_tags {
    tags = try(var.tags.default, null)
  }
}