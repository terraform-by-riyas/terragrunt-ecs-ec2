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
 	name        = "Public ALB"
	description = "Allow http and https traffic from LB"
	vpc_id      = dependency.vpc.outputs.vpc_id 
        ingress_cidr_blocks      = ["0.0.0.0/0"]
	ingress_rules            = ["https-443-tcp", "http-80-tcp"]
	egress_rules = ["all-all"]




    tags = {
      Terraform   = "true"
      Environment = "${local.environment_vars.locals.environment}"
    }
}
