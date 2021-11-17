#!/usr/bin/env bash

set -e

ES_HOST="http://127.0.0.1:9200"
TMP_PATH=/tmp
TAR_PATH=$TMP_PATH/export_es_course_mtr-fixed_metrics-domain_validator

tar -zxvf resources/export_es_course_mtr-fixed_metrics-domain_validator.tar.gz -C $TMP_PATH

curl -s -XPUT -H 'Content-Type: application/json' "$ES_HOST/_template/template_sample_metrics?pretty" -d'
{
  "index_patterns": ["sample_metrics-domain_validator"],
  "settings": {
    "number_of_shards": 5,
    "number_of_replicas" : 0
  }
}
'

echo "Created index template [template_sample_metrics]"

for FILE in $(ls $TAR_PATH); do
    curl -s -XPOST "$ES_HOST/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary @$TAR_PATH/$FILE
    echo "Imported successfully [$TAR_PATH/$FILE]"
done

# if you want to accelerate importation a bit:
# 
# ls -d $TAR_PATH/* | xargs -I {} -P 8 curl -s -XPOST "$ES_HOST/_bulk?pretty" -H 'Content-Type: application/x-ndjson' --data-binary @{}

rm -rf $TAR_PATH
echo "Imported dataset [sample_metrics-domain_validator] successfully."
