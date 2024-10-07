################################################################################
# VPC
################################################################################
output "vpc_arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.main.arn
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_tenancy" {
  description = "Tenancy of instances spin up within VPC."
  value       = aws_vpc.main.instance_tenancy
}

output "vpc_cidr" {
  description = "The CIDR block for the VPC."
  value       = aws_vpc.main.cidr_block
}

output "vpc_dns" {

  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.main.enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.main.enable_dns_hostnames
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.main.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = aws_vpc.main.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.main.main_route_table_id
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = aws_vpc.main.ipv6_association_id
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = aws_vpc.main.ipv6_cidr_block
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = aws_vpc.main.owner_id
}

################################################################################
# DHCP Options Set
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = aws_vpc.main.dhcp_options_id
}

################################################################################
# Internet Gateway
################################################################################

output "igw_id" {
  description = "The ID of the internet gateway."
  value       = aws_internet_gateway.igw.id
}

output "igw_arn" {
  description = "The ARN of the internet gateway."
  value       = aws_internet_gateway.igw.arn
}

################################################################################
# Publiс Subnets
################################################################################

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "public_subnet_arn" {
  description = "The ARNs of the public subnets."
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidrs" {
  description = "The list of CIDR blocks for public subnets as created in AWS."
  value       = compact(aws_subnet.public[*].cidr_block)
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.public[*].ipv6_cidr_block)
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "public_route_table_associations_ids" {
  description = "The associations IDs of the public route table with public subnets."
  value       = aws_route_table_association.public[*].id
}

output "public_network_acl_id" {
  description = "The ID of the network ACL for public subnets."
  value       = aws_network_acl.public.id
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = aws_network_acl.public.id
}

output "public_subnet_availability_zones" {
  description = "The availability zones for the public subnets."
  value       = aws_subnet.public[*].availability_zone
}

output "public_route_table_routes" {
  description = "Routes in the public route table."
  value       = aws_route_table.public.route[*]
}

################################################################################
# Private Subnets
################################################################################

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "private_subnet_arn" {
  description = "The ARNs of the private subnets."
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidrs" {
  description = "The list of CIDR blocks for private subnets as created in AWS.."
  value       = compact(aws_subnet.private[*].cidr_block)
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.private[*].ipv6_cidr_block)
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables."
  value       = aws_route_table.private[*].id
}


output "private_subnet_availability_zones" {
  description = "The availability zones for the private subnets."
  value       = aws_subnet.private[*].availability_zone
}


output "private_route_table_associations_ids" {
  description = "The associations Ids of the private route table with private subnets."
  value       = aws_route_table_association.private[*].id
}

output "private_network_acl_id" {
  description = "The ID of the network ACL for private subnets."
  value       = aws_network_acl.private.id
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = aws_network_acl.private.arn
}

################################################################################
# NAT Gateway
################################################################################

output "nat_gateway_ids" {
  description = "The IDs of the NAT gateways created in public subnets."
  value       = aws_nat_gateway.nat[*].id
}

output "nat_eip_ids" {
  description = "The Elastic IPs associated with the NAT gateways."
  value       = aws_eip.nat[*].id
}

output "nat_eip_association_id" {
  description = "The associations of the Elastic IPs with the NAT gateways."
  value       = aws_eip.nat[*].association_id
}

################################################################################
# Available AZs
################################################################################

output "available_zones" {
  description = "The list of available zones used in the deployment."
  value       = data.aws_availability_zones.azs.names
}


