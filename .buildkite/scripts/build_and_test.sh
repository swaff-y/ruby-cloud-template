#!/bin/bash

set -e

mkdir -p /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}
mkdir -p /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}
cp ./serverless.yml /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml
cp ./postman_collection.json /Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
  export AWS_ACCOUNT=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .AwsAccount)
  export AWS_ACCESS_KEY_ID=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .awsAccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .AwsSecretAccessKey)
  export PROD_KEY=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .ApiKey)
  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "STAGE=prod" \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "AWS_ACCOUNT=${AWS_ACCOUNT}" \
    --build-arg "API_KEY=${PROD_KEY}" .
else
  export AWS_ACCOUNT=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .AwsAccount)
  echo $AWS_ACCOUNT
  export AWS_ACCESS_KEY_ID=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .awsAccessKeyId)
  echo $AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .AwsSecretAccessKey)
  echo $AWS_SECRET_ACCESS_KEY
  export DEV_KEY=$(aws ssm get-parameter --name "cloud-temp-dev" | jq .Parameter.Value | jq -r . | jq .ApiKey)
  echo $DEV_KEY
  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "STAGE=dev" \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "BRANCH=${BUILDKITE_BRANCH}" \
    --build-arg "AWS_ACCOUNT=${AWS_ACCOUNT}" \
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