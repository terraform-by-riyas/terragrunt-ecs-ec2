include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl")) // output will be the folder name e.g dev. prod, staging
  
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ecs-ec2-cluster"
  
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
inputs = {
  name = "my-ecs1"
  container_name = "nginx"
  container_port = "80"
  vpc_id = dependency.vpc.outputs.vpc_ids

  

    tags = {
      Terraform   = "true"
      Environment = "${local.environment_vars.locals.environment}"
    }
}
