#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Get DNS providers being used to resolve domains and get a histogram about its latency"

# Please, refer to the following link for more information about terms aggregations:
#
#     https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-histogram-aggregation.html
#
# You can play with "interval" field to adjust buckets generated for each latency range.

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
        "latency_histogram": {
          "histogram": {
            "field": "data.data.latency",
            "interval": 10000
          }
        }
      }
    }
  }
}'
