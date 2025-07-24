variable "region" {
  description = "AWS region for resource deployment"
  type        = string
}

variable "tags" {
  description = "Legacy tags configuration for backward compatibility"
  default     = {}
  type        = any
}

variable "vpc" {
  description = "VPC configuration including subnets, client VPN, and networking settings"
  default     = {}
  type        = any
}

# Core tagging variables following DFlight standards
variable "environment" {
  description = "Environment name (nonprod, prod, dev, staging)"
  type        = string
  default     = "nonprod"

  validation {
    condition     = contains(["nonprod", "prod", "dev", "staging"], var.environment)
    error_message = "Environment must be one of: nonprod, prod, dev, staging."
  }
}

variable "created_by" {
  description = "Creator identifier for resource tracking"
  type        = string
  default     = "terraform-automation"
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "IT-Infrastructure"
}

variable "department" {
  description = "Responsible department"
  type        = string
  default     = "Engineering"
}

variable "schedule" {
  description = "Operational schedule for resource management"
  type        = string
  default     = "reply-office-hours"
}

variable "backup_required" {
  description = "Whether backup is required for this resource"
  type        = string
  default     = "true"

  validation {
    condition     = contains(["true", "false"], var.backup_required)
    error_message = "Backup required must be either 'true' or 'false'."
  }
}

variable "data_classification" {
  description = "Data classification level"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "confidential", "public", "restricted"], var.data_classification)
    error_message = "Data classification must be one of: internal, confidential, public, restricted."
  }
}

#variable "aws_profile" {
#  type    = string
#  default = "storm-roma-lab"
#}
