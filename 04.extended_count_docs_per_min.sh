#!/usr/bin/env bash

ES_HOST="http://127.0.0.1:9200"

echo "Time span from index"

# Please, refer to the following link for more information about date histogram aggregations:
#
#     https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-datehistogram-aggregation.html
#
# Also, do note that it is required to execute '02.index_time_range.sh' to know which
# boundaries are suitable for the interval set in the 'date_histogram' aggregation.
# 

curl -XPOST -H 'Content-Type: application/json' "$ES_HOST/sample_metrics-domain_validator/_search?pretty" -d'
{
  "size": 0,
  "aggs": {
    "per_half_hour": {
      "date_histogram": {
        "field": "data.ts",
        "interval": "5m",
        "extended_bounds": {
          "min": "2019-10-07T12:00:00.000Z",
          "max": "2019-10-07T13:00:00.000Z"
        }
      }
    }
  }
}'
