provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "base" {
  source = "../../modules/base"

  prefix = "${var.prefix}"
  env = "${var.env}"
  deploy_user = "${var.deploy_user}"
}
