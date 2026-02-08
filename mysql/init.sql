-- Initialize demo database for Grafana learning

-- Create sample table for website analytics
CREATE TABLE IF NOT EXISTS page_views (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    page_url VARCHAR(255) NOT NULL,
    user_id INT,
    session_id VARCHAR(100),
    ip_address VARCHAR(45),
    user_agent TEXT,
    response_time INT,
    INDEX idx_timestamp (timestamp),
    INDEX idx_page_url (page_url)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create sample table for system metrics
CREATE TABLE IF NOT EXISTS system_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hostname VARCHAR(100) NOT NULL,
    cpu_usage DECIMAL(5,2),
    memory_usage DECIMAL(5,2),
    disk_usage DECIMAL(5,2),
    network_in BIGINT,
    network_out BIGINT,
    INDEX idx_timestamp (timestamp),
    INDEX idx_hostname (hostname)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create sample table for application logs
CREATE TABLE IF NOT EXISTS application_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    level VARCHAR(20) NOT NULL,
    service VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    error_code VARCHAR(50),
    user_id INT,
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_service (service)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample data for page_views
INSERT INTO page_views (timestamp, page_url, user_id, session_id, ip_address, response_time) VALUES
(NOW() - INTERVAL 1 HOUR, '/home', 1, 'sess_001', '192.168.1.1', 120),
(NOW() - INTERVAL 2 HOUR, '/about', 2, 'sess_002', '192.168.1.2', 150),
(NOW() - INTERVAL 3 HOUR, '/products', 1, 'sess_001', '192.168.1.1', 200),
(NOW() - INTERVAL 4 HOUR, '/contact', 3, 'sess_003', '192.168.1.3', 100),
(NOW() - INTERVAL 5 HOUR, '/home', 4, 'sess_004', '192.168.1.4', 80),
(NOW() - INTERVAL 6 HOUR, '/products', 2, 'sess_002', '192.168.1.2', 180),
(NOW() - INTERVAL 7 HOUR, '/about', 5, 'sess_005', '192.168.1.5', 90),
(NOW() - INTERVAL 8 HOUR, '/home', 1, 'sess_001', '192.168.1.1', 110),
(NOW() - INTERVAL 9 HOUR, '/products', 3, 'sess_003', '192.168.1.3', 220),
(NOW() - INTERVAL 10 HOUR, '/home', 6, 'sess_006', '192.168.1.6', 95);

-- Insert sample data for system_metrics
INSERT INTO system_metrics (timestamp, hostname, cpu_usage, memory_usage, disk_usage, network_in, network_out) VALUES
(NOW() - INTERVAL 10 MINUTE, 'web-server-1', 45.5, 62.3, 55.0, 1024000, 2048000),
(NOW() - INTERVAL 20 MINUTE, 'web-server-1', 52.1, 65.8, 55.1, 1124000, 2148000),
(NOW() - INTERVAL 30 MINUTE, 'web-server-1', 38.9, 60.2, 55.2, 924000, 1948000),
(NOW() - INTERVAL 40 MINUTE, 'web-server-1', 67.4, 72.5, 55.3, 1524000, 2548000),
(NOW() - INTERVAL 50 MINUTE, 'web-server-1', 41.2, 58.9, 55.4, 1000000, 2000000),
(NOW() - INTERVAL 10 MINUTE, 'db-server-1', 35.2, 80.5, 72.0, 2024000, 1048000),
(NOW() - INTERVAL 20 MINUTE, 'db-server-1', 42.8, 82.1, 72.1, 2124000, 1148000),
(NOW() - INTERVAL 30 MINUTE, 'db-server-1', 38.5, 79.8, 72.2, 1924000, 948000),
(NOW() - INTERVAL 40 MINUTE, 'db-server-1', 51.3, 85.2, 72.3, 2524000, 1548000),
(NOW() - INTERVAL 50 MINUTE, 'db-server-1', 37.9, 78.3, 72.4, 2000000, 1000000);

-- Insert sample data for application_logs
INSERT INTO application_logs (timestamp, level, service, message, error_code, user_id) VALUES
(NOW() - INTERVAL 5 MINUTE, 'INFO', 'web-api', 'User login successful', NULL, 1),
(NOW() - INTERVAL 10 MINUTE, 'ERROR', 'web-api', 'Database connection timeout', 'DB_001', NULL),
(NOW() - INTERVAL 15 MINUTE, 'WARN', 'payment-service', 'Payment processing slow', 'PAY_002', 2),
(NOW() - INTERVAL 20 MINUTE, 'INFO', 'auth-service', 'Token refresh successful', NULL, 3),
(NOW() - INTERVAL 25 MINUTE, 'ERROR', 'email-service', 'Failed to send email', 'EMAIL_001', 4),
(NOW() - INTERVAL 30 MINUTE, 'INFO', 'web-api', 'User logout', NULL, 1),
(NOW() - INTERVAL 35 MINUTE, 'DEBUG', 'cache-service', 'Cache miss for key: user_123', NULL, NULL),
(NOW() - INTERVAL 40 MINUTE, 'ERROR', 'web-api', 'Invalid authentication token', 'AUTH_003', NULL),
(NOW() - INTERVAL 45 MINUTE, 'INFO', 'notification-service', 'Push notification sent', NULL, 5),
(NOW() - INTERVAL 50 MINUTE, 'WARN', 'web-api', 'Rate limit approaching threshold', 'RATE_001', NULL);

-- Create a view for quick analytics
CREATE OR REPLACE VIEW hourly_page_views AS
SELECT 
    DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00') as hour,
    COUNT(*) as view_count,
    COUNT(DISTINCT user_id) as unique_users,
    AVG(response_time) as avg_response_time
FROM page_views
GROUP BY DATE_FORMAT(timestamp, '%Y-%m-%d %H:00:00')
ORDER BY hour DESC;

-- Create a view for system health
CREATE OR REPLACE VIEW system_health AS
SELECT 
    hostname,
    AVG(cpu_usage) as avg_cpu,
    AVG(memory_usage) as avg_memory,
    AVG(disk_usage) as avg_disk,
    MAX(cpu_usage) as max_cpu,
    MAX(memory_usage) as max_memory,
    COUNT(*) as sample_count
FROM system_metrics
WHERE timestamp > NOW() - INTERVAL 1 HOUR
GROUP BY hostname;

-- Grant permissions to grafana user
GRANT SELECT ON grafana_demo.* TO 'grafana'@'%';
FLUSH PRIVILEGES;
