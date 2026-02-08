# Step-by-Step Tutorial: Creating Your First Grafana Dashboard

This tutorial will guide you through creating a complete dashboard with real data.

## Prerequisites

- Docker and Docker Compose installed
- Basic understanding of SQL (for database examples)

## Part 1: Setup Environment

### Step 1: Start the Stack

```bash
# Clone the repository
git clone https://github.com/oceanicdayi/Learning_grafana.git
cd Learning_grafana

# Start all services
docker-compose up -d

# Verify services are running
docker-compose ps
```

Expected output:
```
NAME            IMAGE                         STATUS
grafana         grafana/grafana:latest        Up
mysql           mysql:8.0                     Up
prometheus      prom/prometheus:latest        Up
node-exporter   prom/node-exporter:latest     Up
```

### Step 2: Access Grafana

1. Open browser to `http://localhost:3000`
2. Login with:
   - Username: `admin`
   - Password: `admin`
3. Change password when prompted (or skip)

## Part 2: Explore Pre-configured Data Sources

### Step 1: Check Data Sources

1. Click on ⚙️ (Configuration) → Data Sources
2. You should see:
   - ✅ Prometheus (default)
   - ✅ MySQL Demo

### Step 2: Test Connections

1. Click on each data source
2. Scroll to bottom
3. Click "Save & test"
4. Verify green success message

## Part 3: Create Your First Dashboard

### Dashboard 1: System Monitoring with Prometheus

#### Step 1: Create New Dashboard

1. Click + → Dashboard
2. Click "Add new panel"

#### Step 2: CPU Usage Panel

**Configuration:**
- **Data Source**: Prometheus
- **Query**:
  ```promql
  100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
  ```
- **Panel Title**: CPU Usage
- **Visualization**: Gauge
- **Unit**: Percent (0-100)
- **Thresholds**:
  - Green: 0-70
  - Yellow: 70-85
  - Red: 85-100

#### Step 3: Memory Usage Panel

1. Click "Add panel" → "Add new panel"

**Configuration:**
- **Data Source**: Prometheus
- **Query**:
  ```promql
  (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
  ```
- **Panel Title**: Memory Usage
- **Visualization**: Gauge
- **Unit**: Percent (0-100)
- **Thresholds**:
  - Green: 0-70
  - Yellow: 70-90
  - Red: 90-100

#### Step 4: Network Traffic Panel

1. Click "Add panel" → "Add new panel"

**Configuration:**
- **Data Source**: Prometheus
- **Query A** (Incoming):
  ```promql
  rate(node_network_receive_bytes_total[5m])
  ```
- **Query B** (Outgoing):
  ```promql
  rate(node_network_transmit_bytes_total[5m])
  ```
- **Panel Title**: Network Traffic
- **Visualization**: Time series
- **Unit**: bytes/sec

#### Step 5: Save Dashboard

1. Click 💾 (Save dashboard) at top
2. Name: "System Monitoring"
3. Click "Save"

### Dashboard 2: Website Analytics with MySQL

#### Step 1: Create New Dashboard

1. Click + → Dashboard
2. Click "Add new panel"

#### Step 2: Total Page Views Today

**Configuration:**
- **Data Source**: MySQL Demo
- **Query**:
  ```sql
  SELECT 
    COUNT(*) as 'Page Views'
  FROM page_views
  WHERE DATE(timestamp) = CURDATE()
  ```
- **Panel Title**: Page Views Today
- **Visualization**: Stat
- **Color**: Blue
- **Graph mode**: None

#### Step 3: Page Views Over Time

1. Add new panel

**Configuration:**
- **Data Source**: MySQL Demo
- **Query**:
  ```sql
  SELECT
    timestamp as time,
    COUNT(*) as value
  FROM page_views
  WHERE $__timeFilter(timestamp)
  GROUP BY DATE(timestamp), HOUR(timestamp)
  ORDER BY time
  ```
- **Format**: Time series
- **Panel Title**: Page Views Over Time
- **Visualization**: Time series

#### Step 4: Top Pages

1. Add new panel

**Configuration:**
- **Data Source**: MySQL Demo
- **Query**:
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
- **Format**: Table
- **Panel Title**: Top 10 Pages
- **Visualization**: Bar chart (horizontal)

#### Step 5: Average Response Time

1. Add new panel

**Configuration:**
- **Data Source**: MySQL Demo
- **Query**:
  ```sql
  SELECT
    AVG(response_time) as 'Avg Response Time'
  FROM page_views
  WHERE $__timeFilter(timestamp)
  ```
- **Panel Title**: Average Response Time
- **Visualization**: Stat
- **Unit**: milliseconds (ms)
- **Thresholds**:
  - Green: 0-100
  - Yellow: 100-200
  - Red: 200+

#### Step 6: Error Logs Table

1. Add new panel

**Configuration:**
- **Data Source**: MySQL Demo
- **Query**:
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
- **Format**: Table
- **Panel Title**: Recent Errors and Warnings
- **Visualization**: Table

#### Step 7: Organize Panels

1. Drag panels to arrange them
2. Resize panels by dragging corners
3. Suggested layout:
   ```
   Row 1: [Page Views Today] [Avg Response Time]
   Row 2: [Page Views Over Time - full width]
   Row 3: [Top 10 Pages - full width]
   Row 4: [Recent Errors and Warnings - full width]
   ```

#### Step 8: Save Dashboard

1. Click 💾 Save dashboard
2. Name: "Website Analytics"
3. Click "Save"

## Part 4: Dashboard Customization

### Add Time Range Controls

1. Click ⚙️ (Dashboard settings)
2. Go to "Time options"
3. Configure:
   - **Timezone**: Browser time
   - **Auto refresh**: 30s, 1m, 5m, 15m, 30m, 1h
   - **Default time range**: Last 24 hours

### Add Variables for Filtering

1. Click ⚙️ (Dashboard settings)
2. Go to "Variables"
3. Click "Add variable"

**Variable 1: Server Selection**
- **Name**: server
- **Type**: Query
- **Data Source**: MySQL Demo
- **Query**:
  ```sql
  SELECT DISTINCT hostname FROM system_metrics
  ```
- **Multi-value**: Yes
- **Include All option**: Yes

**Usage in queries**:
```sql
WHERE hostname IN ($server)
```

### Add Panel Links

1. Edit a panel
2. Go to "Panel options" section
3. Add link:
   - **Title**: View Logs
   - **URL**: `/d/logs-dashboard`

## Part 5: Alerting (Optional)

### Create Alert Rule

1. Edit a panel (e.g., CPU Usage)
2. Go to "Alert" tab
3. Click "Create alert rule from this panel"

**Alert Configuration:**
- **Name**: High CPU Usage
- **Condition**: WHEN avg() OF query(A) IS ABOVE 85
- **For**: 5m
- **Annotations**:
  - Summary: CPU usage is above 85%
  - Description: Check system load and processes

### Configure Contact Points

1. Go to Alerting → Contact points
2. Add contact point:
   - **Name**: Email
   - **Type**: Email
   - **Addresses**: your-email@example.com

## Part 6: Sharing Dashboard

### Option 1: Public Dashboard

1. Open dashboard
2. Click 🔗 (Share) → Public dashboard
3. Enable public dashboard
4. Copy public URL
5. Share with anyone (no login required)

### Option 2: Snapshot

1. Open dashboard
2. Click 🔗 (Share) → Snapshot
3. Set expiration time
4. Publish to snapshots.raintank.io
5. Share the snapshot URL

### Option 3: Export JSON

1. Click ⚙️ (Dashboard settings)
2. Go to "JSON Model"
3. Copy JSON
4. Share file or import in another Grafana instance

## Part 7: Import Community Dashboards

Grafana has a huge collection of pre-built dashboards!

### Import Node Exporter Dashboard

1. Go to + → Import
2. Enter Dashboard ID: `1860`
3. Click "Load"
4. Select Prometheus data source
5. Click "Import"

**Popular Dashboard IDs:**
- Node Exporter Full: 1860
- MySQL Overview: 7362
- Docker Monitoring: 193
- Kubernetes Cluster: 7249

## Part 8: Advanced Techniques

### Template Variables

Use variables to create dynamic dashboards:

```sql
-- In panel query
SELECT * FROM metrics WHERE hostname = '$hostname'

-- Multiple selection
WHERE hostname IN ($hostname)

-- Time range
WHERE timestamp >= $__timeFrom AND timestamp <= $__timeTo
```

### Transformations

Transform query results:

1. **Join by field**: Combine multiple queries
2. **Filter by value**: Show only relevant data
3. **Calculate field**: Add computed columns
4. **Organize fields**: Reorder/hide columns

### Query Caching

1. Edit data source
2. Enable "Query caching"
3. Set cache timeout
4. Improves performance for frequently-used queries

## Troubleshooting

### Data Not Showing

✅ Check:
- Data source connection (Save & test)
- Query syntax
- Time range
- Data exists in that time range

### Slow Queries

✅ Solutions:
- Use time filters: `$__timeFilter(timestamp)`
- Add database indexes
- Limit result sets
- Use aggregation
- Enable query caching

### Connection Errors

✅ Check:
- Service is running: `docker-compose ps`
- Firewall rules
- Network connectivity
- Credentials

## Next Steps

1. ✅ Experiment with different visualizations
2. ✅ Create alerts for critical metrics
3. ✅ Import community dashboards
4. ✅ Connect your own data sources
5. ✅ Explore Grafana plugins
6. ✅ Set up authentication (LDAP, OAuth)
7. ✅ Create organization and teams
8. ✅ Set up dashboard permissions

## Practice Exercises

### Exercise 1: Create a Sales Dashboard
- Connect to a database with sales data
- Show: Total sales, Sales by region, Top products
- Use: Stat, Bar chart, Pie chart

### Exercise 2: Create a Server Monitoring Dashboard
- Use Prometheus + Node Exporter
- Show: CPU, Memory, Disk, Network
- Add alerts for critical thresholds

### Exercise 3: Create a Log Analysis Dashboard
- Connect to Elasticsearch or MySQL logs
- Show: Error rate, Log level distribution, Recent errors
- Filter by service and severity

## Resources

- **Documentation**: https://grafana.com/docs/
- **Community Dashboards**: https://grafana.com/grafana/dashboards/
- **Tutorials**: https://grafana.com/tutorials/
- **Community Forum**: https://community.grafana.com/

---

**Congratulations! 🎉** You've completed the Grafana tutorial!

You now know how to:
- Set up Grafana with Docker
- Connect data sources
- Create dashboards
- Use different visualizations
- Set up alerts
- Share dashboards

Keep practicing and exploring!
