#!/bin/bash

PROJECT_JSON=$(cat <<EOF
{
    "name": "app_router",
    "role": "$ROLE",
    "memory": 128,
    "runtime": "nodejs4.3",
    "handler": "lib.default",
    "hooks": {
        "build": "../../build-fn.sh",
        "clean": "rm -rf lib node_modules project.json"
    }
}
EOF
)

cd "$(pwd)/apex"
echo "$PROJECT_JSON" > project.json

apex --profile "$AWS_PROFILE" deploy \
    --set "APP_PREFIX=$APP_PREFIX" \
    --set "IMAGE_S3_BUCKET=$IMAGE_S3_BUCKET"
