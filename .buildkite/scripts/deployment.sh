#!/bin/bash

docker build \
  -f Dockerfile-deploy \
  --tag cloud-template-deploy \
  --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
  --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
  --build-arg "BRANCH=${BUILDKITE_BRANCH}" \
  --build-arg "SLS_ACCESS_KEY_ID=${SLS_ACCESS_KEY_ID}" \
  --build-arg "SLS_SECRET_ACCESS_KEY=${SLS_SECRET_ACCESS_KEY}" .

docker run --rm cloud-template-deploy sls deploy