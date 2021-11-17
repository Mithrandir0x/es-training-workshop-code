#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Get list of clients processed"

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs": {
    "client_ids": {
      "terms": {
        "field": "data.data.command.client.name.keyword"
      }
    }
  }
}' | jq -r '.aggregations.client_ids.buckets[].key'
