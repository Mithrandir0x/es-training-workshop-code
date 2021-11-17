#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

# echo "Get cardinality of domains per client and DNS provider"

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
            "field": "data.data.command.client.name.keyword",
            "size": 10
          },
          "aggs": {
            "per_domain": {
              "cardinality": {
                "field": "data.data.command.domain.keyword",
                "precision_threshold": 40000
              }
            }
          }
        }
      }
    }
  }
}' | jq -r -f 12.csv_filter_unique_domains.jq
