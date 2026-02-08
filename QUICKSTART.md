# Quick Start Guide

Get up and running with Grafana in 10 minutes!

## Prerequisites

- Docker and Docker Compose installed
- 5 minutes of your time

## Step 1: Clone and Start (2 minutes)

```bash
# Clone the repository
git clone https://github.com/oceanicdayi/Learning_grafana.git
cd Learning_grafana

# Start the stack
docker-compose up -d

# Verify services are running
docker-compose ps
```

Expected output:
```
NAME            STATUS
grafana         Up
mysql           Up
prometheus      Up
node-exporter   Up
```

## Step 2: Access Grafana (1 minute)

1. Open your browser to: `http://localhost:3000`
2. Login:
   - **Username**: admin
   - **Password**: admin
3. Skip password change (or set a new one)

## Step 3: Verify Data Sources (1 minute)

1. Click ⚙️ (Configuration) in left sidebar
2. Click "Data sources"
3. You should see:
   - ✅ Prometheus (Default)
   - ✅ MySQL Demo

## Step 4: Create Your First Panel (3 minutes)

1. Click **+** (Create) → **Dashboard**
2. Click **Add new panel**

### Configure the Panel:

**Query Section:**
- Data source: Select "Prometheus"
- Query: Enter this:
  ```promql
  100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
  ```

**Panel Options:**
- Title: "CPU Usage"

**Right Sidebar:**
- Visualization: Select "Gauge"
- Unit: "Percent (0-100)"
- Thresholds:
  - Add threshold: 70 (Yellow)
  - Add threshold: 85 (Red)

3. Click **Apply** (top right)
4. Click **💾 Save dashboard**
5. Name: "My First Dashboard"
6. Click **Save**

## Step 5: Add More Panels (3 minutes)

### Memory Usage Panel

1. Click **Add panel** → **Add new panel**
2. Query:
   ```promql
   (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
   ```
3. Title: "Memory Usage"
4. Visualization: Gauge
5. Unit: Percent (0-100)
6. Thresholds: 70 (Yellow), 90 (Red)
7. Click **Apply**

### Network Traffic Panel

1. Click **Add panel** → **Add new panel**
2. Query A:
   ```promql
   rate(node_network_receive_bytes_total{device!="lo"}[5m])
   ```
3. Query B (click "+ Query"):
   ```promql
   rate(node_network_transmit_bytes_total{device!="lo"}[5m])
   ```
4. Title: "Network Traffic"
5. Visualization: Time series
6. Unit: bytes/sec
7. Click **Apply**

### Save Dashboard

Click **💾 Save dashboard** (top right)

## Step 6: Explore Data (Bonus)

### View MySQL Data

1. Click **Explore** (compass icon in sidebar)
2. Select data source: "MySQL Demo"
3. Query:
   ```sql
   SELECT * FROM page_views ORDER BY timestamp DESC LIMIT 10
   ```
4. Click **Run query**

You'll see sample website analytics data!

## Next Steps

### Learn More

📚 Read the [Full Tutorial](TUTORIAL.md) for comprehensive guide

📊 Check [Example Queries](examples/EXAMPLE_QUERIES.md) for more query examples

🔍 Read [Dashboard Analysis Guide](DASHBOARD_ANALYSIS.md) to understand dashboards

### Import Pre-built Dashboards

1. Go to **+** → **Import**
2. Enter dashboard ID: **1860** (Node Exporter Full)
3. Click **Load**
4. Select Prometheus data source
5. Click **Import**

### Create More Dashboards

Try creating dashboards for:
- Website analytics (using MySQL data)
- System monitoring (using Prometheus)
- Custom metrics

## Troubleshooting

### Services Not Starting

```bash
# Check Docker is running
docker ps

# Check logs
docker-compose logs grafana
docker-compose logs mysql
docker-compose logs prometheus

# Restart services
docker-compose restart
```

### Can't Access Grafana

- Verify Docker containers are running: `docker-compose ps`
- Check port 3000 is not in use: `lsof -i :3000`
- Try accessing: `http://127.0.0.1:3000`

### No Data in Panels

- Wait 1-2 minutes for Prometheus to scrape metrics
- Check time range (use "Last 5 minutes")
- Verify data sources are connected (green checkmark)

### Data Source Connection Failed

```bash
# Restart the specific service
docker-compose restart prometheus
docker-compose restart mysql

# Check if services can communicate
docker-compose exec grafana ping prometheus
```

## Clean Up

When you're done:

```bash
# Stop all services
docker-compose down

# Remove all data (fresh start)
docker-compose down -v
```

## What You've Learned

✅ How to start Grafana with Docker  
✅ How to access Grafana web interface  
✅ How to verify data sources  
✅ How to create panels with queries  
✅ How to use different visualizations  
✅ How to save dashboards  

## Cheat Sheet

### Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f grafana

# Restart Grafana
docker-compose restart grafana

# Check status
docker-compose ps
```

### Common URLs

- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090
- Node Exporter: http://localhost:9100/metrics
- MySQL: localhost:3306

### Default Credentials

- Grafana: admin / admin
- MySQL: grafana / grafana_pass
- MySQL Root: root / rootpassword

## Pro Tips

💡 Use **Ctrl+S** to quick-save dashboards

💡 Press **?** in Grafana to see keyboard shortcuts

💡 Use **Explore** view to test queries before adding to dashboard

💡 Click panel title → **Edit** to quickly modify panels

💡 Use **Time range picker** to view different time periods

💡 Enable **Auto-refresh** for real-time monitoring

---

**Congratulations! 🎉** 

You've created your first Grafana dashboard!

Continue learning:
- [📖 Full Tutorial](TUTORIAL.md)
- [📚 README](README.md)
- [💻 Example Queries](examples/EXAMPLE_QUERIES.md)

Need help? Check the troubleshooting section or open an issue on GitHub!
