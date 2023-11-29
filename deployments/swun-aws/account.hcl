# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  account_name   = "Development"
  aws_account_id = 544938405808
  aws_profile    = "swunmath"
}