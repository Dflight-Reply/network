# Non-production environment configuration for DFlight Network Infrastructure
region = "eu-south-1"

# DFlight standardized tagging configuration
environment            = "nonprod"
created_by            = "terraform-automation"
cost_center           = "IT-Infrastructure"
department            = "Engineering"
schedule              = "reply-office-hours"
backup_required       = "true"
data_classification   = "internal"

# Legacy tags for backward compatibility
tags = {
  default = {
    "stage" : "noprod"
  }
}

vpc = {
  name                                 = "Demo-Dflight" #EU IRELAND NOPROD
  cidr_block                           = "10.0.0.0/17"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true

  subnets = {
    public = {
      "PU_A" = {
        # id                      = "A"
        name                    = "PUBLIC_A"
        cidr_block              = "10.0.0.0/23"
        availability_zone       = "eu-south-1a"
        attach_nat_gateway      = true
        map_public_ip_on_launch = true
      }
      "PU_B" = {
        # id                      = "B"
        name                    = "PUBLIC_B"
        cidr_block              = "10.0.2.0/23"
        availability_zone       = "eu-south-1b"
        attach_nat_gateway      = true
        map_public_ip_on_launch = true
      }
      "PU_C" = {
        # id                      = "C"
        name                    = "PUBLIC_C"
        cidr_block              = "10.0.4.0/23"
        availability_zone       = "eu-south-1c"
        attach_nat_gateway      = true
        map_public_ip_on_launch = true
      }
    }
    private-logic = {
      "PR_A" = {
        # id                = "A"
        name                   = "PRIVATE_A"
        cidr_block             = "10.0.16.0/20"
        availability_zone      = "eu-south-1a"
        route_to_nat_subnet_id = "PU_A"
        attach_vpce            = true
      }
      "PR_B" = {
        # id                = "B"
        name                   = "PRIVATE_B"
        cidr_block             = "10.0.32.0/20"
        availability_zone      = "eu-south-1b"
        route_to_nat_subnet_id = "PU_B"
        attach_vpce            = true
      }
      "PR_C" = {
        # id                = "C"
        name                   = "PRIVATE_C"
        cidr_block             = "10.0.48.0/20"
        availability_zone      = "eu-south-1c"
        route_to_nat_subnet_id = "PU_C"
        attach_vpce            = true
      }
    }
    private-data = {
      "PRD_A" = {
        # id                = "A"
        name                   = "PRIVATE_DATA_A"
        cidr_block             = "10.0.64.0/20"
        availability_zone      = "eu-south-1a"
        route_to_nat_subnet_id = "PU_A"
      }
      "PRD_B" = {
        # id                = "B"
        name                   = "PRIVATE_DATA_B"
        cidr_block             = "10.0.80.0/20"
        availability_zone      = "eu-south-1b"
        route_to_nat_subnet_id = "PU_B"
      }
      "PRD_C" = {
        # id                = "C"
        name                   = "PRIVATE_DATA_C"
        cidr_block             = "10.0.96.0/20"
        availability_zone      = "eu-south-1c"
        route_to_nat_subnet_id = "PU_C"
      }
    }
  }

  client_vpn = {
    enabled           = false
    split_tunnel      = false
    client_cidr_block = "10.0.32.0/19"
    dns_servers       = ["10.0.0.2"]
    certificate = {
      acm = {
        client = { arn = "arn:aws:acm:eu-south-1:523753954008:certificate/d7826dfa-ac79-4df1-96fe-09f22d40039e" }
        server = { arn = "arn:aws:acm:eu-south-1:523753954008:certificate/0c1fe8a3-f1de-44a8-9cc6-ad728c26f5ff" }
      }
    }
    associations = {
      "PR_A" = {}
      "PR_B" = {}
      "PR_C" = {}
    }
    authorization_rules = {
      "0.0.0.0/0" = {}
    }
    routes = {
      "PR_A" = { destination_cidr_block = "0.0.0.0/0", subnet_id = "PR_A" }
      "PR_B" = { destination_cidr_block = "0.0.0.0/0", subnet_id = "PR_B" }
      "PR_C" = { destination_cidr_block = "0.0.0.0/0", subnet_id = "PR_C" }
    }
  }
}

backend = {
  bucket_name = "iac-terraform-state-bucket-eu-south-1-7739265a"
  region      = "eu-south-1"
  dynamodb_table = {
    name = "terraform-state-lock-7739265a"
  }
}