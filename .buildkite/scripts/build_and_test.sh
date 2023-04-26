#!/bin/bash

docker build -f Dockerfile-test --tag cloud-template-test .

docker run --rm cloud-template-test bundle exec rake