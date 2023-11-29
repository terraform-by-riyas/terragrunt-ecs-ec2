include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl")) // output will be the folder name e.g dev. prod, staging
  azs = []
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.2.0"
  
}

dependencies {
  paths = ["../aws-data"]
}

dependency "aws-data" {
  config_path = "../aws-data"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.2.0?tab=inputs
###########################################################
inputs = {
  # A list of availability zones names or ids in the region
  # type: list(string)
	azs = slice([for v in dependency.aws-data.outputs.available_aws_availability_zones_names: v],0,2) # 2 means 2 AZ. LB requires minimum 2 AZ
	name = "${local.common_vars.project_name}-${local.environment_vars.locals.environment}"
	private_subnets = [for k,v in dependency.aws-data.outputs.available_aws_availability_zones_names: cidrsubnet("${local.common_vars.cidr}", 8, k)]
	public_subnets = slice([for k,v in dependency.aws-data.outputs.available_aws_availability_zones_names: cidrsubnet("${local.common_vars.cidr}", 8, k + 4)],0,3) 
  
  # Enable NAT Gateway for the private subnet
   enable_nat_gateway = true
   single_nat_gateway = true


    tags = {
      Terraform   = "true"
      Environment = "${local.environment_vars.locals.environment}"
    }
}