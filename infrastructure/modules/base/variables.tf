variable "prefix" {
  description = "Names for all resources will be prefixed with this\nUseful for developers"
}
variable "env" {
  description = "Target environment for tagging purposes"
}
variable "deploy_user" {
  description = "Deployer of the infrastructure"
}
