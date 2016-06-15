laasddizl1

export AWS_PROFILE=${AWS_PROFILE-"default"}
export AWS_REGION=${AWS_REGION-"us-east-1"}
export TF_VAR_aws_profile="$AWS_PROFILE"
export TF_VAR_aws_region="$AWS_REGION"

terraform destroy infrastructure/env/dev
apex --profile "$AWS_PROFILE" --region "$AWS_REGION" -C apex delete

echo "This will not delete your API. You must delete this manually, but if you have the rest API id, you can use:

    aws --profile $AWS_PROFILE --region $AWS_REGION apigateway delete-rest-api --rest-api-id \$REST_API_ID"
