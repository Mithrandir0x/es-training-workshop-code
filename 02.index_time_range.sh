#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Time span from index"

# You can fetch each value with a different aggregation each time

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs" : {
    "min_ts" : { "min" : { "field" : "data.ts" } }
  }
}'

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs" : {
    "max_ts" : { "max" : { "field" : "data.ts" } }
  }
}'

# You can fetch both values by asking both aggregations on the same query

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs" : {
    "max_ts" : { "max" : { "field" : "data.ts" } },
    "min_ts" : { "min" : { "field" : "data.ts" } }
  }
}'
