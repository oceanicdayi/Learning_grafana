# Example Grafana Queries

A collection of commonly used queries for different data sources.

## MySQL / PostgreSQL Queries

### Time Series Data

#### Basic Time Series
```sql
SELECT
  timestamp AS time,
  value
FROM metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

#### Aggregated Time Series
```sql
SELECT
  $__timeGroup(timestamp, '5m') AS time,
  AVG(value) as avg_value,
  MAX(value) as max_value,
  MIN(value) as min_value
FROM metrics
WHERE $__timeFilter(timestamp)
GROUP BY time
ORDER BY time
```

#### Multiple Series
```sql
SELECT
  timestamp AS time,
  hostname as metric,
  cpu_usage as value
FROM system_metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

### Statistics

#### Current Value
```sql
SELECT
  COUNT(*) as 'Total Users'
FROM users
WHERE created_at >= NOW() - INTERVAL 24 HOUR
```

#### Percentage Calculation
```sql
SELECT
  ROUND(
    (SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) as 'Success Rate %'
FROM requests
WHERE $__timeFilter(timestamp)
```

#### Top N Query
```sql
SELECT
  page_url as 'Page',
  COUNT(*) as 'Views'
FROM page_views
WHERE $__timeFilter(timestamp)
GROUP BY page_url
ORDER BY Views DESC
LIMIT 10
```

### Complex Queries

#### Rate of Change
```sql
SELECT
  $__timeGroup(timestamp, '1m') as time,
  COUNT(*) / 60.0 as 'Requests per Second'
FROM requests
WHERE $__timeFilter(timestamp)
GROUP BY time
ORDER BY time
```

#### Moving Average
```sql
SELECT
  timestamp as time,
  value,
  AVG(value) OVER (
    ORDER BY timestamp
    ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING
  ) as moving_avg
FROM metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

#### Join Multiple Tables
```sql
SELECT
  r.timestamp as time,
  r.request_id,
  r.response_time,
  u.username,
  u.country
FROM requests r
JOIN users u ON r.user_id = u.id
WHERE $__timeFilter(r.timestamp)
  AND r.response_time > 1000
ORDER BY time DESC
LIMIT 100
```

## Prometheus Queries (PromQL)

### Basic Metrics

#### Instant Query
```promql
# Current CPU usage
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

#### Memory Usage
```promql
# Memory usage percentage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

#### Disk Usage
```promql
# Disk usage percentage
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

### Rate and Increase

#### HTTP Request Rate
```promql
# Requests per second
rate(http_requests_total[5m])
```

#### HTTP Request Rate by Status
```promql
# Requests per second by status code
sum by (status_code) (rate(http_requests_total[5m]))
```

#### Bytes Transmitted
```promql
# Network bytes per second
rate(node_network_transmit_bytes_total[5m])
```

### Aggregation

#### Average by Label
```promql
# Average response time by endpoint
avg by (endpoint) (http_request_duration_seconds)
```

#### Sum by Instance
```promql
# Total requests by instance
sum by (instance) (rate(http_requests_total[5m]))
```

#### Max by Service
```promql
# Maximum latency by service
max by (service) (http_request_duration_seconds)
```

### Percentiles

#### 95th Percentile Latency
```promql
histogram_quantile(0.95, 
  rate(http_request_duration_seconds_bucket[5m])
)
```

#### Multiple Percentiles
```promql
# P50, P90, P95, P99
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.90, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

### Calculations

#### Error Rate
```promql
# Percentage of failed requests
sum(rate(http_requests_total{status=~"5.."}[5m])) / 
sum(rate(http_requests_total[5m])) * 100
```

#### Available Memory
```promql
# Free memory in GB
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

#### Disk Growth Rate
```promql
# Disk growth in GB per hour
rate(node_filesystem_avail_bytes[1h]) * 3600 / 1024 / 1024 / 1024
```

### Advanced Queries

#### Prediction
```promql
# Predict when disk will be full (in seconds)
predict_linear(
  node_filesystem_avail_bytes{mountpoint="/"}[1h], 
  4 * 3600
)
```

#### Delta (Absolute Change)
```promql
# Absolute change in last hour
delta(node_network_transmit_bytes_total[1h])
```

#### Counter Resets
```promql
# Detect counter resets
resets(node_network_transmit_bytes_total[1h])
```

## InfluxDB Queries (InfluxQL)

### Basic Queries

#### Select Recent Data
```influxql
SELECT 
  mean("value") 
FROM "cpu" 
WHERE 
  $timeFilter 
GROUP BY time($__interval), "host"
```

#### Multiple Fields
```influxql
SELECT 
  mean("cpu_usage") as "CPU",
  mean("memory_usage") as "Memory"
FROM "system_metrics"
WHERE $timeFilter
GROUP BY time($__interval)
```

### Aggregations

#### Average Over Time
```influxql
SELECT 
  mean("response_time") 
FROM "http_requests" 
WHERE $timeFilter 
GROUP BY time(5m)
```

#### Sum by Tag
```influxql
SELECT 
  sum("bytes") 
FROM "network_traffic" 
WHERE $timeFilter 
GROUP BY time(1m), "interface"
```

### Window Functions

#### Moving Average
```influxql
SELECT 
  moving_average(mean("value"), 10)
FROM "cpu"
WHERE $timeFilter
GROUP BY time(1m)
```

#### Difference
```influxql
SELECT 
  difference(mean("counter"))
FROM "metrics"
WHERE $timeFilter
GROUP BY time(1m)
```

## Elasticsearch Queries

### Log Count
```json
{
  "query": {
    "bool": {
      "filter": [
        { "range": { "@timestamp": { "gte": "now-1h" } } },
        { "term": { "level": "error" } }
      ]
    }
  }
}
```

### Aggregation by Field
```json
{
  "aggs": {
    "by_status": {
      "terms": {
        "field": "status_code",
        "size": 10
      }
    }
  }
}
```

### Time Series Histogram
```json
{
  "aggs": {
    "requests_over_time": {
      "date_histogram": {
        "field": "@timestamp",
        "interval": "1m"
      }
    }
  }
}
```

## TestData Queries

TestData DB is built into Grafana - perfect for learning!

### Random Walk
```
Scenario: Random Walk
```
Generates realistic-looking time series data.

### Predictable CSV
```
Scenario: CSV Content
String Input: time,value
1,100
2,200
3,150
```

### USA Generated
```
Scenario: USA Generated
```
Generates data with geographic coordinates for the US.

## Variables in Queries

### Using Variables

#### Single Selection
```sql
SELECT * FROM metrics WHERE server = '$server'
```

#### Multiple Selection
```sql
SELECT * FROM metrics WHERE server IN ($server)
```

#### All Option
```sql
SELECT * FROM metrics WHERE 
  ('$server' = 'All' OR server = '$server')
```

### Variable Queries

#### Get Server List (MySQL)
```sql
SELECT DISTINCT hostname as __text, hostname as __value
FROM system_metrics
ORDER BY hostname
```

#### Get Metric Names (Prometheus)
```promql
label_values(node_cpu_seconds_total, instance)
```

#### Chained Variables (MySQL)
```sql
-- Variable: region
SELECT DISTINCT region FROM servers

-- Variable: server (depends on region)
SELECT hostname FROM servers WHERE region = '$region'
```

## Best Practices

### 1. Always Use Time Filters
```sql
-- Good
WHERE $__timeFilter(timestamp)

-- Bad
WHERE timestamp > '2024-01-01'
```

### 2. Use Appropriate Intervals
```sql
-- For long time ranges, use larger intervals
GROUP BY $__timeGroup(timestamp, '1h')

-- For short time ranges, use smaller intervals
GROUP BY $__timeGroup(timestamp, '1m')
```

### 3. Limit Result Sets
```sql
-- Always limit table queries
LIMIT 1000

-- Use TOP N for rankings
ORDER BY value DESC LIMIT 10
```

### 4. Use Indexes
```sql
-- Create indexes on frequently queried columns
CREATE INDEX idx_timestamp ON metrics(timestamp);
CREATE INDEX idx_hostname ON metrics(hostname);
```

### 5. Test Queries
- Test in query editor first
- Check query execution time
- Verify results make sense
- Test with different time ranges

### 6. Document Queries
```sql
-- Purpose: Show top 10 slowest API endpoints
-- Updated: 2024-01-15
-- Owner: DevOps Team
SELECT 
  endpoint,
  AVG(response_time) as avg_time
FROM api_logs
WHERE $__timeFilter(timestamp)
GROUP BY endpoint
ORDER BY avg_time DESC
LIMIT 10
```

## Query Optimization Tips

### MySQL/PostgreSQL
- Use EXPLAIN to analyze queries
- Add indexes on WHERE and JOIN columns
- Use LIMIT to restrict results
- Use appropriate GROUP BY intervals
- Consider materialized views for complex queries

### Prometheus
- Use recording rules for complex queries
- Avoid large time ranges with small steps
- Use label selectors to reduce data
- Aggregate before calculating (sum then rate vs rate then sum)

### InfluxDB
- Use appropriate retention policies
- Downsample old data
- Use continuous queries for aggregations
- Index tags, not fields

## Troubleshooting

### Query Returns No Data
- Check time range
- Verify data exists
- Check column names
- Test query outside Grafana

### Query Too Slow
- Add database indexes
- Reduce time range
- Increase group interval
- Use aggregation
- Check data source load

### Query Error
- Check syntax
- Verify column names exist
- Check data types
- Review Grafana logs

---

For more examples, see:
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [MySQL Query Optimization](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
