# https://developer.hashicorp.com/terraform/language/settings#terraform-block-syntax
terraform {
  # Semantic Versioning Helper: https://semver.npmjs.com/
  # https://developer.hashicorp.com/terraform/language/providers/requirements#requiring-providers
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59.0"
    }
    # https://registry.terraform.io/providers/hashicorp/null/latest/docs
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}
