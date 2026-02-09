# Grafana 學習指南總覽

歡迎來到 Grafana 完整學習資源庫！本頁會協助你快速了解文件結構、建議學習路徑與練習方式。

## 📚 文件結構

此專案涵蓋從入門到進階的學習內容，建議依需求選擇：

### 🚀 新手入門（從這裡開始）

1. **[QUICKSTART.md](QUICKSTART.md)** ⭐ **建議第一份閱讀**
   - 10 分鐘內完成環境啟動
   - 建立第一個儀表板
   - 手把手步驟教學
   - 適合完全新手

2. **[README.md](README.md)**
   - Grafana 全面介紹
   - 功能與能力概覽
   - 安裝方式與基礎概念
   - 學習方向整理

### 📖 深入學習

3. **[TUTORIAL.md](TUTORIAL.md)**
   - 完整教學流程
   - 建立多個儀表板案例
   - 多資料來源實作
   - 告警與分享設定
   - 練習題與延伸方向

4. **[examples/DATA_SOURCES.md](examples/DATA_SOURCES.md)**
   - 常見資料來源連線方式
   - YAML 設定範例
   - Prometheus、MySQL、PostgreSQL、InfluxDB
   - 安全與最佳實務

5. **[examples/EXAMPLE_QUERIES.md](examples/EXAMPLE_QUERIES.md)**
   - 即用型查詢範例
   - MySQL、Prometheus、InfluxDB 查詢
   - 常見查詢模式與技巧
   - 效能優化建議

### 🔍 分析與最佳實務

6. **[DASHBOARD_ANALYSIS.md](DASHBOARD_ANALYSIS.md)**
   - 儀表板解讀方法
   - 指標分析與異常判讀
   - 問題定位框架
   - USE/RED 方法

7. **[ANALYZING_PUBLIC_DASHBOARD.md](ANALYZING_PUBLIC_DASHBOARD.md)**
   - 針對公開儀表板的分析流程
   - 實際操作框架
   - 觀察重點與紀錄方式

## 🎯 學習路徑

### 路徑 1：完全新手（2-3 小時）

```
1. 閱讀 QUICKSTART.md（10 分）
   ↓
2. 跟著快速啟動（20 分）
   ↓
3. 了解 README.md 基礎概念（30 分）
   ↓
4. 完成 TUTORIAL.md 第 1-3 章（60 分）
   ↓
5. 匯入社群儀表板（10 分）
   ↓
6. 自行探索與練習（60 分）
```

### 路徑 2：偏實作學習（3-4 小時）

```
1. QUICKSTART.md - 完成環境啟動（15 分）
   ↓
2. TUTORIAL.md - 完整教學（120 分）
   ↓
3. EXAMPLE_QUERIES.md - 嘗試不同查詢（45 分）
   ↓
4. DATA_SOURCES.md - 連接新資料來源（30 分）
   ↓
5. 自建儀表板（60 分）
```

### 路徑 3：分析導向（1-2 小時）

```
1. 閱讀 README.md 概覽（20 分）
   ↓
2. DASHBOARD_ANALYSIS.md - 分析技巧（40 分）
   ↓
3. ANALYZING_PUBLIC_DASHBOARD.md - 實作分析（30 分）
   ↓
4. 匯入儀表板 1860 並分析（30 分）
```

### 路徑 4：快速查閱（長期使用）

適合在工作中快速找到：
- 查詢範例 → EXAMPLE_QUERIES.md
- 資料來源設定 → DATA_SOURCES.md
- 最佳實務 → DASHBOARD_ANALYSIS.md
- 問題排除 → TUTORIAL.md / QUICKSTART.md

## 🛠️ 專案包含內容

### 文件
- ✅ Grafana 完整介紹
- ✅ 逐步教學
- ✅ 儀表板分析指南
- ✅ 最佳實務
- ✅ 查詢範例
- ✅ 疑難排解

### 設定檔
- ✅ Docker Compose 環境
- ✅ Prometheus 設定
- ✅ MySQL 範例資料庫
- ✅ 資料來源預配置
- ✅ 即用範例

### 範例資料
- ✅ 網站分析資料
- ✅ 系統指標
- ✅ 應用日誌
- ✅ 預建 MySQL 資料表

## 🎓 你會學到什麼

### 基礎知識
- [x] Grafana 的用途與價值
- [x] 安裝與環境設定
- [x] 儀表板與面板概念
- [x] 介面操作方式

### 資料來源
- [x] 連接資料庫（MySQL、PostgreSQL）
- [x] 使用 Prometheus 監控指標
- [x] 時間序列資料概念
- [x] 連線測試與疑難排解

### 視覺化
- [x] 選擇正確的視覺化方式
- [x] 建立圖表與趨勢
- [x] 使用 Gauge、Stat
- [x] 建立表格與熱力圖
- [x] 客製化顏色與主題

### 查詢能力
- [x] 撰寫 SQL 查詢
- [x] 使用 PromQL
- [x] 時間範圍與變數
- [x] 聚合與計算
- [x] 查詢效能優化

### 儀表板設計
- [x] 從零建立儀表板
- [x] 組織面板與行
- [x] 使用變數篩選
- [x] 設定時間範圍
- [x] 分享與匯出

### 分析能力
- [x] 讀懂指標趨勢
- [x] 找出異常與關聯
- [x] 使用分析框架（USE、RED、黃金訊號）
- [x] 形成資料驅動決策

### 進階主題
- [x] 設定告警
- [x] 建立公開儀表板
- [x] 匯入社群儀表板
- [x] 最佳實務與效能優化
- [x] 上線前考量事項

## 🏃 常用指令速查

### 啟動環境
```bash
git clone https://github.com/oceanicdayi/Learning_grafana.git
cd Learning_grafana
docker-compose up -d
```

### 服務入口
- **Grafana**：http://localhost:3000（admin/admin）
- **Prometheus**：http://localhost:9090
- **MySQL**：localhost:3306（grafana/grafana_pass）

### 管理服務
```bash
# 停止服務
docker-compose down

# 檢視日誌
docker-compose logs -f grafana

# 重啟服務
docker-compose restart grafana

# 檢查狀態
docker-compose ps
```

## 📊 推薦匯入的儀表板

可嘗試社群儀表板（匯入 → 輸入 ID）：

| ID | 名稱 | 說明 |
|----|------|------|
| 1860 | Node Exporter Full | 完整系統監控 |
| 7362 | MySQL Overview | 資料庫監控 |
| 193 | Docker Monitoring | 容器監控 |
| 7249 | Kubernetes Cluster | K8s 監控 |

## 🎯 練習題

### 練習 1：第一個儀表板（初學）
**時間**：30 分鐘  
**目標**：建立簡易監控儀表板  
**參考**：QUICKSTART.md

### 練習 2：網站分析（中階）
**時間**：60 分鐘  
**目標**：使用 MySQL 建立網站指標  
**參考**：TUTORIAL.md 的「Dashboard 2」

### 練習 3：自訂查詢（中階）
**時間**：45 分鐘  
**目標**：撰寫與優化查詢  
**參考**：EXAMPLE_QUERIES.md

### 練習 4：儀表板分析（進階）
**時間**：60 分鐘  
**目標**：分析公開儀表板  
**參考**：ANALYZING_PUBLIC_DASHBOARD.md

### 練習 5：上線用儀表板（進階）
**時間**：2-3 小時  
**目標**：建立可上線的完整儀表板  
**需求**：
- 多資料來源
- 已設定告警
- 具備變數篩選
- 完整說明與分享

## 🆘 取得協助

### 疑難排解
1. 先查看 QUICKSTART.md 的排除章節
2. 參考 TUTORIAL.md 的常見問題
3. 查看 Docker 日誌：`docker-compose logs`
4. 確認服務狀態：`docker-compose ps`

### 常見問題

**無法進入 Grafana**
- 等待 30 秒讓服務啟動
- 使用 http://127.0.0.1:3000
- 確認 Docker 正常執行

**面板無資料**
- 等待 1-2 分鐘讓 Prometheus 收集資料
- 確認時間範圍（例如「最近 5 分鐘」）
- 資料來源是否連線成功

**查詢錯誤**
- 參考 EXAMPLE_QUERIES.md
- 先在 Explore 測試查詢
- 確認時間範圍內有資料

### 延伸資源
- [Grafana 官方文件](https://grafana.com/docs/)
- [Grafana 社群](https://community.grafana.com/)
- [Grafana 教學](https://grafana.com/tutorials/)
- [Dashboard Gallery](https://grafana.com/grafana/dashboards/)

## 📝 建議閱讀順序

### 初次學習
1. QUICKSTART.md - 快速上手
2. README.md - 理論與全貌
3. TUTORIAL.md - 實作練習
4. EXAMPLE_QUERIES.md - 查詢技巧
5. DASHBOARD_ANALYSIS.md - 分析能力

### 之後參考
- DATA_SOURCES.md - 新增資料來源
- EXAMPLE_QUERIES.md - 撰寫查詢
- ANALYZING_PUBLIC_DASHBOARD.md - 儀表板分析

## 🎉 成就清單

### 初級
- [ ] 成功安裝 Grafana
- [ ] 建立第一個面板
- [ ] 完成第一個儀表板
- [ ] 了解常用視覺化類型
- [ ] 連接資料來源

### 中級
- [ ] 建立多資料來源儀表板
- [ ] 使用變數篩選
- [ ] 撰寫 SQL 與 PromQL 查詢
- [ ] 匯入並調整社群儀表板
- [ ] 分享儀表板

### 進階
- [ ] 設定告警通知
- [ ] 建立上線級儀表板
- [ ] 優化查詢效能
- [ ] 分析複雜指標
- [ ] 為利害關係人設計儀表板

## 💡 小技巧

1. **從小開始**：先做 1-2 個面板，再逐步擴大
2. **善用 TestData**：不用資料庫也能練習
3. **先在 Explore 測試**：避免儀表板出錯
4. **匯入範例學習**：觀察社群設計
5. **記得加註說明**：清楚描述面板目的
6. **版本控管**：匯出 JSON 進行版控
7. **持續迭代**：儀表板會越做越好
8. **多問多看**：參與社群討論

## 🔄 持續更新

此專案將持續新增：
- 新的教學與案例
- 更多資料來源設定
- 查詢模式與技巧
- 更新的最佳實務

歡迎 Star 追蹤最新內容！

## 🤝 投稿與建議

若內容有需補充或不清楚之處，歡迎提出 Issue 或 PR。

## 📄 授權

本學習內容僅供教育與自學用途。

---

## 🚀 準備開始？

**請選擇你的路線：**

1. **「我想快速上手！」** → [QUICKSTART.md](QUICKSTART.md)
2. **「我想全面了解」** → [README.md](README.md)
3. **「我想實作練習」** → [TUTORIAL.md](TUTORIAL.md)
4. **「我想分析儀表板」** → [DASHBOARD_ANALYSIS.md](DASHBOARD_ANALYSIS.md)

**不管選哪條路，都能學會 Grafana！🎓**

---

*祝學習順利！如有問題，可查看文件或在 GitHub 開 issue。*
