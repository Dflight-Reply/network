# DFlight Network Infrastructure Project: Network Component

## Overview

This Terraform project implements the foundational network infrastructure for ENAV's DFlight project, providing a secure and scalable foundation for the containerized application ecosystem.
The project creates a multi-tier VPC with public and private subnets, load balancers, VPC endpoints, and advanced security components.

The infrastructure is designed to support the DFlight project's EKS cluster, ECR registries, and EFS file systems, following AWS best practices for security, scalability, and cost optimization.

## Architecture

The project implements a three-tier network architecture distributed across three Availability Zones to ensure high availability:

### 🌐 **VPC (Virtual Private Cloud)**
- **CIDR Block**: `10.0.0.0/17` (nonprod) / `10.0.32.0/19` (prod)
- **DNS Support**: Enabled for name resolution
- **DNS Hostnames**: Enabled for public hostnames
- **Network Address Usage Metrics**: IP address usage monitoring

### 🏗️ **Multi-Tier Architecture**

#### **Public Tier (DMZ)**
- **3 Public Subnets** distributed across 3 AZs
- **CIDR**: `10.0.0.0/23`, `10.0.2.0/23`, `10.0.4.0/23`
- **Functions**: Internet Gateway, NAT Gateway, Load Balancer
- **Auto-assign Public IP**: Enabled

#### **Application Tier (Private Logic)**
- **3 Private Subnets** for computational workloads
- **CIDR**: `10.0.16.0/20`, `10.0.32.0/20`, `10.0.48.0/20`
- **Functions**: EKS worker nodes, containerized applications
- **VPC Endpoints**: Enabled for AWS services

#### **Data Tier (Private Data)**
- **3 Private Subnets** for databases and storage
- **CIDR**: `10.0.64.0/20`, `10.0.80.0/20`, `10.0.96.0/20`
- **Functions**: Databases, EFS mount targets, persistent storage
- **Isolation**: Maximum security for data

### 🔗 **Connectivity Components**

#### **Internet Gateway**
- Internet access for public subnets
- Bidirectional routing for public traffic

#### **NAT Gateway (3x)**
- One NAT Gateway per AZ for high availability
- Outbound internet access for private subnets
- Dedicated Elastic IPs

#### **Application Load Balancer**
- **Type**: Application Load Balancer (Layer 7)
- **Scheme**: Internet-facing
- **Target Group**: Configured for EKS (port 8000)
- **Health Check**: `/health` endpoint with optimized parameters
- **Listener**: HTTP port 80 with forward to target group

### 🔒 **VPC Endpoints**
Private connectivity to AWS services without internet traffic:
- **SSM (Systems Manager)**: Instance management
- **SSM Messages**: Session Manager communication
- **EC2 Messages**: EC2 Systems Manager messages
- **KMS**: Encryption key management
- **MGN**: Application Migration Service

### 🛡️ **Security Groups**
- **Public SG**: Access control for public resources
- **Private Logic SG**: Application tier protection
- **Private Data SG**: Maximum security for data tier
- **VPC Endpoint SG**: Controlled access to endpoints

### 🔐 **Advanced Security Features**

#### **WAF (Web Application Firewall)** - *Not fully implemented yet*
- Web application protection from common attacks
- Regional configuration for ALB
- Customizable rules (currently commented)

#### **Client VPN** - *Not fully implemented yet*
- Secure remote access to VPC
- Certificate-based authentication
- Configurable split tunneling
- Connection logging

#### **Site-to-Site VPN** - *Not fully implemented yet*
- Hybrid connectivity with on-premises data centers
- Customer Gateway and Virtual Private Gateway
- Configurable static routing

## Project Structure

```
.
├── 001-locals.tf              # Centralized tagging strategy
├── 002-main.tf                # Main module orchestration
├── 998-variables.tf           # Global variable definitions
├── terraform.tfvars           # Base environment configuration
├── tfvars/
│   ├── 00-noprod.tfvars      # Non-production configuration
│   └── 99-prod.tfvars        # Production configuration
└── modules/vpc/               # Main VPC module
    ├── 000-data.tf           # Data sources
    ├── 001-locals.tf         # Module local variables
    ├── 002-vpc.tf            # Main VPC resource
    ├── 003-subnet.tf         # Multi-tier subnets
    ├── 004-igw.tf            # Internet Gateway
    ├── 005-nat.tf            # NAT Gateway
    ├── 006-securitygroup.tf  # Security Groups
    ├── 007-route.tf          # Route Tables
    ├── 008-vpce.tf           # VPC Endpoints
    ├── 009-clientvpn.tf      # Client VPN (ready)
    ├── 010-alb.tf            # Application Load Balancer
    ├── 011-waf.tf            # Web Application Firewall (ready)
    ├── 012-s2svpn.tf         # Site-to-Site VPN (ready)
    ├── 996-providers.tf      # Provider configuration
    ├── 998-variables.tf      # Module variables
    └── 999-output.tf         # Module outputs
```

## Tagging Strategy

The project implements a comprehensive tagging strategy consistent with the DFlight ecosystem, following AWS best practices for governance, cost management, and compliance.

### 🏷️ **Core Tags (Applied to All Resources)**

| Tag | Description | Value |
|-----|-------------|-------|
| `Project` | Project identifier | `dflight` |
| `Environment` | Deployment environment | `nonprod`/`prod`/`dev`/`staging` |
| `Owner` | Resource owner | `enav` |
| `ManagedBy` | Management tool | `terraform` |
| `CreatedBy` | Creator identifier | `terraform-automation` |
| `CreatedDate` | Creation date | `2025-01-24` |
| `CostCenter` | Cost center | `IT-Infrastructure` |
| `Department` | Department | `Engineering` |
| `Schedule` | Operational schedule | `reply-office-hours`/`24x7` |
| `BackupRequired` | Backup requirement | `true`/`false` |
| `DataClassification` | Data classification | `internal`/`confidential` |
| `Layer` | Infrastructure layer | `network` |
| `Service` | AWS service | `vpc` |

### 🎯 **Component-Specific Tags**

#### **VPC**
- `Component`: `virtual-private-cloud`
- `NetworkTier`: `foundation`
- `MultiAZ`: `true`
- `DNSSupport`: `enabled`

#### **Public Subnets**
- `Component`: `public-subnet`
- `SubnetType`: `public`
- `NetworkTier`: `dmz`
- `NATGateway`: `attached`

#### **Private Logic Subnets**
- `Component`: `private-subnet`
- `SubnetType`: `private`
- `NetworkTier`: `application`
- `Purpose`: `compute-workloads`

#### **Private Data Subnets**
- `Component`: `private-subnet`
- `SubnetType`: `private`
- `NetworkTier`: `data`
- `Purpose`: `database-storage`

#### **Application Load Balancer**
- `Service`: `elbv2`
- `Component`: `application-load-balancer`
- `Purpose`: `traffic-distribution`
- `Scheme`: `internet-facing`

### 💰 **Tagging Strategy Benefits**

1. **Cost Management**: Detailed allocation by project, environment, and department
2. **Governance**: Clear traceability and ownership
3. **Compliance**: Data classification and audit trail
4. **Operations**: Simplified troubleshooting and resource management
5. **Reporting**: Enhanced visibility for management and stakeholders
6. **Consistency**: Alignment with EKS/ECR/EFS projects

## Prerequisites

### Required Software
- **Terraform**: Version 1.0 or later
- **AWS CLI**: Configured with appropriate credentials
- **Git**: For version control management

### Required AWS Permissions
The deployment requires permissions for:
- VPC and network component management
- Security Group creation and management
- Load Balancer and Target Group management
- VPC Endpoint creation
- IAM management for service roles
- CloudWatch access for logging

## Configuration

### Environment Variables

Configure in `terraform.tfvars` or environment-specific files:

```hcl
# AWS Configuration
region = "eu-south-1"

# DFlight Standardized Tagging
environment            = "nonprod"
created_by            = "terraform-automation"
cost_center           = "IT-Infrastructure"
department            = "Engineering"
schedule              = "reply-office-hours"
backup_required       = "true"
data_classification   = "internal"

# VPC Configuration
vpc = {
  name                = "Dflight-VPC"
  cidr_block         = "10.0.0.0/17"
  enable_dns_support = true
  enable_dns_hostnames = true
  
  subnets = {
    # Detailed subnet configuration...
  }
}
```

### Environment Configuration Files

#### Non-Production (`tfvars/00-noprod.tfvars`)
- **Region**: `eu-south-1`
- **CIDR**: `10.0.0.0/17`
- **Schedule**: `reply-office-hours`
- **Data Classification**: `internal`

#### Production (`tfvars/99-prod.tfvars`)
- **Region**: `eu-central-1`
- **CIDR**: `10.0.32.0/19`
- **Schedule**: `24x7`
- **Data Classification**: `confidential`

## Deployment

### 1. Initialization
```bash
terraform init
```

### 2. Planning
```bash
# Non-production environment
terraform plan -var-file="tfvars/00-noprod.tfvars"

# Production environment
terraform plan -var-file="tfvars/99-prod.tfvars"
```

### 3. Application
```bash
# Non-production environment
terraform apply -var-file="tfvars/00-noprod.tfvars"

# Production environment
terraform apply -var-file="tfvars/99-prod.tfvars"
```

## Key Features

### 🔒 **Security**
- **Network Segmentation**: Isolation between public, application, and data tiers
- **Security Groups**: Granular traffic control
- **VPC Endpoints**: Private AWS traffic without internet
- **Private Subnets**: Critical workload protection
- **WAF Ready**: Prepared for web application protection

### 🚀 **High Availability**
- **Multi-AZ**: Distribution across 3 Availability Zones
- **Redundant NAT Gateways**: One per AZ to eliminate SPOF
- **Load Balancer**: Traffic distribution with health checks
- **Route Tables**: Redundant and optimized routing

### 💡 **Cost Optimization**
- **Detailed Tagging**: Cost allocation by project/environment
- **Optimized NAT Gateways**: One per AZ balancing cost and availability
- **VPC Endpoints**: Reduced internet traffic costs
- **Right-sizing**: Appropriate sizing for workloads

### 📊 **Monitoring and Observability**
- **Network Address Usage Metrics**: IP usage monitoring
- **VPC Flow Logs**: Ready for traffic analysis
- **CloudWatch Integration**: Centralized logging
- **Health Checks**: Application status monitoring

## Outputs

The project provides the following outputs for integration with other modules:

```hcl
# VPC Information
vpc_id                    = "vpc-xxxxxxxxx"
vpc_cidr_block           = "10.0.0.0/17"

# Subnet IDs by tier
public_subnet_ids        = ["subnet-xxx", "subnet-yyy", "subnet-zzz"]
private_logic_subnet_ids = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
private_data_subnet_ids  = ["subnet-ddd", "subnet-eee", "subnet-fff"]

# Security Group IDs
public_security_group_id      = "sg-public"
private_logic_security_group_id = "sg-private-logic"
private_data_security_group_id  = "sg-private-data"

# Load Balancer
alb_dns_name            = "dflight-alb-xxxxxxxxx.eu-south-1.elb.amazonaws.com"
alb_target_group_arn    = "arn:aws:elasticloadbalancing:..."
```

## DFlight Ecosystem Integration

### 🔗 **EKS Connection**
- Private-logic subnets configured for EKS worker nodes
- Security groups prepared for cluster communication
- ALB target group configured for Kubernetes services
- Kubernetes tags for automatic integration

### 🔗 **ECR/EFS Support**
- VPC Endpoints for private AWS service access
- Private-data subnets for EFS mount targets
- Security groups configured for storage traffic
- Network ACLs optimized for performance

### 🔗 **Future Services Preparation** *Not fully implemented yet*
- Client VPN for developer remote access
- Site-to-Site VPN for hybrid connectivity
- WAF for web application protection
- Reserved address space for expansions

## Maintenance

### Regular Tasks
1. **IP Usage Monitoring**: Verify address availability
2. **Security Group Review**: Audit access rules
3. **Cost Analysis**: Use tags for optimization
4. **Health Checks**: Verify critical component status
5. **Configuration Backup**: Terraform state versioning

### Troubleshooting

#### Common Issues
```bash
# Check VPC status
aws ec2 describe-vpcs --vpc-ids vpc-xxxxxxxxx

# Check route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-xxxxxxxxx"

# NAT Gateway status
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=vpc-xxxxxxxxx"

# ALB health check
aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:...
```

## Support and Contributing

### Reference Documentation
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)
- [DFlight EKS Project](../eks/) - Kubernetes cluster project
- [Tagging Strategy](./TAGGING_STRATEGY.md) - Detailed tagging documentation

### Contributing
1. Follow the established tagging strategy
2. Test changes in non-production environment
3. Update documentation for architectural changes
4. Maintain consistency with related DFlight projects

---

**Project**: DFlight Network Infrastructure  
**Owner**: ENAV  
**Managed By**: Terraform  
**Environment**: Multi-environment (nonprod/prod)  
**Version**: 1.0  