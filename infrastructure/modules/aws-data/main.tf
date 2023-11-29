data "aws_region" "selected" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}
