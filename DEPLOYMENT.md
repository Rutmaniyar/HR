# Deployment Guide - UK-Compliant HR Management System

## Table of Contents
1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Deployment Environments](#deployment-environments)
3. [Step-by-Step Deployment](#step-by-step-deployment)
4. [Production Deployment](#production-deployment)
5. [Cloud Deployment](#cloud-deployment)
6. [Post-Deployment Tasks](#post-deployment-tasks)
7. [Monitoring and Maintenance](#monitoring-and-maintenance)
8. [Troubleshooting Deployment Issues](#troubleshooting-deployment-issues)
9. [Rollback Procedures](#rollback-procedures)

---

## Pre-Deployment Checklist

Before deploying, ensure you have:

### System Requirements
- [ ] PHP 7.4 or higher installed
- [ ] MySQL 5.7 or higher (or MariaDB 10.2+)
- [ ] Apache 2.4+ or Nginx web server
- [ ] SSL certificate for HTTPS (production)
- [ ] Domain name configured (production)
- [ ] Required PHP extensions: PDO, PDO_MySQL, mbstring, json
- [ ] Sufficient disk space (minimum 500MB)
- [ ] Sufficient RAM (minimum 1GB)

### Security Requirements
- [ ] SSL/TLS certificate obtained
- [ ] Firewall configured
- [ ] Strong database passwords generated
- [ ] Default admin password changed plan
- [ ] Backup strategy in place
- [ ] Security updates scheduled

### Access Requirements
- [ ] SSH access to server
- [ ] Database admin credentials
- [ ] Domain DNS configured
- [ ] Web server admin access
- [ ] File system permissions planned

---

## Deployment Environments

### Development Environment
```bash
# Local machine or development server
APP_ENV=development
APP_URL=http://localhost
# Display errors enabled
# Debug mode enabled
```

### Staging Environment
```bash
# Pre-production testing server
APP_ENV=staging
APP_URL=https://staging.your-domain.com
# Similar to production but with test data
# Error logging enabled
```

### Production Environment
```bash
# Live production server
APP_ENV=production
APP_URL=https://your-domain.com
# Error display disabled
# All security features enabled
# Performance optimized
```

---

## Step-by-Step Deployment

### Phase 1: Server Preparation

#### 1.1 Update System Packages
```bash
# Ubuntu/Debian
sudo apt update
sudo apt upgrade -y

# CentOS/RHEL
sudo yum update -y
```

#### 1.2 Install Required Software

**PHP Installation:**
```bash
# Ubuntu/Debian
sudo apt install -y php7.4 php7.4-cli php7.4-fpm php7.4-mysql \
    php7.4-mbstring php7.4-json php7.4-xml php7.4-curl

# CentOS/RHEL
sudo yum install -y php php-cli php-fpm php-mysql \
    php-mbstring php-json php-xml php-curl
```

**MySQL Installation:**
```bash
# Ubuntu/Debian
sudo apt install -y mysql-server

# CentOS/RHEL
sudo yum install -y mysql-server

# Start and enable MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation
sudo mysql_secure_installation
```

**Web Server Installation:**

**Apache:**
```bash
# Ubuntu/Debian
sudo apt install -y apache2

# Enable required modules
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2
```

**Nginx:**
```bash
# Ubuntu/Debian
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Phase 2: Application Deployment

#### 2.1 Create Application Directory
```bash
# Create directory for the application
sudo mkdir -p /var/www/hr-system
cd /var/www/hr-system
```

#### 2.2 Deploy Application Files

**Option A: From Git Repository**
```bash
# Clone the repository
sudo git clone https://github.com/Rutmaniyar/HR-System.git .

# Or pull latest changes
sudo git pull origin main
```

**Option B: From Archive**
```bash
# Upload and extract archive
sudo tar -xzf hr-system.tar.gz -C /var/www/hr-system
```

**Option C: From FTP/SFTP**
```bash
# Use FileZilla, WinSCP, or command line
sftp user@your-server.com
put -r /local/path/HR-System/* /var/www/hr-system/
```

#### 2.3 Set File Permissions
```bash
# Set ownership to web server user
sudo chown -R www-data:www-data /var/www/hr-system

# Set directory permissions
sudo find /var/www/hr-system -type d -exec chmod 755 {} \;

# Set file permissions
sudo find /var/www/hr-system -type f -exec chmod 644 {} \;

# Ensure public directory is executable
sudo chmod -R 755 /var/www/hr-system/public

# Secure sensitive files
sudo chmod 600 /var/www/hr-system/.env
```

### Phase 3: Database Setup

#### 3.1 Create Database and User
```bash
# Login to MySQL
sudo mysql -u root -p

# Execute SQL commands
```

```sql
-- Create database
CREATE DATABASE hr_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create dedicated user
CREATE USER 'hr_user'@'localhost' IDENTIFIED BY 'strong_password_here';

-- Grant privileges
GRANT ALL PRIVILEGES ON hr_system.* TO 'hr_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Exit MySQL
EXIT;
```

#### 3.2 Import Database Schema
```bash
# Import the database schema
mysql -u hr_user -p hr_system < /var/www/hr-system/database/schema.sql

# Verify tables were created
mysql -u hr_user -p hr_system -e "SHOW TABLES;"
```

### Phase 4: Configuration

#### 4.1 Configure Environment
```bash
# Copy example environment file
cd /var/www/hr-system
sudo cp .env.example .env

# Edit configuration (use nano, vim, or any editor)
sudo nano .env
```

**Production .env Configuration:**
```env
# Database Configuration
DB_HOST=localhost
DB_NAME=hr_system
DB_USER=hr_user
DB_PASSWORD=your_strong_database_password
DB_CHARSET=utf8mb4

# Application Configuration
APP_NAME="Your Company HR System"
APP_URL=https://hr.your-domain.com
APP_ENV=production

# Session Configuration
SESSION_LIFETIME=7200
SESSION_NAME=hr_session_prod

# Security
CSRF_TOKEN_NAME=csrf_token
PASSWORD_HASH_ALGO=PASSWORD_BCRYPT

# Timezone (UK)
TIMEZONE=Europe/London

# UK Working Time Regulations
MAX_WEEKLY_HOURS=48
ALERT_THRESHOLD_HOURS=45
```

#### 4.2 Secure Configuration File
```bash
# Restrict access to .env file
sudo chmod 600 /var/www/hr-system/.env
sudo chown www-data:www-data /var/www/hr-system/.env
```

### Phase 5: Web Server Configuration

#### 5.1 Apache Configuration

**Create Virtual Host:**
```bash
sudo nano /etc/apache2/sites-available/hr-system.conf
```

**HTTP Configuration (for redirect to HTTPS):**
```apache
<VirtualHost *:80>
    ServerName hr.your-domain.com
    ServerAdmin admin@your-domain.com
    
    # Redirect all HTTP to HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
    
    ErrorLog ${APACHE_LOG_DIR}/hr-system-error.log
    CustomLog ${APACHE_LOG_DIR}/hr-system-access.log combined
</VirtualHost>
```

**HTTPS Configuration:**
```apache
<VirtualHost *:443>
    ServerName hr.your-domain.com
    ServerAdmin admin@your-domain.com
    DocumentRoot /var/www/hr-system/public
    
    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/your-domain.crt
    SSLCertificateKeyFile /etc/ssl/private/your-domain.key
    SSLCertificateChainFile /etc/ssl/certs/your-domain-chain.crt
    
    <Directory /var/www/hr-system/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Additional security headers
        Header always set X-Frame-Options "SAMEORIGIN"
        Header always set X-Content-Type-Options "nosniff"
        Header always set X-XSS-Protection "1; mode=block"
        Header always set Referrer-Policy "strict-origin-when-cross-origin"
    </Directory>
    
    # Deny access to sensitive files
    <FilesMatch "^\.">
        Require all denied
    </FilesMatch>
    
    <FilesMatch "\.(env|sql|md|git)$">
        Require all denied
    </FilesMatch>
    
    ErrorLog ${APACHE_LOG_DIR}/hr-system-ssl-error.log
    CustomLog ${APACHE_LOG_DIR}/hr-system-ssl-access.log combined
</VirtualHost>
```

**Enable Site and Restart:**
```bash
# Enable the site
sudo a2ensite hr-system.conf

# Test configuration
sudo apache2ctl configtest

# Restart Apache
sudo systemctl restart apache2
```

#### 5.2 Nginx Configuration

**Create Server Block:**
```bash
sudo nano /etc/nginx/sites-available/hr-system
```

**Configuration:**
```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name hr.your-domain.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS Server
server {
    listen 443 ssl http2;
    server_name hr.your-domain.com;
    root /var/www/hr-system/public;
    
    index index.php;
    
    # SSL Configuration
    ssl_certificate /etc/ssl/certs/your-domain.crt;
    ssl_certificate_key /etc/ssl/private/your-domain.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Logging
    access_log /var/log/nginx/hr-system-access.log;
    error_log /var/log/nginx/hr-system-error.log;
    
    # Main location
    location / {
        try_files $uri $uri/ /index.php?url=$uri&$args;
    }
    
    # PHP Processing
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        
        # Security
        fastcgi_param PHP_VALUE "upload_max_filesize=10M \n post_max_size=10M";
        fastcgi_param HTTP_PROXY "";
    }
    
    # Deny access to sensitive files
    location ~ /\. {
        deny all;
    }
    
    location ~ \.(env|sql|md|git)$ {
        deny all;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

**Enable Site and Restart:**
```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/hr-system /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### Phase 6: SSL Certificate Setup

#### 6.1 Using Let's Encrypt (Free SSL)

**Install Certbot:**
```bash
# Ubuntu/Debian
sudo apt install -y certbot python3-certbot-apache  # For Apache
# OR
sudo apt install -y certbot python3-certbot-nginx   # For Nginx
```

**Obtain Certificate:**
```bash
# For Apache
sudo certbot --apache -d hr.your-domain.com

# For Nginx
sudo certbot --nginx -d hr.your-domain.com

# Follow the prompts
# Choose to redirect HTTP to HTTPS when asked
```

**Auto-Renewal:**
```bash
# Test auto-renewal
sudo certbot renew --dry-run

# Certbot automatically sets up renewal via cron/systemd
```

---

## Production Deployment

### Production-Specific Configuration

#### 1. Update PHP Configuration for Production
```bash
# Edit php.ini
sudo nano /etc/php/7.4/fpm/php.ini
```

**Key Settings:**
```ini
; Security
expose_php = Off
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = /var/log/php/error.log

; Performance
memory_limit = 256M
max_execution_time = 60
upload_max_filesize = 10M
post_max_size = 10M

; Session Security
session.cookie_httponly = 1
session.cookie_secure = 1
session.use_only_cookies = 1

; OPcache (Performance)
opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 10000
opcache.validate_timestamps = 0
```

#### 2. Configure Session Settings in Code
```bash
# Edit config/config.php to ensure production settings
sudo nano /var/www/hr-system/config/config.php
```

Ensure these lines are uncommented for production:
```php
ini_set('session.cookie_secure', 1);  // Require HTTPS
```

#### 3. Database Optimization
```sql
-- Login to MySQL
mysql -u root -p

-- Optimize tables
USE hr_system;
OPTIMIZE TABLE companies, users, employees, attendance, attendance_audit_logs;

-- Add indexes if needed (already in schema)
SHOW INDEX FROM attendance;
```

---

## Cloud Deployment

### AWS Deployment

#### EC2 Instance Setup
```bash
# 1. Launch EC2 instance (Ubuntu 20.04 LTS recommended)
# 2. Configure security group:
#    - Port 22 (SSH) - Your IP only
#    - Port 80 (HTTP) - 0.0.0.0/0
#    - Port 443 (HTTPS) - 0.0.0.0/0
#    - Port 3306 (MySQL) - Localhost only

# 3. Connect to instance
ssh -i your-key.pem ubuntu@your-instance-ip

# 4. Follow standard deployment steps above
```

#### RDS for Database (Optional)
```bash
# 1. Create RDS MySQL instance
# 2. Configure security group for EC2 access
# 3. Update .env with RDS endpoint:
DB_HOST=your-rds-endpoint.region.rds.amazonaws.com
```

### DigitalOcean Deployment

```bash
# 1. Create Droplet (Ubuntu 20.04)
# 2. Add domain to Networking
# 3. SSH into droplet
ssh root@your-droplet-ip

# 4. Follow standard deployment steps
```

### Google Cloud Platform

```bash
# 1. Create Compute Engine instance
# 2. Configure firewall rules
# 3. SSH into instance
gcloud compute ssh your-instance-name

# 4. Follow standard deployment steps
```

---

## Post-Deployment Tasks

### 1. Security Hardening

```bash
# Configure firewall (UFW)
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'  # or 'Nginx Full'
sudo ufw enable

# Install fail2ban
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 2. Initial System Configuration

```bash
# Access the system
https://hr.your-domain.com

# Login with default credentials
Email: admin@system.local
Password: admin123

# IMMEDIATELY:
# 1. Change admin password
# 2. Update admin email
# 3. Create your first company
# 4. Add employees
```

### 3. Setup Automated Backups

**Database Backup Script:**
```bash
# Create backup script
sudo nano /usr/local/bin/backup-hr-system.sh
```

```bash
#!/bin/bash
# HR System Backup Script

BACKUP_DIR="/var/backups/hr-system"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="hr_system"
DB_USER="hr_user"
DB_PASS="your_password"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz

# Backup files
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz /var/www/hr-system

# Keep only last 7 days of backups
find $BACKUP_DIR -type f -mtime +7 -delete

# Output status
echo "Backup completed: $DATE"
```

**Make executable and schedule:**
```bash
# Make script executable
sudo chmod +x /usr/local/bin/backup-hr-system.sh

# Add to crontab (daily at 2 AM)
sudo crontab -e

# Add this line:
0 2 * * * /usr/local/bin/backup-hr-system.sh >> /var/log/hr-backup.log 2>&1
```

### 4. Setup Monitoring

```bash
# Install monitoring tools
sudo apt install -y htop iotop nethogs

# Setup log rotation
sudo nano /etc/logrotate.d/hr-system
```

```
/var/log/nginx/hr-system-*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload nginx > /dev/null 2>&1
    endscript
}
```

---

## Monitoring and Maintenance

### Daily Checks
- [ ] Check application is accessible
- [ ] Review error logs
- [ ] Check disk space
- [ ] Verify backups completed

### Weekly Checks
- [ ] Review system performance
- [ ] Check for security updates
- [ ] Review user activity
- [ ] Test backup restoration

### Monthly Checks
- [ ] Update system packages
- [ ] Review and rotate logs
- [ ] Performance optimization
- [ ] Security audit

### Monitoring Commands

```bash
# Check system resources
htop
df -h

# Check web server status
sudo systemctl status apache2  # or nginx
sudo systemctl status mysql

# View application logs
sudo tail -f /var/log/nginx/hr-system-error.log
sudo tail -f /var/log/apache2/hr-system-error.log

# Check PHP-FPM status
sudo systemctl status php7.4-fpm

# Database status
mysql -u hr_user -p -e "SHOW PROCESSLIST;"
```

---

## Troubleshooting Deployment Issues

### Issue: 500 Internal Server Error

**Check:**
```bash
# Check PHP error logs
sudo tail -f /var/log/php7.4-fpm.log

# Check web server error log
sudo tail -f /var/log/nginx/hr-system-error.log

# Check file permissions
ls -la /var/www/hr-system/

# Verify .env file exists
cat /var/www/hr-system/.env
```

### Issue: Database Connection Failed

**Check:**
```bash
# Test database connection
mysql -u hr_user -p hr_system

# Check MySQL is running
sudo systemctl status mysql

# Verify credentials in .env
grep DB_ /var/www/hr-system/.env
```

### Issue: 404 on All Pages

**Apache:**
```bash
# Check mod_rewrite is enabled
sudo a2enmod rewrite
sudo systemctl restart apache2

# Check .htaccess is present
ls -la /var/www/hr-system/public/.htaccess
```

**Nginx:**
```bash
# Check configuration syntax
sudo nginx -t

# Verify location block
sudo nano /etc/nginx/sites-available/hr-system
```

### Issue: Permission Denied

```bash
# Fix ownership
sudo chown -R www-data:www-data /var/www/hr-system

# Fix permissions
sudo find /var/www/hr-system -type d -exec chmod 755 {} \;
sudo find /var/www/hr-system -type f -exec chmod 644 {} \;
sudo chmod 755 /var/www/hr-system/public
```

---

## Rollback Procedures

### Rollback Database

```bash
# Restore from backup
gunzip < /var/backups/hr-system/db_backup_YYYYMMDD_HHMMSS.sql.gz | \
    mysql -u hr_user -p hr_system
```

### Rollback Application Files

```bash
# From Git
cd /var/www/hr-system
sudo git checkout <previous-commit-hash>

# From Backup
sudo tar -xzf /var/backups/hr-system/files_backup_YYYYMMDD_HHMMSS.tar.gz -C /
```

### Emergency Maintenance Mode

Create a maintenance page:
```bash
sudo nano /var/www/hr-system/public/maintenance.html
```

```html
<!DOCTYPE html>
<html>
<head>
    <title>System Maintenance</title>
</head>
<body style="text-align: center; padding: 50px;">
    <h1>System Under Maintenance</h1>
    <p>We'll be back shortly. Please check back in a few minutes.</p>
</body>
</html>
```

Redirect all traffic:
```bash
# In web server config, temporarily redirect all to maintenance page
```

---

## Deployment Checklist

### Pre-Deployment
- [ ] Code tested locally
- [ ] Database backup created
- [ ] Server requirements met
- [ ] SSL certificate obtained
- [ ] Domain DNS configured
- [ ] Firewall rules planned

### During Deployment
- [ ] Files uploaded
- [ ] Permissions set correctly
- [ ] Database created and imported
- [ ] .env configured
- [ ] Web server configured
- [ ] SSL enabled
- [ ] Test access to application

### Post-Deployment
- [ ] Default password changed
- [ ] Admin account configured
- [ ] Backups scheduled
- [ ] Monitoring setup
- [ ] Documentation updated
- [ ] Team notified
- [ ] User training scheduled

---

## Support

For deployment issues:
- Check INSTALL.md for detailed installation steps
- Review server logs for specific errors
- Consult USER_GUIDE.md for application usage
- Open GitHub issue for deployment problems

---

**Deployment Version**: 1.0.0  
**Last Updated**: January 2026  
**Status**: Production Ready ✓
