# Installation and Setup Guide

> **For Production Deployment**: See [DEPLOYMENT.md](DEPLOYMENT.md) for complete production deployment guide with SSL, cloud deployment, monitoring, and maintenance procedures.

> **Quick Reference**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common tasks and shortcuts.

## Prerequisites

Before installing the HR Management System, ensure you have the following:

- **PHP 7.4 or higher**
- **MySQL 5.7 or higher** (or MariaDB 10.2+)
- **Apache 2.4** or **Nginx** web server
- **mod_rewrite enabled** (for Apache)
- **PHP Extensions**: PDO, PDO_MySQL, mbstring, json

## Step-by-Step Installation

### 1. Download/Clone the Repository

```bash
git clone https://github.com/Rutmaniyar/HR-System.git
cd HR-System
```

### 2. Database Setup

#### Create Database

Login to MySQL:
```bash
mysql -u root -p
```

Create the database:
```sql
CREATE DATABASE hr_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'hr_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON hr_system.* TO 'hr_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### Import Database Schema

```bash
mysql -u hr_user -p hr_system < database/schema.sql
```

This will create all necessary tables and insert the default super admin account.

### 3. Configure Environment

Copy the example environment file:
```bash
cp .env.example .env
```

Edit `.env` with your settings:
```env
# Database Configuration
DB_HOST=localhost
DB_NAME=hr_system
DB_USER=hr_user
DB_PASSWORD=your_secure_password
DB_CHARSET=utf8mb4

# Application Configuration
APP_NAME="HR Management System"
APP_URL=http://localhost
APP_ENV=development

# Session Configuration
SESSION_LIFETIME=7200
SESSION_NAME=hr_session

# Security
CSRF_TOKEN_NAME=csrf_token
PASSWORD_HASH_ALGO=PASSWORD_BCRYPT

# Timezone (UK)
TIMEZONE=Europe/London

# UK Working Time Regulations
MAX_WEEKLY_HOURS=48
ALERT_THRESHOLD_HOURS=45
```

### 4. Web Server Configuration

#### Apache Configuration

The `.htaccess` file is already included in the `public` directory. Ensure mod_rewrite is enabled:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

Configure your Apache virtual host:

```apache
<VirtualHost *:80>
    ServerName hr-system.local
    DocumentRoot /path/to/HR-System/public
    
    <Directory /path/to/HR-System/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/hr-system-error.log
    CustomLog ${APACHE_LOG_DIR}/hr-system-access.log combined
</VirtualHost>
```

#### Nginx Configuration

Create a new site configuration:

```nginx
server {
    listen 80;
    server_name hr-system.local;
    root /path/to/HR-System/public;
    
    index index.php;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    location / {
        try_files $uri $uri/ /index.php?url=$uri&$args;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    location ~ /\.(?!well-known).* {
        deny all;
    }
    
    access_log /var/log/nginx/hr-system-access.log;
    error_log /var/log/nginx/hr-system-error.log;
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/hr-system /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Set Permissions

```bash
# Set ownership (replace www-data with your web server user)
sudo chown -R www-data:www-data /path/to/HR-System

# Set directory permissions
sudo find /path/to/HR-System -type d -exec chmod 755 {} \;

# Set file permissions
sudo find /path/to/HR-System -type f -exec chmod 644 {} \;

# Ensure public directory is accessible
sudo chmod -R 755 /path/to/HR-System/public
```

### 6. Update Hosts File (for local development)

If testing locally, add this to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):

```
127.0.0.1    hr-system.local
```

### 7. Access the Application

Open your web browser and navigate to:
```
http://hr-system.local
```

Or if using localhost:
```
http://localhost
```

## Default Login Credentials

**IMPORTANT**: Change these immediately after first login!

- **Email**: `admin@system.local`
- **Password**: `admin123`
- **Role**: Super Admin

## First Steps After Installation

### 1. Change Default Password

1. Login with the default credentials
2. Navigate to your profile
3. Click "Change Password"
4. Set a strong password (minimum 8 characters)

### 2. Create Your First Company

1. Navigate to "Companies" in the menu
2. Click "Add Company"
3. Fill in:
   - Company Name
   - Company Code (unique identifier)
   - Contact details
   - White-label branding colors
4. Click "Add Company"

### 3. Add Employees

1. Navigate to "Employees"
2. Click "Add Employee"
3. Fill in the required information:
   - Account details (username, email, password, role)
   - Personal details (name)
   - Work details (job title, department, start date)
   - Contracted hours per week
4. Click "Add Employee"

### 4. GDPR Consent

Each employee should:
1. Login to their account
2. Navigate to Profile
3. Click "Manage GDPR Consent"
4. Review the information
5. Grant consent if they agree

## Production Deployment

For production environments, follow these additional steps:

### 1. Update Environment

Edit `.env`:
```env
APP_ENV=production
APP_URL=https://your-domain.com
```

### 2. Enable HTTPS

Install SSL certificate (Let's Encrypt example):

```bash
sudo apt-get install certbot python3-certbot-apache
sudo certbot --apache -d your-domain.com
```

For Nginx:
```bash
sudo certbot --nginx -d your-domain.com
```

### 3. Update Session Settings

In `config/config.php`, ensure secure session settings:
```php
ini_set('session.cookie_secure', 1);  // Require HTTPS
```

### 4. Security Hardening

1. **Disable directory listing** (already configured)
2. **Hide PHP version**:
   ```
   # In php.ini
   expose_php = Off
   ```
3. **Restrict file uploads** (if implementing file upload feature)
4. **Regular backups**: Set up automated database backups
5. **Update regularly**: Keep PHP and MySQL updated

### 5. Performance Optimization

1. **Enable OPcache**:
   ```
   # In php.ini
   opcache.enable=1
   opcache.memory_consumption=128
   opcache.max_accelerated_files=10000
   ```

2. **Database optimization**:
   - Add indexes as needed
   - Regular maintenance
   - Monitor slow queries

## Troubleshooting

### Issue: 404 Error on All Pages

**Solution**: Ensure mod_rewrite is enabled (Apache) or URL rewriting is configured (Nginx)

### Issue: Database Connection Failed

**Solution**: 
1. Check `.env` database credentials
2. Verify MySQL service is running: `sudo systemctl status mysql`
3. Test connection: `mysql -u hr_user -p hr_system`

### Issue: Permission Denied Errors

**Solution**:
```bash
sudo chown -R www-data:www-data /path/to/HR-System
sudo chmod -R 755 /path/to/HR-System
```

### Issue: Sessions Not Working

**Solution**:
1. Check PHP session directory permissions
2. Verify session settings in `php.ini`
3. Clear browser cookies

### Issue: CSRF Token Mismatch

**Solution**:
1. Clear browser cache and cookies
2. Check that session is working properly
3. Verify `.env` file exists and is readable

## Backup and Restore

### Database Backup

```bash
# Create backup
mysqldump -u hr_user -p hr_system > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore from backup
mysql -u hr_user -p hr_system < backup_20240104_120000.sql
```

### Full System Backup

```bash
# Backup entire application
tar -czf hr_system_backup_$(date +%Y%m%d).tar.gz /path/to/HR-System
```

## Upgrading

When upgrading to a new version:

1. **Backup**: Always backup database and files first
2. **Read changelog**: Check for breaking changes
3. **Update files**: Pull/download new version
4. **Run migrations**: Execute any new SQL updates
5. **Test**: Verify everything works in staging first
6. **Deploy**: Update production environment

## Support

For issues and support:
- GitHub Issues: https://github.com/Rutmaniyar/HR-System/issues
- Documentation: See README.md
- Email: Contact your system administrator

## Security

If you discover a security vulnerability:
- **DO NOT** open a public issue
- Email the maintainers directly
- Provide details and steps to reproduce

## Additional Resources

- PHP Documentation: https://www.php.net/manual/
- MySQL Documentation: https://dev.mysql.com/doc/
- GDPR Information: https://ico.org.uk/for-organisations/guide-to-data-protection/
- UK Working Time Regulations: https://www.gov.uk/maximum-weekly-working-hours
