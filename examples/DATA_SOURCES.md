# Grafana Data Source Configuration Examples

This directory contains example configurations for various data sources that can be used with Grafana.

## Automatic Provisioning

Grafana supports automatic provisioning of data sources through YAML configuration files. Place these files in the `provisioning/datasources/` directory.

## Example Configurations

### 1. Prometheus Data Source

**File**: `prometheus-datasource.yml`

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

### 2. MySQL Data Source

**File**: `mysql-datasource.yml`

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

### 3. PostgreSQL Data Source

**File**: `postgres-datasource.yml`

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

### 4. InfluxDB Data Source

**File**: `influxdb-datasource.yml`

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

### 5. TestData Data Source (Built-in)

**File**: `testdata-datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: TestData
    type: testdata
    access: proxy
    isDefault: false
    editable: true
```

## Manual Configuration

You can also add data sources manually through the Grafana UI:

1. Go to Configuration → Data Sources
2. Click "Add data source"
3. Select the data source type
4. Fill in the connection details
5. Click "Save & test"

## Connection Details by Data Source

### Prometheus
- **URL**: `http://localhost:9090` (local) or `http://prometheus:9090` (Docker)
- **Access**: Server (proxy)
- **HTTP Method**: POST

### MySQL
- **Host**: `localhost:3306` or `mysql:3306`
- **Database**: Your database name
- **User**: Database user
- **Password**: Database password
- **SSL Mode**: Disabled (for local development)

### PostgreSQL
- **Host**: `localhost:5432` or `postgres:5432`
- **Database**: Your database name
- **User**: Database user
- **Password**: Database password
- **SSL Mode**: disable (for local development)

### InfluxDB
- **URL**: `http://localhost:8086` or `http://influxdb:8086`
- **Database**: Database name (e.g., telegraf)
- **User**: Username
- **Password**: Password
- **HTTP Method**: GET or POST

### Elasticsearch
- **URL**: `http://localhost:9200` or `http://elasticsearch:9200`
- **Index name**: Pattern (e.g., `logs-*`)
- **Time field**: `@timestamp`
- **Version**: Select your Elasticsearch version

## Testing Data Sources

After adding a data source, always:
1. Click "Save & test"
2. Verify the green "Data source is working" message
3. If there's an error, check:
   - Network connectivity
   - Credentials
   - Firewall rules
   - Service status

## Environment Variables

For security, use environment variables for sensitive data:

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

## Tips

- **Use descriptive names**: Make it clear what each data source contains
- **Set one as default**: Your most-used data source should be default
- **Test connections**: Always test after configuration changes
- **Document credentials**: Keep secure records of credentials
- **Use read-only users**: For security, use users with minimal permissions
- **Enable query caching**: Improve performance for frequently-used queries

## Next Steps

1. Choose a data source based on your needs
2. Configure the connection details
3. Test the connection
4. Create your first query
5. Build visualizations
6. Create a dashboard

For more information, see the [main README](../README.md).
