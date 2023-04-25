#!/bin/bash

docker build -f Dockerfile-test --tag cloud-template .

docker run --rm cloud-template bundle exec rake