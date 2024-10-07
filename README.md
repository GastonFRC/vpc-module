# Terraform AWS VPC Configuration

This repository contains the Terraform configuration to create a VPC in AWS with public and private subnets, an internet gateway, a NAT gateway, and additional network configurations.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) (version 1.9.7 or higher)
- An AWS account with appropriate permissions to create VPC resources

## Project Structure

- `main.tf`: Defines the AWS resources, including the VPC, subnets, gateways, and route tables.
- `variables.tf`: Contains the variables used in the Terraform configuration.
- `outputs.tf`: Defines the outputs of the configuration to provide useful information after deployment.
- `versions.tf`: Specifies the required version of Terraform and the providers.

## Version

The project requires:

- **Terraform**: `>= 1.9.7`
- **AWS Provider**: `~> 5.70`

## Variables

| Variable            | Description                                                                                                       | Type   | Default Value     |
|---------------------|-------------------------------------------------------------------------------------------------------------------|--------|-------------------|
| `cidr`              | (Optional) The IPv4 CIDR block for the VPC.                                                                     | string | `10.0.0.0/16`    |
| `subnet_cidr_offset`| Number of bits to add to the VPC CIDR for subnetting.                                                            | number | `8`               |
| `project`           | Name of the project that will be added as a suffix when creating the tags of the resources.                      | string |                   |
| `tags`              | Additional tags for the resources.                                                                               | map    | `{}`              |
| `desired_az_count`  | Number of Availability Zones to use for creating subnets.                                                        | number |                   |

## Created Resources

- **VPC**
  - CIDR: `var.cidr`
  - ID: `aws_vpc.main.id`
  - ARN: `aws_vpc.main.arn`
  - DNS Support: `aws_vpc.main.enable_dns_support`

- **Public Subnets**
  - ID: `aws_subnet.public[*].id`
  - CIDR: `local.public_subnet_cidrs`

- **Private Subnets**
  - ID: `aws_subnet.private[*].id`
  - CIDR: `local.private_subnet_cidrs`

- **Internet Gateway**
  - ID: `aws_internet_gateway.igw.id`
  - ARN: `aws_internet_gateway.igw.arn`

- **NAT Gateway**
  - IDs: `aws_nat_gateway.nat[*].id`
  - Elastic IPs: `aws_eip.nat[*].id`

## Outputs

The following outputs will be available after applying the configuration:

| Output                                 | Description                                                                                              |
|----------------------------------------|----------------------------------------------------------------------------------------------------------|
| `vpc_arn`                              | ARN of the VPC                                                                                           |
| `vpc_id`                               | ID of the VPC                                                                                            |
| `vpc_tenancy`                          | Tenancy of instances in the VPC                                                                           |
| `vpc_cidr`                             | CIDR block of the VPC                                                                                    |
| `vpc_dns`                              | Whether the VPC has DNS support                                                                          |
| `vpc_enable_dns_hostnames`             | Whether the VPC has DNS hostname support                                                                 |
| `public_subnet_ids`                    | IDs of the public subnets                                                                                 |
| `private_subnet_ids`                   | IDs of the private subnets                                                                                |
| `nat_gateway_ids`                      | IDs of the NAT gateways created in public subnets                                                       |
| `available_zones`                      | List of availability zones used in the deployment                                                         |

These are just a few of the outputs; please refer to the `outputs.tf` file for a complete list.

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/GastonFRC/terraform-vpc-module.git
   cd your_repository
   ```
2. Initialize Terraform:
    ```bash
   terraform init
   ```
3. Apply the configuration:
    ```bash
   terraform apply
   ```
   Confirm the creation of resources by typing yes when prompted.

4. Review the generated outputs for information about the created resources.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.