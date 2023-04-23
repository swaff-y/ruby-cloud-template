#!/bin/bash

docker build --tag cloud-template .

docker run --rm cloud-template bundle exec rake