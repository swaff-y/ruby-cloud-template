#!/bin/bash

set -e

rm postman_collection.json
buildkite-agent artifact download "deploy_result" .
buildkite-agent artifact download "Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json" .
cp Users/kyleswaffield/docker/${BUILDKITE_PIPELINE_NAME}/${BUILDKITE_BRANCH}/postman_collection.json .
bundle install --without development test
export UNIQUE_ID=  
export UNIQUE_ID=$(cat deploy_result | grep -m 1 execute-api | sed 's|^.*\/\/\(.*\)\.ex.*$|\1|g')
if [ "$UNIQUE_ID" == ""  ]
then
  export UNIQUE_ID=$(cat deploy_result | grep 'already associated' | sed 's|^.*Api \(.*\) already.*$|\1|g')
fi
bundle exec rake set_unique_id
postman collection run postman_collection.json > postman_result
cat postman_result
bundle exec rake postman