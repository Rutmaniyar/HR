# UK-Compliant HR Management System

A mobile-friendly, UK-compliant HR Management System built with plain PHP (MVC architecture) and MySQL. This system supports multi-tenant single-database design with comprehensive HR features including attendance tracking, employee management, and GDPR compliance.

## Features

### Core Features
- **Multi-tenant Architecture**: Single database with company_id separation
- **Role-based Access Control**: Super admin, manager, and employee roles
- **Secure Authentication**: Password hashing (bcrypt), session management, CSRF protection
- **Mobile-Responsive Design**: Works seamlessly on all device sizes
- **White-label Branding**: Customizable company logos and colors

### Employee Management
- Employee records with work and personal details
- Employee profiles with contact information
- Department and job title tracking
- Manager assignment
- Employee number generation

### Attendance Management
- Clock-in/clock-out functionality (no GPS tracking)
- Attendance history and reports
- Manager attendance editing with full audit trail
- UK Working Time Regulations compliance (48-hour weekly limit alerts)
- Weekly hours tracking and warnings

### GDPR Compliance
- Data consent tracking
- GDPR consent management interface
- Data retention agreements
- Privacy-focused design (no GPS tracking)

### UK Working Time Regulations
- Automatic tracking of weekly working hours
- Alert system when approaching 48-hour limit
- Compliance monitoring and reporting

## Technology Stack

- **Backend**: Plain PHP 7.4+ (MVC architecture)
- **Database**: MySQL 5.7+
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Security**: Password hashing, prepared statements, CSRF protection

## Installation

### Requirements
- PHP 7.4 or higher
- MySQL 5.7 or higher
- Apache/Nginx with mod_rewrite enabled
- Web server with HTTPS support (recommended for production)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rutmaniyar/HR-System.git
   cd HR-System
   ```

2. **Configure the database**
   - Create a MySQL database:
     ```sql
     CREATE DATABASE hr_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
     ```
   - Import the database schema:
     ```bash
     mysql -u your_username -p hr_system < database/schema.sql
     ```

3. **Configure the environment**
   - Copy the example environment file:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` with your database credentials and settings:
     ```
     DB_HOST=localhost
     DB_NAME=hr_system
     DB_USER=your_username
     DB_PASSWORD=your_password
     APP_URL=http://localhost
     ```

4. **Configure the web server**
   
   **Apache (.htaccess is already configured)**
   - Ensure mod_rewrite is enabled
   - Point DocumentRoot to the `public` directory
   
   **Nginx Configuration Example:**
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       root /path/to/HR-System/public;
       index index.php;

       location / {
           try_files $uri $uri/ /index.php?url=$uri&$args;
       }

       location ~ \.php$ {
           fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
           fastcgi_index index.php;
           include fastcgi_params;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
       }
   }
   ```

5. **Set appropriate permissions**
   ```bash
   chmod -R 755 /path/to/HR-System
   chmod -R 775 /path/to/HR-System/public
   ```

6. **Access the application**
   - Navigate to your configured URL (e.g., http://localhost)
   - Default login credentials:
     - Email: `admin@system.local`
     - Password: `admin123`
   - **IMPORTANT**: Change the default password immediately after first login!

## Usage

### For Super Admins
- Manage multiple companies
- Configure white-label branding
- Create and manage users
- View system-wide reports
- Assign roles to users

### For Managers
- View and manage team members
- Edit team attendance records (with audit logging)
- View team reports
- Monitor team compliance with working time regulations

### For Employees
- Clock in/out for attendance
- View personal attendance history
- Update personal profile
- Manage GDPR consent preferences
- View working hours summary

## Security Features

- **Password Security**: Bcrypt hashing with cost factor 10
- **SQL Injection Prevention**: Prepared statements with PDO
- **XSS Protection**: Input sanitization and output escaping
- **CSRF Protection**: Token-based CSRF validation
- **Session Security**: HTTP-only cookies, secure flags
- **Access Control**: Role-based authorization checks
- **Audit Logging**: Complete audit trail for attendance modifications

## GDPR Compliance

The system is designed with GDPR compliance in mind:
- Employee consent tracking
- Data minimization (no GPS tracking)
- Purpose limitation
- Right to access data
- Audit trails for data modifications
- Secure data storage

## UK Working Time Regulations

The system helps ensure compliance with UK Working Time Regulations:
- Automatic tracking of weekly hours
- Alerts when employees work >45 hours (approaching limit)
- Hard limit notification at 48 hours
- Historical compliance reporting

## Project Structure

```
HR-System/
├── 📂 app/                          # Application source code
│   ├── 📂 controllers/              # Application controllers (MVC)
│   │   ├── Controller.php           # Base controller with auth & CSRF
│   │   ├── AuthController.php       # Login/logout/password management
│   │   ├── DashboardController.php  # Main dashboard for all roles
│   │   ├── AttendanceController.php # Clock-in/out & attendance management
│   │   ├── EmployeeController.php   # Employee CRUD operations
│   │   └── CompanyController.php    # Company management (super admin)
│   │
│   ├── 📂 models/                   # Data models (MVC)
│   │   ├── Model.php                # Base model with CRUD methods
│   │   ├── User.php                 # User authentication & management
│   │   ├── Employee.php             # Employee data operations
│   │   ├── Attendance.php           # Attendance tracking & weekly hours
│   │   └── Company.php              # Company & branding management
│   │
│   └── 📂 views/                    # View templates (MVC)
│       ├── 📂 auth/                 # Authentication views
│       │   ├── login.php            # Login page
│       │   └── change_password.php  # Password change form
│       ├── 📂 dashboard/            # Dashboard views
│       │   └── index.php            # Role-specific dashboards
│       ├── 📂 attendance/           # Attendance management views
│       │   ├── index.php            # Attendance list with filters
│       │   ├── edit.php             # Manager attendance editing
│       │   └── audit_logs.php       # Audit trail viewer
│       ├── 📂 employees/            # Employee management views
│       │   ├── index.php            # Employee list
│       │   ├── add.php              # Add new employee
│       │   ├── edit.php             # Edit employee details
│       │   ├── profile.php          # Employee profile viewer
│       │   └── gdpr_consent.php     # GDPR consent management
│       ├── 📂 companies/            # Company management views
│       │   ├── index.php            # Company list
│       │   ├── add.php              # Add new company
│       │   └── edit.php             # Edit company & branding
│       ├── 📂 errors/               # Error pages
│       │   ├── 403.php              # Access denied
│       │   └── 404.php              # Page not found
│       └── layout.php               # Master layout template
│
├── 📂 config/                       # Configuration files
│   ├── config.php                   # Main app config (loads .env)
│   ├── Database.php                 # PDO singleton connection
│   └── Router.php                   # URL routing system
│
├── 📂 database/                     # Database files
│   └── schema.sql                   # Complete DB schema with tables:
│                                    # - companies (multi-tenant)
│                                    # - users (authentication & roles)
│                                    # - employees (work & personal data)
│                                    # - attendance (clock-in/out records)
│                                    # - attendance_audit_logs (edit history)
│                                    # - sessions (session management)
│                                    # - gdpr_data_requests (GDPR compliance)
│                                    # - weekly_hours_summary (UK WTR compliance)
│
├── 📂 public/                       # Public web root (DocumentRoot)
│   ├── 📂 css/
│   │   └── style.css                # Responsive CSS framework
│   ├── 📂 js/
│   │   └── main.js                  # Frontend JavaScript utilities
│   ├── 📂 images/                   # Static images
│   ├── .htaccess                    # Apache URL rewriting rules
│   └── index.php                    # Application entry point
│
├── 📄 .env.example                  # Environment variables template
├── 📄 .gitignore                    # Git ignore patterns
│
├── 📄 README.md                     # Project overview & quick start
├── 📄 INSTALL.md                    # Detailed installation guide
├── 📄 DEPLOYMENT.md                 # 🚀 Production deployment guide
├── 📄 USER_GUIDE.md                 # Complete user manual (11,000+ words)
├── 📄 PROJECT_SUMMARY.md            # Technical architecture summary
├── 📄 QUICK_REFERENCE.md            # Quick reference card
│
└── 📄 LICENSE                       # MIT License

```

### Key Files Explained

#### Configuration Files
- **`.env`** - Environment-specific settings (not in repo, copy from .env.example)
- **`config/config.php`** - Loads environment variables and defines constants
- **`config/Database.php`** - Singleton PDO connection with prepared statements
- **`config/Router.php`** - Routes URLs to controllers using MVC pattern

#### Entry Points
- **`public/index.php`** - Main entry point, bootstraps the application
- **`public/.htaccess`** - Apache rewrite rules for clean URLs

#### Core Application
- **`app/controllers/Controller.php`** - Base controller with authentication, CSRF, sanitization
- **`app/models/Model.php`** - Base model with CRUD operations using PDO
- **`app/views/`** - All HTML templates with PHP for dynamic content

#### Documentation
- **`DEPLOYMENT.md`** - Complete production deployment guide with:
  - Pre-deployment checklist
  - Step-by-step deployment procedures
  - Web server configuration (Apache/Nginx)
  - SSL certificate setup
  - Cloud deployment (AWS, DigitalOcean, GCP)
  - Backup and monitoring setup
  - Troubleshooting and rollback procedures

### Deployment Steps Quick Reference

For detailed deployment instructions, see **[DEPLOYMENT.md](DEPLOYMENT.md)**

**Quick Deployment:**
```bash
# 1. Server Setup
sudo apt update && sudo apt install -y php7.4 php7.4-fpm php7.4-mysql mysql-server apache2

# 2. Clone Repository
cd /var/www && git clone https://github.com/Rutmaniyar/HR-System.git hr-system

# 3. Database Setup
mysql -u root -p < /var/www/hr-system/database/schema.sql

# 4. Configure
cd /var/www/hr-system
cp .env.example .env
nano .env  # Edit database credentials

# 5. Set Permissions
chown -R www-data:www-data /var/www/hr-system
chmod -R 755 /var/www/hr-system

# 6. Configure Web Server (see DEPLOYMENT.md)
# 7. Enable SSL (see DEPLOYMENT.md)
# 8. Access: https://your-domain.com
```

**Default Login:**
- Email: `admin@system.local`
- Password: `admin123`
- ⚠️ **Change immediately after first login!**

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue on GitHub or contact the development team.

## Security

If you discover any security-related issues, please email the maintainers directly instead of using the issue tracker.

## Changelog

### Version 1.0.0 (Initial Release)
- Multi-tenant architecture with company_id
- Role-based access control
- Employee management
- Attendance tracking with clock-in/clock-out
- Manager attendance editing with audit logs
- GDPR compliance features
- UK Working Time Regulations support
- Mobile-responsive design
- White-label branding support