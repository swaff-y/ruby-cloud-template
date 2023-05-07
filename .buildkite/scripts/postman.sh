#!/bin/bash

set -e

ls -la
      
export UNIQUE_ID=$(cat deploy_result | grep -m 1 execute-api | sed 's|^.*\/\/\(.*\)\.ex.*$|\1|g')

bundle exec rake set_unique_id

postman collection run postman_collection.json > postman_result

cat postman_result

bundle exec rake postman