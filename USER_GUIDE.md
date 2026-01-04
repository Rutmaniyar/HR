# User Guide - HR Management System

## Table of Contents

1. [Getting Started](#getting-started)
2. [User Roles](#user-roles)
3. [Login and Authentication](#login-and-authentication)
4. [Dashboard](#dashboard)
5. [Attendance Management](#attendance-management)
6. [Employee Management](#employee-management)
7. [Company Management](#company-management)
8. [GDPR Compliance](#gdpr-compliance)
9. [UK Working Time Regulations](#uk-working-time-regulations)
10. [Troubleshooting](#troubleshooting)

## Getting Started

The HR Management System is a comprehensive solution for managing employee information, attendance tracking, and ensuring compliance with UK regulations including GDPR and Working Time Regulations.

### Accessing the System

1. Open your web browser
2. Navigate to your HR system URL
3. Enter your login credentials
4. Click "Login"

## User Roles

The system supports three user roles with different permissions:

### Super Admin
- Full system access
- Manage multiple companies
- Configure white-label branding
- Add/edit/delete employees
- View all attendance records
- Edit attendance with audit logging
- Access system-wide reports

### Manager
- Manage team members
- View team attendance
- Edit team attendance records (with audit trail)
- Add new employees
- View own attendance and profile

### Employee
- View own profile
- Clock in/out for attendance
- View own attendance history
- Manage GDPR consent
- Change password

## Login and Authentication

### First Login

If this is your first time logging in:

1. Use credentials provided by your administrator
2. You will be prompted to change your password
3. Set a strong password (minimum 8 characters)

### Changing Password

To change your password:

1. Click your username in the navigation menu
2. Select "Change Password"
3. Enter your current password
4. Enter and confirm your new password
5. Click "Change Password"

**Password Requirements**:
- Minimum 8 characters
- Mix of letters, numbers recommended
- Avoid common words

### Forgot Password

Contact your system administrator to reset your password.

## Dashboard

The dashboard is your main hub and displays different information based on your role.

### Employee/Manager Dashboard

**Key Information Displayed**:
- Hours worked this week
- Current clock-in status
- Today's attendance
- Weekly hour warnings (if approaching 48-hour limit)

**Quick Actions**:
- Clock In/Out button
- View attendance records
- Access profile

### Super Admin Dashboard

**Key Information Displayed**:
- Total companies
- Total users
- Recent company additions
- System overview

## Attendance Management

### Clocking In/Out (Employees)

#### Clock In

1. Go to Dashboard
2. Click the green "Clock In" button
3. Confirm the action
4. You'll see your clock-in time displayed

#### Clock Out

1. Go to Dashboard
2. Click the red "Clock Out" button
3. Confirm the action
4. Total hours worked will be displayed

**Important Notes**:
- You can only have one active clock-in session
- The system does NOT track GPS location (privacy-focused)
- Your IP address and browser are recorded for security
- Clock-in/out times are in UK timezone (Europe/London)

### Viewing Attendance Records

1. Navigate to "Attendance" in the menu
2. Use date filters to view specific periods:
   - Start Date
   - End Date
3. Click "Filter" to apply

**Attendance Information Displayed**:
- Date and time of clock-in
- Clock-out time (if applicable)
- Total hours worked
- Status (clocked_in, clocked_out, edited)

### Editing Attendance (Managers/Admins Only)

Managers can edit team member attendance records:

1. Navigate to "Attendance"
2. Find the record to edit
3. Click "Edit" button
4. Modify:
   - Clock-in time
   - Clock-out time
5. **Provide a reason** (required for audit trail)
6. Click "Save Changes"

**Audit Trail**:
- All edits are logged
- Original values are preserved
- Editor's name is recorded
- Reason for edit is stored
- Timestamp of modification

### Viewing Audit Logs

To view attendance edit history:

1. Go to "Attendance"
2. Find a record marked as "edited"
3. Click "Audit" button
4. View complete edit history including:
   - Date/time of edit
   - Field changed
   - Old and new values
   - Who made the change
   - Reason provided

## Employee Management

### Viewing Employees (Managers/Admins)

1. Navigate to "Employees"
2. View list of all employees
3. See employee number, name, job title, department, status

### Adding New Employee (Managers/Admins)

1. Click "Add Employee" button
2. Fill in required information:

**Account Details**:
- Username (unique)
- Email (unique)
- Password (min 8 characters)
- Role (Employee/Manager/Super Admin)

**Personal Details**:
- First Name
- Last Name

**Work Details**:
- Job Title
- Department
- Start Date
- Employment Type (Full Time/Part Time/Contract/Temporary)
- Contracted Hours per Week (default 40, max 48)

3. Click "Add Employee"

**Note**: Employee number is automatically generated (format: EMP000001)

### Viewing Employee Profile

1. Navigate to "Employees" (or click "Profile" for your own)
2. Click "View" next to employee name
3. View comprehensive information:
   - Personal information
   - Contact details
   - Work details
   - GDPR compliance status

### Editing Employee Information

1. Go to employee profile
2. Click "Edit Profile"
3. Update information as needed:
   - Personal details
   - Contact information
   - Work details
4. Click "Save Changes"

**Note**: Username, email, and employee number cannot be changed via this form. Contact system administrator for these changes.

## Company Management (Super Admin Only)

### Viewing Companies

1. Navigate to "Companies"
2. View list of all companies
3. See company name, code, status, created date

### Adding New Company

1. Click "Add Company"
2. Fill in information:

**Company Information**:
- Company Name
- Company Code (unique, uppercase)
- Email
- Phone
- Address

**White-Label Branding**:
- Primary Color (for navigation, buttons)
- Secondary Color (for secondary elements)

3. Click "Add Company"

### Editing Company

1. Go to "Companies"
2. Click "Edit" next to company name
3. Update information
4. Modify branding colors if needed
5. Change status (Active/Inactive)
6. Click "Save Changes"

**Note**: Company code cannot be changed after creation.

## GDPR Compliance

The system is designed with GDPR compliance in mind. All employees should manage their data consent.

### Managing GDPR Consent

1. Navigate to your Profile
2. Click "Manage GDPR Consent"
3. Review the data protection information
4. Check the consent checkbox if you agree
5. Click "Update Consent"

### Your GDPR Rights

You have the right to:

1. **Access**: View your personal data at any time
2. **Rectification**: Request correction of inaccurate data
3. **Erasure**: Request deletion of your data (right to be forgotten)
4. **Data Portability**: Request a copy of your data
5. **Withdraw Consent**: Withdraw consent at any time

**To Exercise Your Rights**:
Contact your HR department or Data Protection Officer.

### What Data We Collect

- Personal information (name, contact details)
- Employment information (job title, department)
- Attendance records (clock-in/out times, IP address)
- User activity (login times)

### How We Use Your Data

- HR management and administration
- Attendance tracking and payroll
- Compliance with employment law
- Security and system integrity

## UK Working Time Regulations

The system helps ensure compliance with UK Working Time Regulations.

### 48-Hour Weekly Limit

**The Law**:
- Workers should not work more than 48 hours per week on average
- This is averaged over a 17-week period
- Workers can opt out, but should not be pressured

**How the System Helps**:
- Tracks weekly hours automatically
- Shows warning at 45 hours (approaching limit)
- Alerts when exceeding 48 hours
- Dashboard displays weekly hours

### Viewing Weekly Hours

Your dashboard shows:
- Total hours worked this week
- Warning message if approaching/exceeding limit
- Breakdown of attendance records

### What to Do If Exceeding Limit

If you regularly work over 48 hours:

1. Discuss with your manager
2. Consider if overtime is necessary
3. Review your opt-out agreement (if applicable)
4. Ensure you're taking adequate rest periods

**Rest Periods**:
- 11 hours rest between working days
- 24 hours rest per week (or 48 hours per fortnight)
- 20-minute break if working over 6 hours

## Mobile Access

The system is fully mobile-responsive:

- Access from any smartphone or tablet
- Same functionality as desktop
- Optimized touch interface
- Easy clock-in/out on the go

**Tips for Mobile Use**:
- Add bookmark to home screen for quick access
- Use portrait mode for best experience
- Ensure stable internet connection for clock-in/out

## Best Practices

### For All Users

1. **Security**:
   - Keep your password secure
   - Log out when finished
   - Don't share your account
   - Report suspicious activity

2. **Attendance**:
   - Clock in/out accurately
   - Report any discrepancies immediately
   - Keep regular hours when possible

3. **Profile**:
   - Keep contact information current
   - Review GDPR consent regularly
   - Update personal details as needed

### For Managers

1. **Team Management**:
   - Monitor team attendance regularly
   - Address attendance issues promptly
   - Only edit attendance when necessary
   - Always provide clear reasons for edits

2. **Compliance**:
   - Monitor weekly hours
   - Ensure team takes breaks
   - Address overtime concerns
   - Respect GDPR rights

### For Admins

1. **System Management**:
   - Regular backups
   - Monitor system health
   - Keep software updated
   - Review audit logs periodically

2. **User Management**:
   - Create accounts promptly
   - Deactivate leavers immediately
   - Assign correct roles
   - Respond to support requests

## Troubleshooting

### Can't Log In

**Check**:
- Username/email is correct
- Password is correct (case-sensitive)
- Caps Lock is off
- Account is active

**Solution**: Contact your administrator for password reset

### Can't Clock In/Out

**Check**:
- You're logged in
- Internet connection is stable
- You're not already clocked in (for clock-in)
- You are clocked in (for clock-out)

**Solution**: Refresh the page and try again. Contact manager if issue persists.

### Missing Attendance Records

**Check**:
- Date filters are set correctly
- You clocked in/out on the dates in question
- Your account has proper permissions

**Solution**: Contact your manager to verify records

### Page Not Found (404)

**Check**:
- URL is correct
- You have permission to access the page
- System is online

**Solution**: Return to dashboard and navigate using menu

### Changes Not Saving

**Check**:
- All required fields are filled
- Data is valid (e.g., email format)
- Internet connection is stable

**Solution**: Try again. If issue persists, contact support.

## Getting Help

For assistance:

1. **Check this guide** for common questions
2. **Contact your manager** for day-to-day issues
3. **Contact HR** for policy questions
4. **Contact IT/Admin** for technical problems

## Privacy and Security

Your privacy and data security are important:

- All data is encrypted in transit (HTTPS)
- Passwords are securely hashed
- Access is role-based and restricted
- Activity is logged for security
- Regular security updates applied
- GDPR compliant by design

**Report Security Concerns** to your IT department immediately.
