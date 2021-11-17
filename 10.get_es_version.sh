#!/usr/bin/env bash

set -x

ES_HOST="http://127.0.0.1:9200"

# echo "Get Elasticsearch version with JQ"

curl -s -XGET -H 'Content-Type: application/json' "$ES_HOST" | jq -r '.version.number'
