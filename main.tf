locals {
  # Generates CIDR blocks for public subnets based on subnet_cidr_offset variable value.
  # The offset determines how many bits to allocate for subnetting the VPC's CIDR.
  # Example: with a /16 VPC and a subnet_cidr_offset of 8 (default), creates /24 subnets.
  public_subnet_cidrs = [for i in range(var.desired_az_count) : cidrsubnet(var.cidr, var.subnet_cidr_offset, i)]
  # Generates CIDR blocks for private subnets, avoiding overlap with public subnets.
  # The 'i + var.desired_az_count' skips over public subnets to prevent conflicts.
  private_subnet_cidrs = [for i in range(var.desired_az_count) : cidrsubnet(var.cidr, var.subnet_cidr_offset, i + var.desired_az_count)] # Genera /24 subnets
}


data "aws_availability_zones" "azs" {
  # Retrieves all available availability zones in the region, excluding local zones
  all_availability_zones = false
}

#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true # Enables DNS support for the VPC
  enable_dns_hostnames = true # Enables DNS hostnames within the VPC

  tags = merge(
    {
      Name = "${var.project}-vpc" # Sets the VPC name based on the project name variable.
    },
    var.tags
  )

}

resource "aws_subnet" "public" {
  # Ensures the number of subnets does not exceed the number of available AZs in the region
  count = var.desired_az_count > length(data.aws_availability_zones.azs.names) ? length(data.aws_availability_zones.azs.names) : var.desired_az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]                      # Assigns a CIDR block for each public subnet based on its index
  availability_zone = element(data.aws_availability_zones.azs.names, count.index) # Assigns each subnet to a different availability zone

  map_public_ip_on_launch = true # Automatically assign a public IP to instances launched in this subnet #tfsec:ignore:aws-ec2-no-public-ip-subnet

  tags = merge(
    {
      Name = "${var.project}-public-subnet-${count.index}" # Names the subnet based on the project name variable and index
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  # Ensures the number of subnets does not exceed the number of available AZs in the region
  count = var.desired_az_count > length(data.aws_availability_zones.azs.names) ? length(data.aws_availability_zones.azs.names) : var.desired_az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]                     # Assigns a CIDR block for each private subnet based on its index
  availability_zone = element(data.aws_availability_zones.azs.names, count.index) # Assigns each private subnet to a different availability zone

  tags = merge(
    {
      Name = "${var.project}-private-subnet-${count.index}" # Names the private subnet based on the project and index
    },
    var.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project}-igw" # Name of the internet gateway based on the project name variable
    },
    var.tags
  )
}

resource "aws_eip" "nat" {
  count = length(aws_subnet.public) # Creates one Elastic IP for each public subnet

  domain = "vpc"

  tags = merge(
    {
      Name = "${var.project}-nat-eip-${count.index}" # Name of the NAT Elastic IP based on the project name variable and index.
    },
    var.tags
  )
}

resource "aws_nat_gateway" "nat" {
  count = length(aws_subnet.public) # Creates one NAT Gateway for each public subnet

  allocation_id = aws_eip.nat[count.index].id       # Associates the Elastic IP with the NAT Gateway
  subnet_id     = aws_subnet.public[count.index].id # Places the NAT Gateway in the corresponding public subnet

  tags = merge(
    {
      Name = "${var.project}-nat-gateway-${count.index}" # Name of the NAT Gateway
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "${var.project}-public-rt" # Name of the public route table based on the name project variable
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  count = length(aws_subnet.private) # Creates one route table for each private subnet

  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project}-private-rt-${count.index}" # Name of the private route table based on the project name variable and index
    },
    var.tags
  )
}

resource "aws_route" "private_nat" {
  count = length(aws_subnet.private) # Creates a NAT route for each private route table.

  route_table_id         = aws_route_table.private[count.index].id # Associates the route with the corresponding private route table
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id # Uses the corresponding NAT Gateway for outgoing traffic
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public) # Associates the public route table with each public subnet

  subnet_id      = aws_subnet.public[count.index].id # The public subnet to associate
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private) # Associates each private route table with its corresponding subnet

  subnet_id      = aws_subnet.private[count.index].id # The private subnet to associate
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id # Applies the ACL to all public subnets

  tags = merge(
    {
      Name = "${var.project}-public-acl" # Name of the public Network ACL based on the project name variable.
    },
    var.tags
  )
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id # Applies the ACL to all private subnets
  tags = merge(
    {
      Name = "${var.project}-private-acl" # Name of the private Network ACL
    },
    var.tags
  )
}
