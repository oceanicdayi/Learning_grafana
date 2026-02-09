# 逐步教學：建立你的第一個 Grafana 儀表板

本教學將帶你完成完整儀表板建置流程，從環境啟動到儀表板分享。

## 先決條件

- 已安裝 Docker 與 Docker Compose
- 具備基本 SQL 概念（資料庫範例會用到）
- 可用的瀏覽器與網路環境

## Part 1：環境設定

### Step 1：啟動服務

```bash
# 取得專案
git clone https://github.com/oceanicdayi/Learning_grafana.git
cd Learning_grafana

# 啟動所有服務
docker-compose up -d

# 確認服務狀態
docker-compose ps
```

預期輸出：
```
NAME            IMAGE                         STATUS
grafana         grafana/grafana:latest        Up
mysql           mysql:8.0                     Up
prometheus      prom/prometheus:latest        Up
node-exporter   prom/node-exporter:latest     Up
```

### Step 2：進入 Grafana

1. 開啟瀏覽器：`http://localhost:3000`
2. 登入資訊：
   - 帳號：`admin`
   - 密碼：`admin`
3. 依提示更改密碼（可先略過）

## Part 2：確認預設資料來源

### Step 1：檢查資料來源

1. 點擊 ⚙️（Configuration）→ Data Sources
2. 應看到：
   - ✅ Prometheus（預設）
   - ✅ MySQL Demo

### Step 2：測試連線

1. 依序點擊資料來源
2. 滾動到最底部
3. 點擊「Save & test」
4. 確認出現綠色成功訊息

## Part 3：建立第一個儀表板

### 儀表板 1：Prometheus 系統監控

#### Step 1：建立新儀表板

1. 點擊 + → Dashboard
2. 點擊「Add new panel」

#### Step 2：CPU 使用率面板

**設定：**
- **資料來源**：Prometheus
- **查詢**：
  ```promql
  100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
  ```
- **面板標題**：CPU 使用率
- **視覺化**：Gauge
- **單位**：Percent (0-100)
- **閾值**：
  - 綠色：0-70
  - 黃色：70-85
  - 紅色：85-100

#### Step 3：記憶體使用率面板

1. 點擊「Add panel」→「Add new panel」

**設定：**
- **資料來源**：Prometheus
- **查詢**：
  ```promql
  (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
  ```
- **面板標題**：記憶體使用率
- **視覺化**：Gauge
- **單位**：Percent (0-100)
- **閾值**：
  - 綠色：0-70
  - 黃色：70-90
  - 紅色：90-100

#### Step 4：網路流量面板

1. 點擊「Add panel」→「Add new panel」

**設定：**
- **資料來源**：Prometheus
- **Query A**（Inbound）：
  ```promql
  rate(node_network_receive_bytes_total[5m])
  ```
- **Query B**（Outbound）：
  ```promql
  rate(node_network_transmit_bytes_total[5m])
  ```
- **面板標題**：網路流量
- **視覺化**：Time series
- **單位**：bytes/sec

#### Step 5：儲存儀表板

1. 點擊 💾（Save dashboard）
2. 命名：「系統監控」
3. 點擊「Save」

### 儀表板 2：MySQL 網站分析

#### Step 1：建立新儀表板

1. 點擊 + → Dashboard
2. 點擊「Add new panel」

#### Step 2：今日瀏覽量

**設定：**
- **資料來源**：MySQL Demo
- **查詢**：
  ```sql
  SELECT 
    COUNT(*) as 'Page Views'
  FROM page_views
  WHERE DATE(timestamp) = CURDATE()
  ```
- **面板標題**：今日瀏覽量
- **視覺化**：Stat
- **顏色**：藍色
- **Graph mode**：None

#### Step 3：瀏覽量趨勢

1. 新增面板

**設定：**
- **資料來源**：MySQL Demo
- **查詢**：
  ```sql
  SELECT
    timestamp as time,
    COUNT(*) as value
  FROM page_views
  WHERE $__timeFilter(timestamp)
  GROUP BY DATE(timestamp), HOUR(timestamp)
  ORDER BY time
  ```
- **Format**：Time series
- **面板標題**：瀏覽量趨勢
- **視覺化**：Time series

#### Step 4：熱門頁面

1. 新增面板

**設定：**
- **資料來源**：MySQL Demo
- **查詢**：
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
- **Format**：Table
- **面板標題**：熱門 10 頁面
- **視覺化**：水平長條圖

#### Step 5：平均回應時間

1. 新增面板

**設定：**
- **資料來源**：MySQL Demo
- **查詢**：
  ```sql
  SELECT
    AVG(response_time) as 'Avg Response Time'
  FROM page_views
  WHERE $__timeFilter(timestamp)
  ```
- **面板標題**：平均回應時間
- **視覺化**：Stat
- **單位**：milliseconds (ms)
- **閾值**：
  - 綠色：0-100
  - 黃色：100-200
  - 紅色：200+

#### Step 6：錯誤日誌表

1. 新增面板

**設定：**
- **資料來源**：MySQL Demo
- **查詢**：
  ```sql
  SELECT
    timestamp as 'Time',
    level as 'Level',
    service as 'Service',
    message as 'Message',
    error_code as 'Code'
  FROM application_logs
  WHERE level IN ('ERROR', 'WARN')
    AND $__timeFilter(timestamp)
  ORDER BY timestamp DESC
  LIMIT 50
  ```
- **Format**：Table
- **面板標題**：最近錯誤與警告
- **視覺化**：Table

#### Step 7：整理面板布局

1. 拖曳面板排列
2. 拖曳角落調整尺寸
3. 建議版面：
   ```
   Row 1: [今日瀏覽量] [平均回應時間]
   Row 2: [瀏覽量趨勢 - 全寬]
   Row 3: [熱門 10 頁面 - 全寬]
   Row 4: [最近錯誤與警告 - 全寬]
   ```

#### Step 8：儲存儀表板

1. 點擊 💾 Save dashboard
2. 命名：「網站分析」
3. 點擊「Save」

## Part 4：自訂儀表板

### 加入時間範圍控制

1. 點擊 ⚙️（Dashboard settings）
2. 進入「Time options」
3. 設定：
   - **Timezone**：Browser time
   - **Auto refresh**：30s, 1m, 5m, 15m, 30m, 1h
   - **Default time range**：Last 24 hours

### 新增變數（篩選）

1. 點擊 ⚙️（Dashboard settings）
2. 進入「Variables」
3. 點擊「Add variable」

**變數 1：伺服器選擇**
- **Name**：server
- **Type**：Query
- **Data Source**：MySQL Demo
- **Query**：
  ```sql
  SELECT DISTINCT hostname FROM system_metrics
  ```
- **Multi-value**：Yes
- **Include All option**：Yes

**在查詢中使用**：
```sql
WHERE hostname IN ($server)
```

### 加入面板連結

1. 編輯面板
2. 進入「Panel options」區塊
3. 新增連結：
   - **Title**：查看日誌
   - **URL**：`/d/logs-dashboard`

### 額外補充：命名與描述

- 給儀表板與面板清楚名稱
- 在面板描述補上資料來源與用途
- 可在「Notes」欄位寫上維護者與更新日期

## Part 5：告警（可選）

### 建立告警規則

1. 編輯面板（如 CPU 使用率）
2. 進入「Alert」分頁
3. 點擊「Create alert rule from this panel」

**告警設定：**
- **Name**：High CPU Usage
- **Condition**：WHEN avg() OF query(A) IS ABOVE 85
- **For**：5m
- **Annotations**：
  - Summary：CPU 使用率超過 85%
  - Description：請檢查系統負載與程序

### 設定通知管道

1. 進入 Alerting → Contact points
2. 新增聯絡方式：
   - **Name**：Email
   - **Type**：Email
   - **Addresses**：your-email@example.com

## Part 6：分享儀表板

### 方式 1：公開儀表板

1. 開啟儀表板
2. 點擊 🔗（Share）→ Public dashboard
3. 啟用公開儀表板
4. 複製公開 URL
5. 分享給任何人（不需登入）

### 方式 2：Snapshot

1. 開啟儀表板
2. 點擊 🔗（Share）→ Snapshot
3. 設定到期時間
4. 發佈至 snapshots.raintank.io
5. 分享 Snapshot URL

### 方式 3：匯出 JSON

1. 點擊 ⚙️（Dashboard settings）
2. 進入「JSON Model」
3. 複製 JSON
4. 分享或匯入到其他 Grafana

## Part 7：匯入社群儀表板

Grafana 社群提供大量現成儀表板：

### 匯入 Node Exporter 儀表板

1. 點擊 + → Import
2. 輸入儀表板 ID：`1860`
3. 點擊「Load」
4. 選擇 Prometheus 資料來源
5. 點擊「Import」

**熱門儀表板 ID：**
- Node Exporter Full：1860
- MySQL Overview：7362
- Docker Monitoring：193
- Kubernetes Cluster：7249

## Part 8：進階技巧

### 範本變數

用變數建立可動態切換的儀表板：

```sql
-- 在面板查詢內
SELECT * FROM metrics WHERE hostname = '$hostname'

-- 多選
WHERE hostname IN ($hostname)

-- 時間範圍
WHERE timestamp >= $__timeFrom AND timestamp <= $__timeTo
```

### 轉換（Transformations）

處理查詢結果：

1. **Join by field**：合併多個查詢
2. **Filter by value**：篩選重要資料
3. **Calculate field**：新增計算欄位
4. **Organize fields**：欄位排序/隱藏

### 查詢快取

1. 編輯資料來源
2. 啟用「Query caching」
3. 設定快取時間
4. 適合經常使用的查詢

## 疑難排解

### 資料沒有顯示

✅ 檢查：
- 資料來源是否連線成功（Save & test）
- 查詢語法是否正確
- 時間範圍是否合適
- 該時間範圍內是否有資料

### 查詢太慢

✅ 解法：
- 使用時間範圍過濾：`$__timeFilter(timestamp)`
- 建立資料庫索引
- 限制結果筆數
- 使用聚合
- 啟用查詢快取

### 連線錯誤

✅ 檢查：
- 服務是否啟動：`docker-compose ps`
- 防火牆規則
- 網路連線
- 帳密是否正確

## 下一步

1. ✅ 嘗試更多視覺化類型
2. ✅ 為重要指標建立告警
3. ✅ 匯入社群儀表板
4. ✅ 連接自有資料來源
5. ✅ 探索 Grafana 外掛
6. ✅ 設定驗證（LDAP、OAuth）
7. ✅ 建立組織與團隊
8. ✅ 設定權限與分享策略

## 練習題

### 練習 1：銷售儀表板
- 連接含銷售資料的資料庫
- 顯示：總銷售額、區域銷售、熱門產品
- 使用：Stat、Bar chart、Pie chart

### 練習 2：伺服器監控儀表板
- 使用 Prometheus + Node Exporter
- 顯示：CPU、記憶體、磁碟、網路
- 設定關鍵閾值告警

### 練習 3：日誌分析儀表板
- 連接 Elasticsearch 或 MySQL 日誌
- 顯示：錯誤率、等級分布、最新錯誤
- 使用服務/嚴重度篩選

## 資源

- **文件**：https://grafana.com/docs/
- **社群儀表板**：https://grafana.com/grafana/dashboards/
- **教學**：https://grafana.com/tutorials/
- **社群論壇**：https://community.grafana.com/

---

**恭喜完成！🎉** 你已完成 Grafana 全流程教學！

你現在可以：
- 使用 Docker 部署 Grafana
- 連接資料來源
- 建立儀表板
- 使用多種視覺化
- 設定告警
- 分享儀表板

繼續練習、持續探索！
