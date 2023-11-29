include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl")) // output will be the folder name e.g dev. prod, staging
  azs = []
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v5.1.0"
  
}

dependencies {
  paths = ["../../aws-data", "../../vpc"]
}

dependency "aws-data" {
  config_path = "../../aws-data"
}
dependency "vpc" {
  config_path = "../../vpc"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.2.0?tab=inputs
###########################################################
inputs = {
 	name        = "Self-VPC"
	description = "Self accessiblle within the VPC"
	vpc_id      = dependency.vpc.outputs.vpc_id 
	ingress_cidr_blocks      = [dependency.vpc.outputs.vpc_cidr_block]


          # Open for self (rule or from_port+to_port+protocol+description)
ingress_with_self = [
    {
      rule = "all-all"
    }
  ]


  egress_with_self = [
    {
      rule = "all-all"
    }
  ]

  create_timeout = "15m"
  delete_timeout = "45m"



    tags = {
      Terraform   = "true"
      Environment = "${local.environment_vars.locals.environment}"
    }
}
