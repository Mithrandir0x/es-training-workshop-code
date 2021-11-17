#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Get DNS providers being used to resolve domains and get the minimum, maxmimum and average of latencies"

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "query": {
    "match": {
      "data.data.cause.keyword": "Failed to resolve DNS records for domain due to no record available."
    }
  },
  "aggs": {
    "per_dns_provider": {
      "terms": {
        "field": "data.data.dns.name.keyword"
      },
      "aggs": {
        "max_latency" : { "max" : { "field" : "data.data.latency" } },
        "min_latency" : { "min" : { "field" : "data.data.latency" } },
        "avg_latency" : { "avg" : { "field" : "data.data.latency" } }
      }
    }
  }
}'
