# Identity Lifecycle Operations – Fairmont Manufacturing

This document defines how digital identities are requested, approved, provisioned, monitored, modified, and revoked within the simulated Fairmont Manufacturing enterprise environment.

The lab models operational Identity and Privileged Access Management (IAM/PAM) responsibilities performed by identity administrators and security operations teams.

Primary Test Identity
Jane Doe — Finance Department Employee

The same identity is intentionally used across all modules to demonstrate continuous lifecycle management rather than isolated technical tasks.

---

## Access Governance Model

Identity administration follows a role-based access control (RBAC) model.

Access is never granted directly to an individual user unless required for troubleshooting.
Users receive permissions through security group membership mapped to job function.

Provisioning requires:
• a documented request
• management approval
• identity administrator action
• authentication validation

All lifecycle actions are auditable.

---

## Access Request & Approval (Pre-Provisioning)

Before any account is created, an access request must exist.

Simulated process:

1. Hiring manager submits an access request
2. Request includes employee role and department
3. Identity administrator verifies required access
4. Account is provisioned based on role, not preference

Purpose:
Demonstrates separation of duties and controlled identity provisioning.

Operational Control:
No account is created without an approval record.

---

## 1. Onboarding (Joiner)

When a new employee is hired, an account is provisioned in Active Directory.

Steps performed:
• Create user account in the IAM-PAM-Users organizational unit
• Assign baseline role-based security groups
• Configure initial password and first login requirement
• Validate workstation authentication from CLIENT01

Operational Validation:
The employee must successfully log in to a domain-joined workstation and receive a Kerberos authentication ticket from the domain controller (DC01).

Simulated Issue:
The employee was unable to access department resources due to incorrect group membership.

Resolution:
Group assignment was corrected and access was verified.

Purpose:
Demonstrates controlled provisioning and authentication validation.

---

## 2. Privileged Access Assignment (PAM Function)

Certain tasks require temporary administrative privileges.

Procedure:
• User requests elevated access for a specific task
• Administrator grants membership in administrative group
• Privileged access is performed from MGMT01
• Access is removed after task completion

Security Control:
Privileged access is time-limited and reviewed.

Simulated Issue:
Administrative permissions remained assigned longer than intended.

Resolution:
Administrative group membership was removed and verified.

Purpose:
Demonstrates least-privilege administration and privileged access management concepts.

---

## 3. Role Change (Mover)

Employees may transfer departments requiring new access.

Scenario:
Jane Doe transfers from Finance to IT.

Required Actions:
• Remove previous department access
• Assign new role-based groups
• Validate authentication to new resources
• Confirm previous access no longer works

Simulated Issue:
The user retained access to previous department resources.

Resolution:
Legacy group membership removed and access retested.

Purpose:
Demonstrates excessive privilege prevention.

---

## 4. Periodic Access Review

Access must be reviewed regularly to detect incorrect permissions.

Process:
• Manager reviews department group memberships
• Incorrect access is identified
• Access is removed and documented

Simulated Event:
Finance manager review showed Jane Doe retained IT permissions.

Resolution:
Group membership removed and authentication verified.

Purpose:
Demonstrates access certification and governance controls.

---

## 5. Authentication Security Event Monitoring

Authentication activity is monitored for unusual behavior.

Scenario:
Unexpected login occurred outside normal working hours.

Actions Taken:
• Review authentication logs
• Verify user activity
• Reset password
• Require re-authentication

All authentication events are logged and traceable to an account.

Purpose:
Demonstrates credential protection and account security response.

---

## 6. Offboarding (Leaver)

When an employee leaves the company, access must be revoked immediately.

Procedure:
• Disable Active Directory account
• Invalidate active sessions
• Confirm authentication failure
• Review authentication logs

Validation:
The user can no longer authenticate to domain systems.

Purpose:
Demonstrates termination controls and identity revocation.

---

## Audit Logging & Accountability

All lifecycle actions are logged, including:

• account creation
• group membership changes
• privilege elevation
• authentication attempts
• account disablement

Each action is traceable to an administrative account to ensure accountability and non-repudiation.

---

## Operational Goal

This environment is used to practice identity administration, privilege control, and authentication monitoring as performed in a real organization.

The objective is ensuring:

• the correct users have access
• excessive privileges are removed
• authentication is auditable
• administrative access is controlled
• access is revoked when no longer required

---

Maintained by: Edward E. Spence
Identity Security Documentation: E.E. Spence
Last Reviewed: February 2026

