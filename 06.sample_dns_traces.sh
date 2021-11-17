#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Sample of 5 documents for DNS-related issues"

# Please, use '05.kind_events.sh' to know about different kind of traces available.

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "_source": "data.data", 
  "size": 5,
  "query": {
    "bool": {
      "should": [
        { "match": { "data.data.cause.keyword": "Failed to resolve DNS records for domain due to no record available." } },
        { "match": { "data.data.cause.keyword": "Resolved successfully DNS records for domain." } }
      ]
    }
  }
}'
