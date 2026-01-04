-- UK-Compliant HR Management System Database Schema
-- Multi-tenant with company_id, GDPR compliant, UK Working Time Regulations support

-- Companies Table (for white-label branding)
CREATE TABLE IF NOT EXISTS companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    company_code VARCHAR(50) UNIQUE NOT NULL,
    logo_url VARCHAR(255),
    primary_color VARCHAR(7) DEFAULT '#007bff',
    secondary_color VARCHAR(7) DEFAULT '#6c757d',
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active',
    INDEX idx_company_code (company_code),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users Table (with role-based access)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('super_admin', 'manager', 'employee') NOT NULL DEFAULT 'employee',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    INDEX idx_company_id (company_id),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Employees Table (work and personal details)
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    user_id INT UNIQUE NOT NULL,
    employee_number VARCHAR(50) UNIQUE NOT NULL,
    
    -- Personal Details
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    legal_full_name VARCHAR(255),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    nationality VARCHAR(100),
    marital_status ENUM('single', 'married', 'divorced', 'widowed', 'civil_partnership', 'prefer_not_to_say'),
    personal_email VARCHAR(255),
    national_insurance_number VARCHAR(13),
    
    -- Home Address
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    county VARCHAR(100),
    postcode VARCHAR(10),
    phone_number VARCHAR(20),
    mobile_number VARCHAR(20),
    
    -- Emergency Contact
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relationship VARCHAR(100),
    
    -- Passport Information
    passport_number VARCHAR(50),
    passport_country VARCHAR(100),
    passport_expiry_date DATE,
    
    -- Visa / Right-to-Work Information
    visa_work_permit_type VARCHAR(100),
    visa_work_permit_expiry DATE,
    
    -- Work Details
    job_title VARCHAR(255),
    department VARCHAR(100),
    work_phone VARCHAR(20),
    work_location ENUM('office', 'home', 'hybrid', 'remote') DEFAULT 'office',
    work_address TEXT,
    manager_id INT NULL,
    start_date DATE NOT NULL,
    probation_end_date DATE,
    end_date DATE NULL,
    employment_type ENUM('full_time', 'part_time', 'contract', 'temporary') DEFAULT 'full_time',
    employment_status ENUM('active', 'probation', 'notice_period', 'on_leave', 'suspended', 'terminated') DEFAULT 'active',
    work_schedule VARCHAR(255) DEFAULT 'Monday-Friday, 9:00-17:00',
    contracted_hours_per_week DECIMAL(5,2) DEFAULT 40.00,
    
    -- UK Working Time Regulations
    wtr_48_hour_opt_out BOOLEAN DEFAULT FALSE,
    wtr_opt_out_signed_date DATE,
    
    -- GDPR Consent
    gdpr_consent BOOLEAN DEFAULT FALSE,
    gdpr_consent_date TIMESTAMP NULL,
    data_retention_agreed BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees(id) ON DELETE SET NULL,
    INDEX idx_company_id (company_id),
    INDEX idx_employee_number (employee_number),
    INDEX idx_manager_id (manager_id),
    INDEX idx_start_date (start_date),
    INDEX idx_nationality (nationality),
    INDEX idx_employment_status (employment_status),
    INDEX idx_work_location (work_location),
    INDEX idx_probation_end_date (probation_end_date),
    INDEX idx_visa_expiry (visa_work_permit_expiry),
    INDEX idx_passport_expiry (passport_expiry_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Employee personal and work information - GDPR compliant, UK regulations';

-- Attendance Table (clock-in/clock-out without GPS)
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    clock_in TIMESTAMP NOT NULL,
    clock_out TIMESTAMP NULL,
    total_hours DECIMAL(5,2) NULL,
    break_duration_minutes INT DEFAULT 0,
    notes TEXT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    status ENUM('clocked_in', 'clocked_out', 'edited') DEFAULT 'clocked_in',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    INDEX idx_company_id (company_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_clock_in (clock_in),
    INDEX idx_clock_out (clock_out),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Attendance Audit Logs (for manager edits)
CREATE TABLE IF NOT EXISTS attendance_audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    attendance_id INT NOT NULL,
    company_id INT NOT NULL,
    edited_by_user_id INT NOT NULL,
    action ENUM('created', 'updated', 'deleted') NOT NULL,
    field_changed VARCHAR(100),
    old_value TEXT,
    new_value TEXT,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (attendance_id) REFERENCES attendance(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (edited_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_attendance_id (attendance_id),
    INDEX idx_company_id (company_id),
    INDEX idx_edited_by (edited_by_user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sessions Table (secure session management)
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(128) PRIMARY KEY,
    user_id INT NOT NULL,
    company_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    payload TEXT,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_last_activity (last_activity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GDPR Data Requests Table
CREATE TABLE IF NOT EXISTS gdpr_data_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    user_id INT NOT NULL,
    request_type ENUM('export', 'delete') NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'rejected') DEFAULT 'pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP NULL,
    processed_by_user_id INT NULL,
    notes TEXT,
    
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_company_id (company_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- UK Working Time Regulations Tracking
CREATE TABLE IF NOT EXISTS weekly_hours_summary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    employee_id INT NOT NULL,
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL,
    total_hours DECIMAL(6,2) NOT NULL DEFAULT 0,
    over_limit BOOLEAN DEFAULT FALSE,
    alert_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    UNIQUE KEY unique_employee_week (employee_id, week_start_date),
    INDEX idx_company_id (company_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_week_start (week_start_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default super admin company
INSERT INTO companies (company_name, company_code, email, status) 
VALUES ('System Administration', 'SYSADMIN', 'admin@system.local', 'active');

-- Insert default super admin user (password: admin123 - MUST BE CHANGED)
-- Password hash for 'admin123'
INSERT INTO users (company_id, username, email, password_hash, role, status)
VALUES (1, 'admin', 'admin@system.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'super_admin', 'active');
