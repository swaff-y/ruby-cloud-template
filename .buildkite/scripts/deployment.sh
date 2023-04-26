#!/bin/bash

if [ "$BUILDKITE_BRANCH" == "main"  ]
then
    docker build \
    -f Dockerfile-deploy-dev \
    --tag cloud-template-deploy \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "SLS_ACCESS_KEY_ID=${SLS_ACCESS_KEY_ID}" \
    --build-arg "SLS_SECRET_ACCESS_KEY=${SLS_SECRET_ACCESS_KEY}" \
    --build-arg "BRANCH=${BUILDKITE_BRANCH}" .
else
  docker build \
    -f Dockerfile-deploy-prod \
    --tag cloud-template-deploy \
    --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
    --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
    --build-arg "SLS_ACCESS_KEY_ID=${SLS_ACCESS_KEY_ID}" \
    --build-arg "SLS_SECRET_ACCESS_KEY=${SLS_SECRET_ACCESS_KEY}" .
fi

docker run --rm cloud-template-deploy sls deploy