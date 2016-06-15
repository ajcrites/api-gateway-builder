resource "aws_api_gateway_rest_api" "api" {
  name = "${var.prefix}infratest_api"
}
