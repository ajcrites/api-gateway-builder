variable "aws_region" {
  default = "us-east-1"
}
variable "aws_profile" {
  default = "default"
}
variable "prefix" {
  description = "Names for all resources will be prefixed with this\nUseful for developers"
}
variable "env" {
  default = "local"
  description = "Target environment for tagging purposes"
}
variable "deploy_user" {
  description = "Deployer of the infrastructure"
}
