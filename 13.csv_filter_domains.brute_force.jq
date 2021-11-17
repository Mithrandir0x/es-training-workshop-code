.aggregations.per_dns_provider.buckets[] as $dns_provider
| $dns_provider.per_client.buckets[] as $client
| $client.per_domain.buckets[] as $domain
| [ 
    $dns_provider.key, $client.key, $domain.key,
    $domain.min_latency.value, $domain.max_latency.value, $domain.avg_latency.value,
    $domain.doc_count
  ]
| @csv