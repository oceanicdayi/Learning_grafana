# Grafana 查詢範例

整理常見資料來源的查詢範例，方便直接套用或改寫。

## MySQL / PostgreSQL 查詢

### 時間序列資料

#### 基本時間序列
```sql
SELECT
  timestamp AS time,
  value
FROM metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

#### 聚合時間序列
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

#### 多序列
```sql
SELECT
  timestamp AS time,
  hostname as metric,
  cpu_usage as value
FROM system_metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

### 統計類

#### 目前數值
```sql
SELECT
  COUNT(*) as 'Total Users'
FROM users
WHERE created_at >= NOW() - INTERVAL 24 HOUR
```

#### 百分比計算
```sql
SELECT
  ROUND(
    (SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) as 'Success Rate %'
FROM requests
WHERE $__timeFilter(timestamp)
```

#### Top N
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

### 複雜查詢

#### 變化率
```sql
SELECT
  $__timeGroup(timestamp, '1m') as time,
  COUNT(*) / 60.0 as 'Requests per Second'
FROM requests
WHERE $__timeFilter(timestamp)
GROUP BY time
ORDER BY time
```

#### 移動平均
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

#### 多表 Join
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

#### 錯誤率趨勢（補充）
```sql
SELECT
  $__timeGroup(timestamp, '10m') as time,
  ROUND(SUM(CASE WHEN level = 'ERROR' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as error_rate
FROM application_logs
WHERE $__timeFilter(timestamp)
GROUP BY time
ORDER BY time
```

## Prometheus 查詢（PromQL）

### 基本指標

#### 即時查詢
```promql
# 目前 CPU 使用率
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

#### 記憶體使用率
```promql
# 記憶體使用百分比
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

#### 磁碟使用率
```promql
# 磁碟使用百分比
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

### Rate 與 Increase

#### HTTP 請求速率
```promql
# 每秒請求數
rate(http_requests_total[5m])
```

#### HTTP 請求速率（依狀態碼）
```promql
# 依狀態碼計算請求速率
sum by (status_code) (rate(http_requests_total[5m]))
```

#### 網路傳輸量
```promql
# 每秒傳輸位元組
rate(node_network_transmit_bytes_total[5m])
```

### 聚合

#### 依標籤平均
```promql
# 依 endpoint 平均回應時間
avg by (endpoint) (http_request_duration_seconds)
```

#### 依 instance 加總
```promql
# 依 instance 計算總請求
sum by (instance) (rate(http_requests_total[5m]))
```

#### 依服務取最大值
```promql
# 依 service 取最大延遲
max by (service) (http_request_duration_seconds)
```

### 百分位

#### 95 百分位延遲
```promql
histogram_quantile(0.95, 
  rate(http_request_duration_seconds_bucket[5m])
)
```

#### 多百分位
```promql
# P50, P90, P95, P99
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.90, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) or
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

### 計算

#### 錯誤率
```promql
# 失敗請求百分比
sum(rate(http_requests_total{status=~"5.."}[5m])) / 
sum(rate(http_requests_total[5m])) * 100
```

#### 可用記憶體
```promql
# 可用記憶體（GB）
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

#### 磁碟成長速率
```promql
# 每小時磁碟容量變化（GB）
rate(node_filesystem_avail_bytes[1h]) * 3600 / 1024 / 1024 / 1024
```

### 進階查詢

#### 預測
```promql
# 預測磁碟剩餘時間（秒）
predict_linear(
  node_filesystem_avail_bytes{mountpoint="/"}[1h], 
  4 * 3600
)
```

#### Delta（絕對變化）
```promql
# 最近一小時絕對變化
delta(node_network_transmit_bytes_total[1h])
```

#### Counter 重置
```promql
# 偵測 counter 重置
resets(node_network_transmit_bytes_total[1h])
```

## InfluxDB 查詢（InfluxQL）

### 基本查詢

#### 取得近期資料
```influxql
SELECT 
  mean("value") 
FROM "cpu" 
WHERE 
  $timeFilter 
GROUP BY time($__interval), "host"
```

#### 多欄位
```influxql
SELECT 
  mean("cpu_usage") as "CPU",
  mean("memory_usage") as "Memory"
FROM "system_metrics"
WHERE $timeFilter
GROUP BY time($__interval)
```

### 聚合

#### 平均值
```influxql
SELECT 
  mean("response_time") 
FROM "http_requests" 
WHERE $timeFilter 
GROUP BY time(5m)
```

#### 依 Tag 加總
```influxql
SELECT 
  sum("bytes") 
FROM "network_traffic" 
WHERE $timeFilter 
GROUP BY time(1m), "interface"
```

### 視窗函式

#### 移動平均
```influxql
SELECT 
  moving_average(mean("value"), 10)
FROM "cpu"
WHERE $timeFilter
GROUP BY time(1m)
```

#### 差分
```influxql
SELECT 
  difference(mean("counter"))
FROM "metrics"
WHERE $timeFilter
GROUP BY time(1m)
```

## Elasticsearch 查詢

### 錯誤數量
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

### 依欄位聚合
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

### 時間序列統計
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

## TestData 查詢

TestData DB 為 Grafana 內建資料來源，適合學習！

### Random Walk
```
Scenario: Random Walk
```
產生類似真實指標的時間序列。

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
產生帶有美國地理座標的資料。

## Loki 查詢（LogQL）

### 錯誤日誌
```logql
{job="api"} |= "error"
```

### 每分鐘錯誤數
```logql
sum by (level) (rate({job="api"} |= "error" [5m]))
```

## 查詢中的變數

### 使用變數

#### 單選
```sql
SELECT * FROM metrics WHERE server = '$server'
```

#### 多選
```sql
SELECT * FROM metrics WHERE server IN ($server)
```

#### 全選
```sql
SELECT * FROM metrics WHERE 
  ('$server' = 'All' OR server = '$server')
```

### 變數查詢

#### 取得伺服器清單（MySQL）
```sql
SELECT DISTINCT hostname as __text, hostname as __value
FROM system_metrics
ORDER BY hostname
```

#### 取得指標名稱（Prometheus）
```promql
label_values(node_cpu_seconds_total, instance)
```

#### 連鎖變數（MySQL）
```sql
-- 變數：region
SELECT DISTINCT region FROM servers

-- 變數：server（依 region 篩選）
SELECT hostname FROM servers WHERE region = '$region'
```

## 最佳實務

### 1. 一定要使用時間範圍
```sql
-- 正確
WHERE $__timeFilter(timestamp)

-- 錯誤
WHERE timestamp > '2024-01-01'
```

### 2. 使用合適的區間
```sql
-- 長時間範圍使用較大區間
GROUP BY $__timeGroup(timestamp, '1h')

-- 短時間範圍使用較小區間
GROUP BY $__timeGroup(timestamp, '1m')
```

### 3. 限制結果
```sql
-- 表格查詢限制筆數
LIMIT 1000

-- 取前 N 名
ORDER BY value DESC LIMIT 10
```

### 4. 使用索引
```sql
-- 針對常用欄位建立索引
CREATE INDEX idx_timestamp ON metrics(timestamp);
CREATE INDEX idx_hostname ON metrics(hostname);
```

### 5. 測試查詢
- 先在查詢編輯器測試
- 檢查查詢耗時
- 驗證結果合理性
- 用不同時間範圍測試

### 6. 記錄查詢用途
```sql
-- 目的：顯示最慢 API 端點
-- 更新：2024-01-15
-- 負責人：DevOps Team
SELECT 
  endpoint,
  AVG(response_time) as avg_time
FROM api_logs
WHERE $__timeFilter(timestamp)
GROUP BY endpoint
ORDER BY avg_time DESC
LIMIT 10
```

## 查詢效能建議

### MySQL/PostgreSQL
- 使用 EXPLAIN 分析查詢
- 在 WHERE/JOIN 欄位加索引
- 使用 LIMIT
- 調整 GROUP BY 間隔
- 需要時可使用物化檢視

### Prometheus
- 為複雜查詢建立 recording rules
- 避免使用太小 step 搭配大時間範圍
- 以 label selector 減少資料量
- 先聚合再計算更有效率

### InfluxDB
- 設定保留策略
- 降採樣舊資料
- 使用連續查詢做聚合
- 索引 tag 而不是 field

## 疑難排解

### 查詢沒有資料
- 檢查時間範圍
- 確認資料存在
- 檢查欄位名稱
- 於資料庫端測試查詢

### 查詢太慢
- 建立索引
- 縮小時間範圍
- 放大 group interval
- 使用聚合
- 檢查資料來源負載

### 查詢錯誤
- 檢查語法
- 確認欄位存在
- 檢查資料型別
- 檢查 Grafana 日誌

---

更多範例可參考：
- [Grafana 文件](https://grafana.com/docs/)
- [PromQL 入門](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [MySQL 查詢最佳化](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
