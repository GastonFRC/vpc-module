variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_offset" {
  description = "Number of bits to add to the VPC CIDR for subnetting (e.g., 8 to create /24 subnets from a /16 VPC CIDR)"
  type        = number
  default     = 8
}

variable "project" {
  description = "Name of the project that will be added as a suffix when creating the tags of the resources"
  type        = string
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}

variable "desired_az_count" {
  description = "Number of Availability Zones to use for creating subnets"
  type        = number
}

variable "region" {

  description = "Region to be used"
  type        = string
  default     = "eu-central-1"
}