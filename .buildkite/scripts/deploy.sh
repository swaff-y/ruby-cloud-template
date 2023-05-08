#!/bin/bash

set -e

rm serverless.yml
buildkite-agent artifact download "Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml" .
cp Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/serverless.yml .
npm install
bundle install --without development test
bundle exec rake aws_login
sls deploy > deploy_result
cat deploy_result