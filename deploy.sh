#!/bin/bash -e

# TODO this should allow you to specify an env
# You should also be able to specify tfstate
export AWS_PROFILE=${AWS_PROFILE-"default"}
export AWS_REGION=${AWS_REGION-"us-east-1"}
export TF_VAR_aws_profile="$AWS_PROFILE"
export TF_VAR_aws_region="$AWS_REGION"

# Update infrastructure
terraform get infrastructure/env/dev
terraform apply infrastructure/env/dev

# Create API based on our swagger definition
# FIXME ideally we could import/merge instead
rest_api_id=$(aws --output text --region "$AWS_REGION" --profile "$AWS_PROFILE" \
    apigateway import-rest-api \
    --body "$(node_modules/.bin/yaml2json swagger.yaml)" | cut -f3)

# Generate JSON of resources imported from swagger so we can add the integrations
aws --region us-east-1 --profile mobschool-acrites apigateway get-resources \
    --rest-api-id $rest_api_id > api-resources.json

# Sets $apex_function_router (our "router" function) so we can set API endpoints
# FIXME may not want to assume the name of the lambda function is "router"
eval "$(apex --profile "$AWS_PROFILE" --region "$AWS_REGION" -C apex list --tfvars)"

# TODO would be nice to find an easier way to get this
aws_account_id=$(echo $apex_function_router | cut -d: -f5)
lambda_function_name=$(echo $apex_function_router | cut -d: -f7)

OLDIFS=$IFS
IFS="
"
# `build-integrations-for-resrouces` creates flags with the resource ID and
# method so that we can hook up the integration URI (our router lambda)
for resource in $(./build-integrations-for-resources.js < api-resources.json); do
    #aws --region "$AWS_REGION" --profile "$AWS_PROFILE" \
        #lambda add-permission --function-name $lambda_function_name \
        #--statement-id $(node_modules/.bin/uuid) \
        #--action "lambda:InvokeFunction" \
        #--principal "apigateway.amazonaws.com" \
        #--source-arn "arn:aws:execute-api:${AWS_REGION}:${aws_account_id}:${rest_api_id}/*"

    eval aws --region "$AWS_REGION" --profile "$AWS_PROFILE" apigateway put-integration \
        --rest-api-id $rest_api_id $resource --type AWS \
        --uri "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${apex_function_router}/invocations"
done
IFS="$OLDIFS"
rm api-resources.json

aws --region "$AWS_REGION" --profile "$AWS_PROFILE" \
   lambda add-permission --function-name $lambda_function_name \
   --statement-id $(node_modules/.bin/uuid) \
   --action "lambda:InvokeFunction" \
   --principal "apigateway.amazonaws.com" \
   --source-arn "arn:aws:execute-api:us-east-1:293313708031:${rest_api_id}/*/GET/tag"
