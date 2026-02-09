# Grafana 學習指南

這是一份完整的 Grafana 學習指南，聚焦於資料視覺化與監控實務，從入門到進階都能循序學習並立即上手。

## 目錄

1. [什麼是 Grafana？](#什麼是-grafana)
2. [入門與安裝](#入門與安裝)
3. [連接資料來源](#連接資料來源)
4. [視覺化技巧](#視覺化技巧)
5. [建立儀表板](#建立儀表板)
6. [解析公開儀表板](#解析公開儀表板)
7. [最佳實務](#最佳實務)
8. [範例](#範例)
9. [延伸資源](#延伸資源)

## 什麼是 Grafana？

Grafana 是開源的分析與互動式視覺化平台，常用於監控、告警與報表展示。它提供：
- **資料視覺化**：把數據轉成易讀的圖表與指標
- **多資料來源支援**：可連接 Prometheus、InfluxDB、MySQL、PostgreSQL 等
- **告警與通知**：針對重要指標建立告警
- **儀表板分享**：快速分享給團隊或利害關係人
- **外掛生態系**：透過社群外掛擴充功能

### 主要特色
- 📊 多樣化視覺化（時間序列、圖表、熱力圖等）
- 🔌 支援超過 50 種資料來源
- 🎨 可客製化的互動式儀表板
- 🔔 內建告警與通知流程
- 👥 團隊協作與權限控管
- 🌐 公開儀表板分享

### 常見應用情境
- **基礎設施監控**：伺服器、Kubernetes、網路流量
- **應用程式效能**：API 延遲、錯誤率、交易成功率
- **商業指標**：營收、轉換率、活躍使用者
- **日誌分析**：搭配 Loki 或 Elasticsearch

## 入門與安裝

### 安裝方式

#### 1. Docker（建議學習使用）
```bash
# 在 Docker 中執行 Grafana
docker run -d -p 3000:3000 --name=grafana grafana/grafana

# 以 http://localhost:3000 存取
# 預設帳號密碼：admin/admin
```

#### 2. Docker Compose
```yaml
version: '3.8'
services:
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-storage:/var/lib/grafana

volumes:
  grafana-storage:
```

#### 3. 原生安裝
- **Ubuntu/Debian**：
  ```bash
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
  sudo apt-get update
  sudo apt-get install grafana
  ```

- **macOS**：
  ```bash
  brew install grafana
  ```

- **Windows**：至 [Grafana 下載頁](https://grafana.com/grafana/download) 下載

### 第一次登入
1. 開啟 `http://localhost:3000`
2. 使用預設帳密（admin/admin）登入
3. 依提示更改密碼
4. 完成後即可看到 Grafana 首頁

### 建議先完成的基本設定
- 設定時區與語系
- 啟用自動更新（Auto refresh）
- 建立只讀帳號供展示或管理層查看

## 連接資料來源

Grafana 支援多種資料來源，下列為常用資料庫與指標系統的連線流程。

### 新增資料來源步驟

1. **進入設定**
   - 左側點選齒輪（⚙️）
   - 選擇「Data Sources」
   - 點擊「Add data source」

2. **選擇資料來源**
   - 從清單中選擇 Prometheus、MySQL、PostgreSQL 等

3. **設定連線資訊**
   - 填寫必要的連線參數
   - 點擊測試連線
   - 儲存並啟用

### 常見資料來源

#### 1. Prometheus（指標資料庫）
```yaml
# 設定範例
Name: Prometheus
Type: Prometheus
URL: http://localhost:9090
Access: Server (default)
```

**適用情境**：
- 系統指標監控
- Kubernetes 監控
- 應用效能監控

#### 2. MySQL 資料庫
```yaml
Name: MySQL DB
Type: MySQL
Host: localhost:3306
Database: mydb
User: grafana_user
Password: ********
```

**範例查詢**：
```sql
SELECT
  timestamp AS time,
  value
FROM metrics
WHERE $__timeFilter(timestamp)
ORDER BY time
```

#### 3. PostgreSQL
```yaml
Name: PostgreSQL
Type: PostgreSQL
Host: localhost:5432
Database: mydb
User: grafana
SSL Mode: disable
```

#### 4. InfluxDB（時間序列資料庫）
```yaml
Name: InfluxDB
Type: InfluxDB
URL: http://localhost:8086
Database: telegraf
User: admin
Password: ********
```

#### 5. Elasticsearch
```yaml
Name: Elasticsearch
Type: Elasticsearch
URL: http://localhost:9200
Index name: logs-*
Time field: @timestamp
```

#### 6. TestData DB（學習用）
Grafana 內建 TestData 資料來源，適合練習：
- 無需額外安裝
- 內建多種測試資料情境
- 可快速驗證視覺化效果

## 視覺化技巧

Grafana 提供多種圖表，請依資料型態與情境選擇。

### 1. 時間序列圖
**適用**：追蹤指標隨時間變化
```
- 24 小時 CPU 使用率
- 網路流量變化
- 銷售趨勢
```

**設定要點**：
- X 軸：時間
- Y 軸：指標值
- 支援多序列
- 可自訂圖例與顏色

### 2. Stat 面板
**適用**：展示單一關鍵數值
```
- 即時 CPU 使用率：45%
- 總使用者數：1,234
- 系統正常率：99.9%
```

**特色**：
- 門檻顏色
- 迷你趨勢圖
- 值映射與單位格式

### 3. Gauge
**適用**：百分比或有上限的數值
```
- 磁碟使用率：0-100%
- 溫度：0-100°C
- 進度：0-100%
```

### 4. Bar Chart
**適用**：比較不同類別
```
- 各地區銷售
- 前 10 名商品
- 服務錯誤次數
```

### 5. Table
**適用**：細節資料檢視
```
- 伺服器清單
- 使用者活動紀錄
- 交易明細
```

### 6. Heatmap
**適用**：分佈與密度
```
- 延遲分佈
- 使用者活動熱點
- 錯誤發生頻率
```

### 7. 圓餅圖 / 甜甜圈圖
**適用**：整體比例關係
```
- 市場占比
- 資源配置
- 類別分布
```

### 8. Geomap
**適用**：地理位置資料
```
- 使用者位置
- 伺服器分布
- 區域指標
```

### 9. State Timeline（補充）
**適用**：狀態變化與事件持續時間
```
- 服務狀態：Up/Down
- 排程工作狀態
```

## 建立儀表板

### 建立流程

1. **建立新儀表板**
   ```
   點擊 "+" → "Dashboard" → "Add new panel"
   ```

2. **設定面板**
   - 選擇資料來源
   - 撰寫查詢
   - 選擇視覺化類型
   - 自訂外觀與閾值

3. **加入多個面板**
   - 建立完整的視覺化頁面
   - 使用列（Row）分組
   - 統一樣式與色彩

4. **儀表板設定**
   - 設定時間區間
   - 加入變數（用於篩選）
   - 設定自動更新
   - 確認時區

### 範例儀表板結構

```
Dashboard: 系統監控
├── Row 1: 概覽
│   ├── CPU 使用率 (Gauge)
│   ├── 記憶體使用率 (Gauge)
│   └── 磁碟使用率 (Gauge)
├── Row 2: 詳細指標
│   ├── CPU 變化趨勢 (Graph)
│   └── 記憶體變化趨勢 (Graph)
└── Row 3: 日誌
    └── 最近錯誤 (Table)
```

### 儀表板變數

建立可動態篩選的儀表板：

```
變數名稱: server
類型: Query
查詢: SELECT DISTINCT hostname FROM servers
```

在查詢中使用：`WHERE hostname = '$server'`

## 解析公開儀表板

分析 Grafana 儀表板（例如公開儀表板）時，可注意：

### 1. 儀表板結構
- **標題與描述**：觀察監控的系統或服務
- **時間範圍**：目前顯示期間
- **更新頻率**：資料更新速度

### 2. 面板分析
對每個面板檢視：
- **視覺化類型**：圖表、Stat、表格等
- **資料來源**：資料從哪裡來
- **查詢內容**：拉取哪些資料
- **閾值設定**：是否有警戒範圍

### 3. 觀察的關鍵指標
- **趨勢**：上升、下降或穩定
- **異常**：是否有尖峰或突降
- **關聯性**：指標間是否互相影響
- **效能狀態**：是否在可接受範圍

### 4. 互動功能
- **時間範圍選擇器**：縮放檢視
- **變數下拉選單**：篩選伺服器或地區
- **圖例**：快速顯示/隱藏曲線
- **提示工具**：滑鼠懸停查看細節

### 分析框架範例

```
Dashboard: [名稱]
用途: [監控目標]
時間範圍: [期間]
更新頻率: [間隔]

Panels:
1. [面板名稱]
   - 類型: [視覺化]
   - 指標: [顯示內容]
   - 洞察: [可得結論]

2. [面板名稱]
   - 類型: [視覺化]
   - 指標: [顯示內容]
   - 洞察: [可得結論]
```

## 最佳實務

### 1. 儀表板設計
✅ **建議**：
- 儀表板聚焦於單一主題
- 使用一致的色彩與樣式
- 面板標題清楚易懂
- 在標籤中標示單位
- 選擇合適的視覺化類型

❌ **避免**：
- 面板過多造成資訊過載
- 使用過度複雜的配色
- 混合無關的指標
- 忘記描述儀表板目的

### 2. 查詢最佳化
- 使用時間範圍過濾：`$__timeFilter(time_column)`
- 限制結果筆數
- 盡量使用聚合
- 設定快取或記錄規則

### 3. 告警設定
- 設定有意義的閾值
- 避免告警疲乏
- 通知內容需包含背景資訊
- 上線前先測試告警

### 4. 資安與權限
- 瀏覽者使用只讀帳號
- 啟用驗證（OAuth、LDAP）
- 定期更新 Grafana 版本
- 妥善保管資料來源密碼

### 5. 維護建議（補充）
- 定期匯出儀表板 JSON 以備份
- 以版本控管追蹤儀表板變更
- 為重要面板加上描述與擁有者

## 範例

### 範例 1：MySQL 網站分析儀表板

**資料來源設定**：
```yaml
Type: MySQL
Host: localhost:3306
Database: analytics
```

**面板 1：今日總瀏覽量**
```sql
SELECT COUNT(*) as value
FROM page_views
WHERE DATE(timestamp) = CURDATE()
```
視覺化：Stat 面板

**面板 2：瀏覽量趨勢**
```sql
SELECT
  timestamp AS time,
  COUNT(*) as views
FROM page_views
WHERE $__timeFilter(timestamp)
GROUP BY DATE(timestamp), HOUR(timestamp)
ORDER BY time
```
視覺化：時間序列

**面板 3：熱門頁面**
```sql
SELECT
  page_url,
  COUNT(*) as views
FROM page_views
WHERE $__timeFilter(timestamp)
GROUP BY page_url
ORDER BY views DESC
LIMIT 10
```
視覺化：長條圖

### 範例 2：Prometheus 系統監控

**面板 1：CPU 使用率**
```promql
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```
視覺化：Gauge

**面板 2：記憶體使用率**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```
視覺化：時間序列

**面板 3：磁碟 I/O**
```promql
rate(node_disk_read_bytes_total[5m]) + rate(node_disk_written_bytes_total[5m])
```
視覺化：折線圖

### 範例 3：Elasticsearch 應用程式日誌

**面板：錯誤率**
```
查詢: level:error
時間欄位: @timestamp
指標: Count
```
視覺化：時間序列 + 告警

**面板：日誌列表**
```
查詢: *
欄位: @timestamp, level, message, service
排序: @timestamp desc
```
視覺化：Table

## 延伸資源

### 官方文件
- [Grafana 官方文件](https://grafana.com/docs/)
- [Grafana 教學](https://grafana.com/tutorials/)
- [資料來源設定](https://grafana.com/docs/grafana/latest/datasources/)

### 社群資源
- [Grafana Community](https://community.grafana.com/)
- [Grafana GitHub](https://github.com/grafana/grafana)
- [公開儀表板集](https://grafana.com/grafana/dashboards/)
- [Grafana Play（線上體驗）](https://play.grafana.org/)

### 學習路徑
1. ✅ 安裝 Grafana
2. ✅ 加入 TestData 資料來源
3. ✅ 建立第一個面板
4. ✅ 完成儀表板
5. ✅ 連接真實資料來源
6. ✅ 設定告警
7. ✅ 分享儀表板
8. ✅ 探索外掛

## 下一步

1. **用 TestData 練習**：先從內建測試資料開始
2. **匯入社群儀表板**：了解設計風格
3. **連接真實資料**：建立自己業務的儀表板
4. **持續優化**：調整查詢與視覺化
5. **建立團隊流程**：定期檢視告警與指標

---

**祝學習順利！📊📈**

如有問題或想分享內容，歡迎提出 Issue 或 PR。
