.aggregations.per_dns_provider.buckets[] as $dns_provider
| $dns_provider.per_client.buckets[] as $client
| [ $dns_provider.key, $client.key, $client.doc_count, $client.per_domain.value ]
| @csv
