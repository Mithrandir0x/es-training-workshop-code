#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "All different kind of events in index"

# Please, refer to the following link for more information about terms aggregations:
#
#     https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html
#
# Why use "keyword" field?
# 
# When indexing documents in an index, by default, any string field will use the Keyword Tokenizer, thus indexing
# only the whole string, rather than performing any kind of decomposition (such as separating spaces, for example).
#
# You may look for more information about tokenizers at:
#
#     https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-keyword-tokenizer.html
#     https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-keyword-analyzer.html
#

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs" : {
    "per_cause": {
      "terms": { "field": "data.data.cause.keyword" }
    }
  }
}'
