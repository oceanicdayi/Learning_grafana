# 快速開始指南

10 分鐘內完成 Grafana 環境並建立第一個儀表板！

## 先決條件

- 已安裝 Docker 與 Docker Compose
- 可用的 3000/9090/3306 連接埠
- 約 5-10 分鐘的時間

## 步驟 1：下載並啟動（2 分鐘）

```bash
# 取得專案
git clone https://github.com/oceanicdayi/Learning_grafana.git
cd Learning_grafana

# 啟動服務
docker-compose up -d

# 確認服務狀態
docker-compose ps
```

預期輸出：
```
NAME            STATUS
grafana         Up
mysql           Up
prometheus      Up
node-exporter   Up
```

## 步驟 2：進入 Grafana（1 分鐘）

1. 開啟瀏覽器：`http://localhost:3000`
2. 登入資訊：
   - **帳號**：admin
   - **密碼**：admin
3. 可先略過密碼更改（或立即修改）

## 步驟 3：確認資料來源（1 分鐘）

1. 左側點擊 ⚙️（Configuration）
2. 選擇「Data sources」
3. 應看到：
   - ✅ Prometheus（預設）
   - ✅ MySQL Demo

## 步驟 4：建立第一個面板（3 分鐘）

1. 點擊 **+**（Create）→ **Dashboard**
2. 點擊 **Add new panel**

### 面板設定

**查詢區塊：**
- 資料來源：選擇「Prometheus」
- 查詢：
  ```promql
  100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
  ```

**面板選項：**
- 標題：「CPU 使用率」

**右側設定：**
- 視覺化：選擇「Gauge」
- 單位：Percent (0-100)
- 閾值：
  - 70（黃色）
  - 85（紅色）

3. 點擊 **Apply**（右上）
4. 點擊 **💾 Save dashboard**
5. 命名：「我的第一個儀表板」
6. 點擊 **Save**

## 步驟 5：新增更多面板（3 分鐘）

### 記憶體使用率面板

1. 點擊 **Add panel** → **Add new panel**
2. 查詢：
   ```promql
   (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
   ```
3. 標題：「記憶體使用率」
4. 視覺化：Gauge
5. 單位：Percent (0-100)
6. 閾值：70（黃）、90（紅）
7. 點擊 **Apply**

### 網路流量面板

1. 點擊 **Add panel** → **Add new panel**
2. Query A：
   ```promql
   rate(node_network_receive_bytes_total{device!="lo"}[5m])
   ```
3. Query B（點擊「+ Query」）：
   ```promql
   rate(node_network_transmit_bytes_total{device!="lo"}[5m])
   ```
4. 標題：「網路流量」
5. 視覺化：Time series
6. 單位：bytes/sec
7. 點擊 **Apply**

### 儲存儀表板

點擊 **💾 Save dashboard**（右上）

## 步驟 6：探索資料（加分）

### 查看 MySQL 範例資料

1. 點擊 **Explore**（左側指南針）
2. 選擇資料來源：「MySQL Demo」
3. 查詢：
   ```sql
   SELECT * FROM page_views ORDER BY timestamp DESC LIMIT 10
   ```
4. 點擊 **Run query**

你會看到網站分析的範例資料！

## 下一步

### 繼續學習

📚 閱讀 [完整教學](TUTORIAL.md) 深入了解功能

📊 查看 [查詢範例](examples/EXAMPLE_QUERIES.md) 練習 SQL/PromQL

🔍 參考 [儀表板分析指南](DASHBOARD_ANALYSIS.md) 提升分析能力

### 匯入社群儀表板

1. 點擊 **+** → **Import**
2. 輸入儀表板 ID：**1860**（Node Exporter Full）
3. 點擊 **Load**
4. 選擇 Prometheus 資料來源
5. 點擊 **Import**

### 自建更多儀表板

可嘗試以下主題：
- 網站分析（MySQL）
- 系統監控（Prometheus）
- 自訂指標（或自建資料）

## 疑難排解

### 服務無法啟動

```bash
# 確認 Docker 有在執行
docker ps

# 查看日誌
docker-compose logs grafana
docker-compose logs mysql
docker-compose logs prometheus

# 重啟服務
docker-compose restart
```

### 無法進入 Grafana

- 確認容器已啟動：`docker-compose ps`
- 確認 3000 連接埠未被占用：`lsof -i :3000`
- 嘗試使用：http://127.0.0.1:3000

### 面板沒有資料

- 等待 1-2 分鐘讓 Prometheus 收集資料
- 確認時間範圍（建議「最近 5 分鐘」）
- 確認資料來源顯示綠色勾勾

### 資料來源連線失敗

```bash
# 重啟指定服務
docker-compose restart prometheus
docker-compose restart mysql

# 確認 Grafana 與服務互通
docker-compose exec grafana ping prometheus
```

## 清理環境

完成後可停止服務：

```bash
# 停止全部服務
docker-compose down

# 同時移除資料（重置環境）
docker-compose down -v
```

## 你已完成的學習內容

✅ 使用 Docker 啟動 Grafana  
✅ 進入 Grafana Web 介面  
✅ 檢查資料來源  
✅ 建立第一個面板  
✅ 使用不同視覺化  
✅ 儲存儀表板  

## 速查表

### 常用指令

```bash
# 啟動服務
docker-compose up -d

# 停止服務
docker-compose down

# 查看日誌
docker-compose logs -f grafana

# 重啟 Grafana
docker-compose restart grafana

# 檢查狀態
docker-compose ps
```

### 常用網址

- Grafana：http://localhost:3000
- Prometheus：http://localhost:9090
- Node Exporter：http://localhost:9100/metrics
- MySQL：localhost:3306

### 預設帳密

- Grafana：admin / admin
- MySQL：grafana / grafana_pass
- MySQL Root：root / rootpassword

## 小技巧

💡 使用 **Ctrl+S** 可快速儲存儀表板

💡 按 **?** 查看快捷鍵

💡 先在 **Explore** 測試查詢再加入面板

💡 點面板標題 → **Edit** 快速修改

💡 使用 **Time range picker** 檢視不同時間

💡 啟用 **Auto-refresh** 讓資料即時更新

---

**恭喜完成！🎉**

你已建立第一個 Grafana 儀表板！

繼續學習：
- [📖 完整教學](TUTORIAL.md)
- [📚 README](README.md)
- [💻 查詢範例](examples/EXAMPLE_QUERIES.md)

需要協助？請查看疑難排解或在 GitHub 開 issue！
