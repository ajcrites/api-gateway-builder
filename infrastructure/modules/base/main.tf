resource "aws_s3_bucket" "images" {
  bucket = "${var.prefix}mob_sample_approuter_images"

  tags {
    Name = "${var.prefix} Mob sample approuter images bucket"
    Environment = "${var.env}"
    User = "${var.deploy_user}"
  }
}

resource "aws_dynamodb_table" "images" {
  name = "${var.prefix}images"

  read_capacity = 1
  write_capacity = 1

  hash_key = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "imagetags" {
  name = "${var.prefix}imagetags"

  read_capacity = 1
  write_capacity = 1

  hash_key = "Tag"
  range_key = "ImageId"

  global_secondary_index {
    name = "ImageId-index"
    hash_key = "ImageId"
    range_key = "Tag"
    projection_type = "KEYS_ONLY"
    read_capacity = 1
    write_capacity = 1
  }

  local_secondary_index {
    name = "VoteCount-index"
    range_key = "VoteCount"
    projection_type = "ALL"
  }

  attribute {
    name = "Tag"
    type = "S"
  }
  attribute {
    name = "ImageId"
    type = "S"
  }
  attribute {
    name = "VoteCount"
    type = "N"
  }
}

resource "aws_dynamodb_table" "tags" {
  name = "${var.prefix}tags"

  read_capacity = 1
  write_capacity = 1

  hash_key = "Tag"

  attribute {
    name = "Tag"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_app_router" {
  name = "${var.prefix}lambda_app_router_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_app_router_policy" {
  name = "${var.prefix}lambda_app_router_policy"
  role = "${aws_iam_role.lambda_app_router.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ],
      "Resource": [
        "${aws_dynamodb_table.images.arn}",
        "${aws_dynamodb_table.imagetags.arn}",
        "${aws_dynamodb_table.tags.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.images.arn}"
      ]
    }
  ]
}
EOF

  provisioner "local-exec" {
    command = <<EOF
      ROLE=${aws_iam_role.lambda_app_router.arn} \
      APP_PREFIX=${var.prefix} \
      AWS_REGION=${var.aws_region} \
      AWS_PROFILE=${var.aws_profile} \
      IMAGE_S3_BUCKET=${aws_s3_bucket.images.id} \
      provision/lambda.sh
EOF
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.prefix}infratest_api"
}
