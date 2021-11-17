#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Number of documents in index [sample_metrics-domain_validator]"

curl -XGET -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_count?pretty"
