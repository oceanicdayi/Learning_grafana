# Learning Grafana

A comprehensive guide to learning Grafana for data visualization and monitoring.

## Table of Contents

1. [What is Grafana?](#what-is-grafana)
2. [Getting Started](#getting-started)
3. [Connecting Data Sources](#connecting-data-sources)
4. [Visualization Techniques](#visualization-techniques)
5. [Creating Dashboards](#creating-dashboards)
6. [Analyzing Public Dashboards](#analyzing-public-dashboards)
7. [Best Practices](#best-practices)
8. [Examples](#examples)

## What is Grafana?

Grafana is an open-source analytics and interactive visualization web application. It provides:
- **Data visualization**: Transform data into meaningful charts and graphs
- **Multi-source support**: Connect to various data sources (Prometheus, InfluxDB, MySQL, PostgreSQL, etc.)
- **Alerting**: Set up alerts based on metrics
- **Dashboard sharing**: Create and share interactive dashboards
- **Plugin ecosystem**: Extend functionality with community plugins

### Key Features
- 📊 Rich visualization options (graphs, charts, heatmaps, etc.)
- 🔌 Support for 50+ data sources
- 🎨 Customizable and interactive dashboards
- 🔔 Built-in alerting system
- 👥 Team collaboration features
- 🌐 Public dashboard sharing

## Getting Started

### Installation Options

#### 1. Docker (Recommended for Learning)
```bash
# Run Grafana in Docker
docker run -d -p 3000:3000 --name=grafana grafana/grafana

# Access at http://localhost:3000
# Default credentials: admin/admin
```

#### 2. Using Docker Compose
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

#### 3. Native Installation
- **Ubuntu/Debian**: 
  ```bash
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
  sudo apt-get update
  sudo apt-get install grafana
  ```

- **macOS**: 
  ```bash
  brew install grafana
  ```

- **Windows**: Download from [Grafana Downloads](https://grafana.com/grafana/download)

### First Login
1. Navigate to `http://localhost:3000`
2. Login with default credentials (admin/admin)
3. Change password when prompted
4. You'll see the Grafana home page

## Connecting Data Sources

Grafana supports numerous data sources. Here's how to connect the most popular ones:

### Step-by-Step: Adding a Data Source

1. **Navigate to Configuration**
   - Click on the gear icon (⚙️) in the left sidebar
   - Select "Data Sources"
   - Click "Add data source"

2. **Choose Your Data Source**
   - Select from the list (Prometheus, MySQL, PostgreSQL, InfluxDB, etc.)

3. **Configure Connection**
   - Enter required connection details
   - Test the connection
   - Save & test

### Popular Data Sources

#### 1. Prometheus (Metrics Database)
```yaml
# Configuration Example
Name: Prometheus
Type: Prometheus
URL: http://localhost:9090
Access: Server (default)
```

**Use Cases**: 
- System metrics monitoring
- Kubernetes monitoring
- Application performance monitoring

#### 2. MySQL Database
```yaml
Name: MySQL DB
Type: MySQL
Host: localhost:3306
Database: mydb
User: grafana_user
Password: ********
```

**Example Query**:
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

#### 4. InfluxDB (Time Series)
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

#### 6. TestData DB (For Learning)
Grafana includes a TestData data source perfect for learning!
- No setup required
- Pre-configured scenarios
- Great for testing visualizations

## Visualization Techniques

Grafana offers various visualization types. Choose based on your data type and story.

### 1. Time Series Graph
**Best for**: Tracking metrics over time
```
- CPU usage over 24 hours
- Network traffic patterns
- Sales trends
```

**Configuration**:
- X-axis: Time
- Y-axis: Metric value
- Multiple series support
- Legend customization

### 2. Stat Panel
**Best for**: Single value display
```
- Current CPU usage: 45%
- Total users: 1,234
- System uptime: 99.9%
```

**Features**:
- Color thresholds
- Sparkline preview
- Value mapping
- Unit formatting

### 3. Gauge
**Best for**: Percentage or bounded values
```
- Disk usage: 0-100%
- Temperature: 0-100°C
- Progress: 0-100%
```

### 4. Bar Chart
**Best for**: Comparing categories
```
- Sales by region
- Top 10 products
- Error counts by service
```

### 5. Table
**Best for**: Detailed data inspection
```
- Server inventory
- User activity logs
- Transaction details
```

### 6. Heatmap
**Best for**: Patterns and distributions
```
- Request latency distribution
- User activity patterns
- Error frequency by hour/day
```

### 7. Pie Chart / Donut Chart
**Best for**: Part-to-whole relationships
```
- Market share
- Resource allocation
- Category distribution
```

### 8. Geomap
**Best for**: Geographic data
```
- User locations
- Server distribution
- Regional metrics
```

## Creating Dashboards

### Dashboard Creation Steps

1. **Create New Dashboard**
   ```
   Click "+" → "Dashboard" → "Add new panel"
   ```

2. **Configure Panel**
   - Select data source
   - Write query
   - Choose visualization type
   - Customize appearance

3. **Add Multiple Panels**
   - Create comprehensive views
   - Organize in rows
   - Use consistent styling

4. **Dashboard Settings**
   - Set time range
   - Add variables (for filtering)
   - Configure auto-refresh
   - Set timezone

### Example Dashboard Structure

```
Dashboard: System Monitoring
├── Row 1: Overview
│   ├── CPU Usage (Gauge)
│   ├── Memory Usage (Gauge)
│   └── Disk Usage (Gauge)
├── Row 2: Detailed Metrics
│   ├── CPU Over Time (Graph)
│   └── Memory Over Time (Graph)
└── Row 3: Logs
    └── Recent Errors (Table)
```

### Dashboard Variables

Create dynamic dashboards with variables:

```
Variable Name: server
Type: Query
Query: SELECT DISTINCT hostname FROM servers
```

Use in queries: `WHERE hostname = '$server'`

## Analyzing Public Dashboards

When analyzing a Grafana dashboard (like the one provided), look for:

### 1. Dashboard Structure
- **Title and Description**: What is being monitored?
- **Time Range**: What period is displayed?
- **Refresh Rate**: How often does data update?

### 2. Panel Analysis
For each panel, identify:
- **Visualization Type**: Graph, stat, table, etc.
- **Data Source**: Where is data coming from?
- **Query**: What data is being fetched?
- **Thresholds**: Are there warning/critical levels?

### 3. Key Metrics to Observe
- **Trends**: Is data increasing/decreasing?
- **Anomalies**: Any unusual spikes or drops?
- **Correlations**: Do metrics relate to each other?
- **Performance**: Are systems within acceptable ranges?

### 4. Interactive Features
- **Time Range Selector**: Zoom to specific periods
- **Variable Dropdowns**: Filter by server, region, etc.
- **Legends**: Click to show/hide series
- **Tooltips**: Hover for detailed information

### Example Analysis Framework

```
Dashboard: [Name]
Purpose: [What it monitors]
Time Range: [Period]
Refresh: [Interval]

Panels:
1. [Panel Name]
   - Type: [Visualization]
   - Metric: [What it shows]
   - Insight: [What to learn from it]
   
2. [Panel Name]
   - Type: [Visualization]
   - Metric: [What it shows]
   - Insight: [What to learn from it]
```

## Best Practices

### 1. Dashboard Design
✅ **Do**:
- Keep dashboards focused on a single topic
- Use consistent colors and styles
- Add descriptive panel titles
- Include units in labels
- Use appropriate visualization types

❌ **Don't**:
- Overcrowd dashboards with too many panels
- Use complex color schemes
- Mix unrelated metrics
- Forget to document dashboard purpose

### 2. Query Optimization
- Use time range filters: `$__timeFilter(time_column)`
- Limit result sets
- Use aggregation when possible
- Cache frequently used queries

### 3. Alert Configuration
- Set meaningful thresholds
- Avoid alert fatigue
- Include context in notifications
- Test alerts before deploying

### 4. Security
- Use read-only users for viewers
- Implement authentication (OAuth, LDAP)
- Regularly update Grafana
- Secure data source credentials

## Examples

### Example 1: MySQL Website Analytics Dashboard

**Data Source Configuration**:
```yaml
Type: MySQL
Host: localhost:3306
Database: analytics
```

**Panel 1: Total Page Views Today**
```sql
SELECT COUNT(*) as value
FROM page_views
WHERE DATE(timestamp) = CURDATE()
```
Visualization: Stat Panel

**Panel 2: Page Views Over Time**
```sql
SELECT
  timestamp AS time,
  COUNT(*) as views
FROM page_views
WHERE $__timeFilter(timestamp)
GROUP BY DATE(timestamp), HOUR(timestamp)
ORDER BY time
```
Visualization: Time Series

**Panel 3: Top 10 Pages**
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
Visualization: Bar Chart

### Example 2: System Monitoring with Prometheus

**Panel 1: CPU Usage**
```promql
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```
Visualization: Gauge

**Panel 2: Memory Usage**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```
Visualization: Time Series

**Panel 3: Disk I/O**
```promql
rate(node_disk_read_bytes_total[5m]) + rate(node_disk_written_bytes_total[5m])
```
Visualization: Graph

### Example 3: Application Logs with Elasticsearch

**Panel: Error Rate**
```
Query: level:error
Time field: @timestamp
Metric: Count
```
Visualization: Time Series with Alert

**Panel: Log Table**
```
Query: *
Fields: @timestamp, level, message, service
Sort: @timestamp desc
```
Visualization: Table

## Additional Resources

### Official Documentation
- [Grafana Documentation](https://grafana.com/docs/)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [Data Source Configuration](https://grafana.com/docs/grafana/latest/datasources/)

### Community Resources
- [Grafana Community](https://community.grafana.com/)
- [Grafana GitHub](https://github.com/grafana/grafana)
- [Public Dashboard Gallery](https://grafana.com/grafana/dashboards/)

### Learning Path
1. ✅ Install Grafana
2. ✅ Add TestData source
3. ✅ Create first panel
4. ✅ Build complete dashboard
5. ✅ Add real data source
6. ✅ Configure alerts
7. ✅ Share dashboard
8. ✅ Explore plugins

## Next Steps

1. **Practice with TestData**: Use Grafana's built-in test data to experiment
2. **Import Dashboards**: Try pre-built dashboards from the community
3. **Connect Real Data**: Add your own data sources
4. **Build Custom Dashboards**: Create dashboards for your use cases
5. **Explore Plugins**: Extend Grafana with community plugins

---

**Happy Learning! 📊📈**

For questions or contributions, please open an issue or pull request.