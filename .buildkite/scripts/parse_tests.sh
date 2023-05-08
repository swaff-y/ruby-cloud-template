#!/bin/bash

set -e

buildkite-agent artifact download "postman_result" .
bundle exec rake postman