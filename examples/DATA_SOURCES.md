# Grafana 資料來源設定範例

此資料夾提供常見資料來源的設定範例，方便快速套用到 Grafana。

## 自動佈建（Provisioning）

Grafana 支援透過 YAML 檔案自動設定資料來源，請將設定檔放在 `provisioning/datasources/` 目錄中。

## 設定範例

### 1. Prometheus 資料來源

**檔案**：`prometheus-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
    jsonData:
      httpMethod: POST
      timeInterval: 30s
```

### 2. MySQL 資料來源

**檔案**：`mysql-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: MySQL
    type: mysql
    access: proxy
    url: mysql:3306
    database: grafana_demo
    user: grafana
    secureJsonData:
      password: grafana_pass
    jsonData:
      maxOpenConns: 10
      maxIdleConns: 10
      connMaxLifetime: 14400
```

### 3. PostgreSQL 資料來源

**檔案**：`postgres-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: PostgreSQL
    type: postgres
    access: proxy
    url: postgres:5432
    database: mydb
    user: grafana
    secureJsonData:
      password: your_password
    jsonData:
      sslmode: disable
      postgresVersion: 1300
      timescaledb: false
```

### 4. InfluxDB 資料來源

**檔案**：`influxdb-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: InfluxDB
    type: influxdb
    access: proxy
    url: http://influxdb:8086
    database: telegraf
    user: admin
    secureJsonData:
      password: admin
    jsonData:
      httpMode: GET
      timeInterval: 10s
```

### 5. TestData 資料來源（內建）

**檔案**：`testdata-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: TestData
    type: testdata
    access: proxy
    isDefault: false
    editable: true
```

### 6. Loki（補充）

若需要日誌分析，可加入 Loki：

```yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    editable: true
```

## 手動設定

也可以直接在 Grafana UI 內新增：

1. 進入 Configuration → Data Sources
2. 點擊「Add data source」
3. 選擇資料來源類型
4. 填寫連線資訊
5. 點擊「Save & test」

## 各資料來源連線資訊

### Prometheus
- **URL**：`http://localhost:9090`（本機）或 `http://prometheus:9090`（Docker）
- **Access**：Server（proxy）
- **HTTP Method**：POST

### MySQL
- **Host**：`localhost:3306` 或 `mysql:3306`
- **Database**：資料庫名稱
- **User**：資料庫帳號
- **Password**：資料庫密碼
- **SSL Mode**：Disabled（本機開發）

### PostgreSQL
- **Host**：`localhost:5432` 或 `postgres:5432`
- **Database**：資料庫名稱
- **User**：資料庫帳號
- **Password**：資料庫密碼
- **SSL Mode**：disable（本機開發）

### InfluxDB
- **URL**：`http://localhost:8086` 或 `http://influxdb:8086`
- **Database**：資料庫名稱（如 telegraf）
- **User**：帳號
- **Password**：密碼
- **HTTP Method**：GET 或 POST

### Elasticsearch
- **URL**：`http://localhost:9200` 或 `http://elasticsearch:9200`
- **Index name**：Pattern（如 `logs-*`）
- **Time field**：`@timestamp`
- **Version**：選擇對應版本

### Loki
- **URL**：`http://localhost:3100` 或 `http://loki:3100`
- **Log label**：常見 `job`、`instance`

## 測試資料來源

新增資料來源後，建議：
1. 點擊「Save & test」
2. 確認綠色「Data source is working」
3. 若失敗請檢查：
   - 網路連線
   - 帳密
   - 防火牆設定
   - 服務狀態

## 環境變數

敏感資訊建議使用環境變數：

```yaml
datasources:
  - name: MySQL
    type: mysql
    url: ${MYSQL_HOST}:${MYSQL_PORT}
    database: ${MYSQL_DATABASE}
    user: ${MYSQL_USER}
    secureJsonData:
      password: ${MYSQL_PASSWORD}
```

## 實務建議

- **使用描述性名稱**：清楚標示用途
- **設定預設來源**：常用資料來源可設為預設
- **定期測試連線**：防止連線失效
- **使用唯讀帳號**：降低風險
- **避免硬編碼密碼**：使用環境變數
- **啟用快取**：改善常用查詢效能
- **記錄連線資訊**：方便維護交接

## 下一步

1. 選擇適合的資料來源
2. 完成連線設定
3. 測試連線
4. 撰寫第一個查詢
5. 建立視覺化
6. 建立儀表板

更多資訊請參考 [主 README](../README.md)。
