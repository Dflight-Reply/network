# Production environment configuration for DFlight Network Infrastructure
region = "eu-central-1"

# DFlight standardized tagging configuration
environment            = "prod"
created_by            = "terraform-automation"
cost_center           = "IT-Infrastructure"
department            = "Engineering"
schedule              = "24x7"
backup_required       = "true"
data_classification   = "confidential"

# Legacy tags for backward compatibility
tags = {
  default = {
    "stage" : "prod"
  }
}

vpc = {
  name                                 = "EUI_P" #EU IRELAND NOPROD
  cidr_block                           = "10.0.32.0/19"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true

  subnets = {
    public = {

      "PUBLIC_A" = {
        cidr_block         = "10.0.32.0/23"
        availability_zone  = "us-east-1a"
        attach_nat_gateway = true
      }
      "PUBLIC_B" = {
        cidr_block         = "10.0.34.0/23"
        availability_zone  = "us-east-1b"
        attach_nat_gateway = true
      }
      "PUBLIC_C" = {
        cidr_block         = "10.0.36.0/23"
        availability_zone  = "us-east-1c"
        attach_nat_gateway = true
      }
    }
    private = {
      "PRIVATE_A" = {
        cidr_block        = "10.0.40.0/22"
        availability_zone = "us-east-1a"
      }
      "PRIVATE_B" = {
        cidr_block        = "10.0.44.0/22"
        availability_zone = "us-east-1b"
      }
      "PRIVATE_C" = {
        cidr_block        = "10.0.48.0/22"
        availability_zone = "us-east-1c"
      }

    }

  }
}