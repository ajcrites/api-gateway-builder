provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "base" {
  source = "../../modules/base"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  prefix = "${var.prefix}"
  env = "${var.env}"
  deploy_user = "${var.deploy_user}"
}

output "api_gateway_id" {
  value = "${module.base.api_gateway_id}"
}
