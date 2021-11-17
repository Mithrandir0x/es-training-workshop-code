#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Sample of 5 documents"

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty&size=5"

# Alternatively, you could execute the following script:

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 5,
  "query": {
    "match_all": {}
  }
}'
