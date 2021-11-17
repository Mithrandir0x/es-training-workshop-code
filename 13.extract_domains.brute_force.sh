#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

# echo "Get cardinality of domains per client and DNS provider"

curl -s -XPUT -H 'Content-Type: application/json' "$ES_HOST/_cluster/settings?pretty&flat_settings=true" -d'
{
  "persistent": {
    "search.max_buckets": 500000
  }
}
' > /dev/null

# you need to update cluster settings to make this work

curl -s -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
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
        "per_client": {
          "terms": {
            "field": "data.data.command.client.name.keyword"
          },
          "aggs": {
            "per_domain": {
              "terms": {
                "field": "data.data.command.domain.keyword",
                "size": 200000
              },
              "aggs": {
                "max_latency" : { "max" : { "field" : "data.data.latency" } },
                "min_latency" : { "min" : { "field" : "data.data.latency" } },
                "avg_latency" : { "avg" : { "field" : "data.data.latency" } }
              }
            }
          }
        }
      }
    }
  }
}' | jq -r -f 13.csv_filter_domains.brute_force.jq
