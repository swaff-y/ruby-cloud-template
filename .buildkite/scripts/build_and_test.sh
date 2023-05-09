#!/bin/bash

set -e

mkdir -p /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}
mkdir -p /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}
cp ./serverless.yml /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml
cp ./postman_collection.json /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
  PARAMS=$(aws ssm get-parameter --name "cloud-temp-prod")
  AWS_ACCOUNT=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .AwsAccount)
  AWS_ACCESS_KEY_ID=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .awsAccessKeyId)
  AWS_SECRET_ACCESS_KEY=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .AwsSecretAccessKey)
  PROD_KEY=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .ApiKey)
  DB_CONNECTION_STRING=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .dbConnectionString)

  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "STAGE=prod" \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "AWS_ACCOUNT=${AWS_ACCOUNT}" \
    --build-arg "DB_CONNECTION_STRING=${DB_CONNECTION_STRING}" \
    --build-arg "API_KEY=${PROD_KEY}" .
else
  PARAMS=$(aws ssm get-parameter --name "cloud-temp-dev")
  AWS_ACCOUNT=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .AwsAccount)
  AWS_ACCESS_KEY_ID=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .awsAccessKeyId)
  AWS_SECRET_ACCESS_KEY=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .AwsSecretAccessKey)
  DEV_KEY=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .ApiKey)
  DB_CONNECTION_STRING=$(echo $PARAMS | jq .Parameter.Value | jq -r . | jq .dbConnectionString)

  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "STAGE=dev" \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "BRANCH=${BUILDKITE_BRANCH}" \
    --build-arg "AWS_ACCOUNT=${AWS_ACCOUNT}" \
    --build-arg "DB_CONNECTION_STRING=${DB_CONNECTION_STRING}" \
    --build-arg "API_KEY=${DEV_KEY}" .
fi

docker run \
  cloud-template-deploy bundle exec rake

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
  docker run \
    --mount type=bind,source=/Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml,target=/app/serverless.yml \
    --mount type=bind,source=/Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json,target=/app/postman_collection.json \
    cloud-template-deploy bundle exec rake deploy_prod
else
  docker run \
    --mount type=bind,source=/Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml,target=/app/serverless.yml \
    --mount type=bind,source=/Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json,target=/app/postman_collection.json \
    cloud-template-deploy bundle exec rake deploy_dev
fi