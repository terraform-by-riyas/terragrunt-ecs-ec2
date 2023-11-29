variable "name" {}
variable "container_name" {}
variable "container_port" {}
variable "vpc_id" {}
variable "public_subnets" {
 type    = list(string)
}
variable "private_subnets" {
 type    = list(string)
}
variable "vpc_zone_identifier" {
 type    = list(string)
}
