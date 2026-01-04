# Security Policy

## Overview
This project is a **UK-compliant HR Management System** handling sensitive employee and personal data. Security is treated as a first-class concern and follows principles aligned with **ISO 27001**, **UK GDPR**, and **SOC-style controls**.

---

## Data Protection
- All personal data is processed under lawful employment basis
- Sensitive data access is role-restricted
- No hard deletes of employee records
- Attendance and personal data changes are fully auditable

---

## Authentication & Authorization
- Passwords are hashed using `password_hash()`
- Sessions are regenerated on login
- Role-Based Access Control (RBAC) enforced server-side
- Tenant isolation enforced via `company_id`

---

## Application Security Controls
- CSRF protection on all state-changing requests
- Input validation on all user input
- Output escaping in all views
- HTTPS required in production
- Session timeouts enforced

---

## Audit Logging
- Attendance edits are logged with reason and editor
- Access to sensitive records is auditable
- Logs are immutable and timestamped

---

## Vulnerability Reporting
If you discover a security issue, please report it privately.

**DO NOT open public GitHub issues for security vulnerabilities.**

Contact:
- security@yourdomain.com (replace before production)

---

## Compliance Alignment
- UK GDPR & Data Protection Act 2018
- Working Time Regulations 1998
- ISO 27001 principles (access control, auditability, least privilege)
