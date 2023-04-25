#!/bin/bash

docker build -f Dockerfile-deploy --tag cloud-template --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" --build-arg "BRANCH=${BUILDKITE_BRANCH}" .

docker run --rm cloud-template bundle exec rake deploy_dev