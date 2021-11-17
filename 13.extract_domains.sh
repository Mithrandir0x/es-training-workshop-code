#!/usr/bin/env bash

set -e

ES_HOST="http://127.0.0.1:9200"
TMP_FILE=/tmp/unique_domains.csv
TMP_KEY_FILE=/tmp/query_key.json
TMP_KEYS_FILE=/tmp/keys.json

# echo "Get cardinality of domains per client and DNS provider"

DATA=$(curl -s -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "query": {
    "match": {
      "data.data.cause.keyword": "Failed to resolve DNS records for domain due to no record available."
    }
  },
  "aggs": {
    "composite_buckets": {
      "composite": {
        "size": 10000, 
        "sources": [
          { "dns_provider": { "terms": { "field": "data.data.dns.name.keyword" } } },
          { "client": { "terms": { "field": "data.data.command.client.name.keyword" } } },
          { "domain": { "terms": { "field": "data.data.command.domain.keyword" } } }
        ]
      },
      "aggregations": {
        "max_latency" : { "max" : { "field" : "data.data.latency" } },
        "min_latency" : { "min" : { "field" : "data.data.latency" } },
        "avg_latency" : { "avg" : { "field" : "data.data.latency" } }
      }
    }
  }
}')

echo $DATA | jq -r -f 13.csv_filter_domains.jq > $TMP_FILE
echo $DATA | jq -r '.aggregations.composite_buckets.after_key' | tr -d '\n' > $TMP_KEY_FILE
cat $TMP_KEY_FILE > $TMP_KEYS_FILE
echo '' >> $TMP_KEYS_FILE

# echo "Extracted [$(cat $TMP_FILE | wc -l)] domains. Next key: $(cat $TMP_KEY_FILE)"

while [[ -s $TMP_KEY_FILE ]] && [[ "$(cat $TMP_KEY_FILE)" != "null" ]]; do

DATA=`curl -s -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d@- << EOF
{
  "size": 0,
  "query": {
    "match": {
      "data.data.cause.keyword": "Failed to resolve DNS records for domain due to no record available."
    }
  },
  "aggs": {
    "composite_buckets": {
      "composite": {
        "size": 10000, 
        "sources": [
          { "dns_provider": { "terms": { "field": "data.data.dns.name.keyword" } } },
          { "client": { "terms": { "field": "data.data.command.client.name.keyword" } } },
          { "domain": { "terms": { "field": "data.data.command.domain.keyword" } } }
        ],
        "after": $(cat $TMP_KEY_FILE)
      },
      "aggregations": {
        "max_latency" : { "max" : { "field" : "data.data.latency" } },
        "min_latency" : { "min" : { "field" : "data.data.latency" } },
        "avg_latency" : { "avg" : { "field" : "data.data.latency" } }
      }
    }
  }
}
EOF`

echo $DATA | jq -r -f 13.csv_filter_domains.jq >> $TMP_FILE
echo $DATA | jq -r '.aggregations.composite_buckets.after_key' | tr -d '\n' > $TMP_KEY_FILE
cat $TMP_KEY_FILE >> $TMP_KEYS_FILE
echo '' >> $TMP_KEYS_FILE

# echo "Extracted [$(cat $TMP_FILE | wc -l)] domains. Next key: $(cat $TMP_KEY_FILE)"

done

cat $TMP_FILE
rm $TMP_KEYS_FILE $TMP_FILE $TMP_KEY_FILE
