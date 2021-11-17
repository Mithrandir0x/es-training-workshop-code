.aggregations.composite_buckets.buckets[] as $r
| [
    $r.key.dns_provider, $r.key.client, $r.key.domain,
    $r.min_latency.value, $r.max_latency.value, $r.avg_latency.value,
    $r.doc_count
  ]
| @csv