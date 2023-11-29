output "aws_region" {
  description = "Details about selected AWS region"
  value       = data.aws_region.selected
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "account_id_suffix" {
  value = substr(data.aws_caller_identity.current.account_id, -5, -1)
}
output "available_aws_availability_zones_names" {
  description = "A list of the Availability Zone names available to the account"
  value       = data.aws_availability_zones.available.names
}

output "available_aws_availability_zones_zone_ids" {
  description = "A list of the Availability Zone IDs available to the account"
  value       = data.aws_availability_zones.available.zone_ids
}

