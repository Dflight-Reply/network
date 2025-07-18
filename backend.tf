terraform {
  backend "s3" {
    bucket         = "iac-terraform-state-bucket-eu-south-1-7739265a"
    key            = "dflight/network/terraform.tfstate"
    region         = "eu-south-1"
    dynamodb_table = "terraform-state-lock-7739265a"
    encrypt        = true
  }
}