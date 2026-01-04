-- Migration: Add Missing Employee Personal and Work Information Fields
-- Date: 2026-01-04
-- Purpose: Complete implementation of all required employee fields for UK compliance

-- Add missing personal information fields to employees table
ALTER TABLE employees
-- Legal/Full Name
ADD COLUMN legal_full_name VARCHAR(255) AFTER last_name,

-- Nationality and Marital Status
ADD COLUMN nationality VARCHAR(100) AFTER gender,
ADD COLUMN marital_status ENUM('single', 'married', 'divorced', 'widowed', 'civil_partnership', 'prefer_not_to_say') AFTER nationality,

-- Personal Email (separate from work email)
ADD COLUMN personal_email VARCHAR(255) AFTER marital_status,

-- Passport Information
ADD COLUMN passport_number VARCHAR(50) AFTER emergency_contact_relationship,
ADD COLUMN passport_country VARCHAR(100) AFTER passport_number,
ADD COLUMN passport_expiry_date DATE AFTER passport_country,

-- Visa / Right-to-Work Information
ADD COLUMN visa_work_permit_type VARCHAR(100) AFTER passport_expiry_date,
ADD COLUMN visa_work_permit_expiry DATE AFTER visa_work_permit_type,

-- Work Information Fields
ADD COLUMN work_phone VARCHAR(20) AFTER department,
ADD COLUMN work_location ENUM('office', 'home', 'hybrid', 'remote') DEFAULT 'office' AFTER work_phone,
ADD COLUMN work_address TEXT AFTER work_location,
ADD COLUMN probation_end_date DATE AFTER start_date,

-- UK Working Time Regulations 48-Hour Opt-Out
ADD COLUMN wtr_48_hour_opt_out BOOLEAN DEFAULT FALSE AFTER contracted_hours_per_week,
ADD COLUMN wtr_opt_out_signed_date DATE AFTER wtr_48_hour_opt_out,

-- Employment Status (add to track beyond user status)
ADD COLUMN employment_status ENUM('active', 'probation', 'notice_period', 'on_leave', 'suspended', 'terminated') DEFAULT 'active' AFTER employment_type,

-- Add indexes for frequently queried fields
ADD INDEX idx_nationality (nationality),
ADD INDEX idx_employment_status (employment_status),
ADD INDEX idx_work_location (work_location),
ADD INDEX idx_probation_end_date (probation_end_date),
ADD INDEX idx_visa_expiry (visa_work_permit_expiry),
ADD INDEX idx_passport_expiry (passport_expiry_date);

-- Add comments for documentation
ALTER TABLE employees 
COMMENT = 'Employee personal and work information - GDPR compliant, UK regulations';
