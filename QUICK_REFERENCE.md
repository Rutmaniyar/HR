# Quick Reference Card

## Default Login
```
Email: admin@system.local
Password: admin123
⚠️ CHANGE IMMEDIATELY AFTER FIRST LOGIN
```

## Common URLs
```
Dashboard:        /dashboard
Attendance:       /attendance
Employees:        /employee
Companies:        /company (super admin only)
Profile:          /employee/profile
Change Password:  /auth/changePassword
GDPR Consent:     /employee/gdprConsent
Logout:           /auth/logout
```

## Quick Tasks

### Clock In/Out
1. Go to Dashboard
2. Click "Clock In" or "Clock Out" button
3. Confirm action

### Add Employee (Manager/Admin)
1. Navigate to "Employees"
2. Click "Add Employee"
3. Fill in details (username, email, password, name)
4. Set role and work details
5. Click "Add Employee"

### Edit Attendance (Manager)
1. Go to "Attendance"
2. Find record to edit
3. Click "Edit"
4. Change times
5. Provide reason (required)
6. Click "Save Changes"

### View Audit Logs
1. Go to "Attendance"
2. Find record marked "edited"
3. Click "Audit" button

### Manage GDPR Consent
1. Go to your Profile
2. Click "Manage GDPR Consent"
3. Review information
4. Check consent box
5. Click "Update Consent"

### Add Company (Super Admin)
1. Navigate to "Companies"
2. Click "Add Company"
3. Enter company name and code
4. Set branding colors
5. Click "Add Company"

## Database Tables

```
companies              - Company information
users                  - User accounts
employees              - Employee records
attendance             - Clock-in/out records
attendance_audit_logs  - Edit history
sessions               - Session data
gdpr_data_requests     - GDPR requests
weekly_hours_summary   - Weekly hours tracking
```

## User Roles & Permissions

### Super Admin
✓ All system access
✓ Manage companies
✓ Manage all employees
✓ View all attendance
✓ Edit all attendance
✓ Configure branding

### Manager
✓ Manage team members
✓ Add employees
✓ View team attendance
✓ Edit team attendance
✓ View own profile
✓ Clock in/out

### Employee
✓ View own profile
✓ Clock in/out
✓ View own attendance
✓ Manage GDPR consent
✓ Change password

## UK Regulations

### Working Time Limits
- Maximum: 48 hours/week
- Warning: 45 hours/week
- System alerts automatically

### GDPR Rights
- Access your data
- Correct inaccurate data
- Request data deletion
- Withdraw consent
- Data portability

## Security Best Practices

✓ Use strong passwords (8+ characters)
✓ Change default password immediately
✓ Don't share your account
✓ Log out when finished
✓ Report suspicious activity
✓ Keep contact details current

## Troubleshooting

### Can't Login
- Check username/email
- Verify password (case-sensitive)
- Check Caps Lock
- Contact admin for reset

### Can't Clock In
- Ensure you're not already clocked in
- Check internet connection
- Refresh page and try again

### Missing Records
- Check date filters
- Verify you clocked in/out
- Contact manager to verify

### Changes Not Saving
- Fill all required fields
- Check data format (email, dates)
- Verify internet connection

## Support Contacts

- Technical Issues: IT Department
- HR Questions: HR Department
- Policy Questions: Manager
- Security Concerns: IT/Security Team

## File Locations

```
Configuration:  .env
Database:       database/schema.sql
Documentation:  README.md, INSTALL.md, USER_GUIDE.md
Web Root:       public/
Entry Point:    public/index.php
```

## Environment Variables

```env
DB_HOST=localhost          # Database host
DB_NAME=hr_system          # Database name
DB_USER=hr_user            # Database user
DB_PASSWORD=password       # Database password
APP_URL=http://localhost   # Application URL
TIMEZONE=Europe/London     # UK timezone
MAX_WEEKLY_HOURS=48        # Weekly hour limit
ALERT_THRESHOLD_HOURS=45   # Warning threshold
```

## Installation Quick Start

```bash
# 1. Clone repo
git clone https://github.com/Rutmaniyar/HR-System.git

# 2. Create database
mysql -u root -p -e "CREATE DATABASE hr_system"

# 3. Import schema
mysql -u root -p hr_system < database/schema.sql

# 4. Configure
cp .env.example .env
nano .env

# 5. Set permissions
chmod -R 755 .
chmod -R 775 public/

# 6. Access system
http://your-domain.com
```

## Backup Commands

```bash
# Database backup
mysqldump -u hr_user -p hr_system > backup.sql

# Full system backup
tar -czf hr_backup.tar.gz /path/to/HR-System

# Restore database
mysql -u hr_user -p hr_system < backup.sql
```

## Keyboard Shortcuts

```
Dashboard:  Alt+D (in some browsers)
Profile:    Alt+P
Attendance: Alt+A
Logout:     Alt+L
```

## Date Format

All dates displayed in UK format:
```
dd/mm/yyyy  (e.g., 04/01/2026)
HH:mm       (e.g., 14:30)
```

## Status Indicators

### Attendance Status
- 🟢 clocked_in   - Currently working
- ✅ clocked_out  - Completed shift
- ⚠️ edited       - Modified by manager

### User Status
- 🟢 active      - Can login
- 🔴 inactive    - Cannot login
- ⚠️ suspended   - Temporarily disabled

### Company Status
- 🟢 active      - Operational
- 🔴 inactive    - Not operational

## Important Notes

⚠️ Change default password immediately
⚠️ Grant GDPR consent when prompted
⚠️ Clock out before leaving work
⚠️ Monitor your weekly hours
⚠️ Keep personal details updated
⚠️ Report attendance discrepancies immediately

## Version Information

```
Version: 1.0.0
Release: January 2026
Status: Production Ready
License: MIT
```

---

For detailed information, see:
- **README.md** - Project overview
- **INSTALL.md** - Installation guide
- **USER_GUIDE.md** - Complete user manual
- **PROJECT_SUMMARY.md** - Technical summary
