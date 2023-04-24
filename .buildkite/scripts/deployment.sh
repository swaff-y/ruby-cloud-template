#!/bin/bash

docker build --tag cloud-template --build-arg "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" --build-arg "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" .

docker run --rm cloud-template bundle exec rake deploy_dev