# Centralized tagging strategy and common variables for DFlight Network Infrastructure

locals {
  # Core tags applied to all network resources
  common_tags = {
    # Project identification
    Project     = "dflight"
    Environment = var.environment
    Owner       = "enav"
    ManagedBy   = "terraform"
    CreatedBy   = var.created_by
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())

    # Cost management and governance
    CostCenter = var.cost_center
    Department = var.department
    Schedule   = var.schedule

    # Operational tags
    BackupRequired     = var.backup_required
    DataClassification = var.data_classification

    # Network layer identification
    Layer   = "network"
    Service = "vpc"
  }

  # Service-specific tags for different network components
  vpc_tags = merge(local.common_tags, {
    Component    = "virtual-private-cloud"
    NetworkTier  = "foundation"
    MultiAZ      = "true"
    DNSSupport   = "enabled"
    DNSHostnames = "enabled"
  })

  subnet_tags = {
    public = merge(local.common_tags, {
      Component   = "public-subnet"
      SubnetType  = "public"
      NetworkTier = "dmz"
      NATGateway  = "attached"
      PublicIP    = "enabled"
    })

    private_logic = merge(local.common_tags, {
      Component   = "private-subnet"
      SubnetType  = "private"
      NetworkTier = "application"
      Purpose     = "compute-workloads"
      VPCEndpoint = "enabled"
    })

    private_data = merge(local.common_tags, {
      Component   = "private-subnet"
      SubnetType  = "private"
      NetworkTier = "data"
      Purpose     = "database-storage"
      Isolated    = "true"
    })
  }

  # Internet Gateway tags
  igw_tags = merge(local.common_tags, {
    Component = "internet-gateway"
    Purpose   = "internet-access"
  })

  # NAT Gateway tags
  nat_tags = merge(local.common_tags, {
    Component     = "nat-gateway"
    Purpose       = "outbound-internet"
    HighAvailable = "true"
    ElasticIP     = "attached"
  })

  # Security Group tags
  security_group_tags = merge(local.common_tags, {
    Service   = "ec2"
    Component = "security-group"
    Purpose   = "network-access-control"
  })

  # Route Table tags
  route_table_tags = merge(local.common_tags, {
    Component = "route-table"
    Purpose   = "traffic-routing"
  })

  # VPC Endpoint tags
  vpce_tags = merge(local.common_tags, {
    Service   = "vpc-endpoint"
    Component = "private-connectivity"
    Purpose   = "aws-service-access"
    Interface = "true"
  })

  # Application Load Balancer tags
  alb_tags = merge(local.common_tags, {
    Service       = "elbv2"
    Component     = "application-load-balancer"
    Purpose       = "traffic-distribution"
    Scheme        = "internet-facing"
    IPAddressType = "ipv4"
  })

  # WAF tags
  waf_tags = merge(local.common_tags, {
    Service   = "wafv2"
    Component = "web-application-firewall"
    Purpose   = "security-protection"
    Scope     = "regional"
  })

  # Client VPN tags
  client_vpn_tags = merge(local.common_tags, {
    Service     = "ec2-client-vpn"
    Component   = "vpn-endpoint"
    Purpose     = "remote-access"
    SplitTunnel = var.vpc.client_vpn.split_tunnel ? "enabled" : "disabled"
  })

  # Site-to-Site VPN tags
  s2s_vpn_tags = merge(local.common_tags, {
    Service   = "vpn"
    Component = "site-to-site-vpn"
    Purpose   = "hybrid-connectivity"
  })

  # Merged tags for backward compatibility
  merged_tags = merge(
    var.tags.default,
    local.common_tags
  )
}
