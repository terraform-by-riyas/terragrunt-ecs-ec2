include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl")) // output will be the folder name e.g dev. prod, staging
  
}

terraform {
	source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/autoscaling"
}

dependencies {
  paths = ["../aws-data", "../vpc"]
}

dependency "aws-data" {
  config_path = "../aws-data"
}
dependency "vpc" {
  config_path = "../vpc"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.2.0?tab=inputs
###########################################################
inputs = {
   

    tags = {
      Terraform   = "true"
      Environment = "${local.environment_vars.locals.environment}"
    }
}