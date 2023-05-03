#!/bin/bash

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "SLS_ACCESS_KEY_ID=${SLS_ACCESS_KEY_ID}" \
    --build-arg "SLS_SECRET_ACCESS_KEY=${SLS_SECRET_ACCESS_KEY}" .
else
  docker build \
    -f Dockerfile-test \
    --tag cloud-template-deploy \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "SLS_ACCESS_KEY_ID=${SLS_ACCESS_KEY_ID}" \
    --build-arg "SLS_SECRET_ACCESS_KEY=${SLS_SECRET_ACCESS_KEY}" \
    --build-arg "BRANCH=${BUILDKITE_BRANCH}" .
fi

docker run \
  cloud-template-deploy bundle exec rake

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
  docker run \
    --mount type=bind,source="$(pwd)"/serverless.yml,target=/app/serverless.yml \
    cloud-template-deploy bundle exec rake deploy_prod
else
  docker run \
    --mount type=bind,source=/Users/kyleswaffield/docker/serverless.yml,target=/app/serverless.yml \
    cloud-template-deploy bundle exec rake deploy_dev
fi