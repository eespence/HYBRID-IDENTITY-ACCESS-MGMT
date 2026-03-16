# Module 06 — Privileged Access Management (PAM)

## Overview

Module 06 implements **Privileged Access Management (PAM)** controls within the hybrid identity architecture.

This phase introduces security controls designed to protect **administrative identities, elevated privileges, and privileged access paths** across the environment.

The goal of this module is to demonstrate how enterprise identity systems secure privileged access through:

• Privileged account isolation
• Role-based privileged delegation
• Administrative workstation enforcement
• Cross-platform administrative control
• Privileged access auditing

Privileged identities represent **high-risk access paths**. For this reason they must be separated from standard user accounts and governed by additional security controls.

This module introduces a **dedicated privileged identity model** implemented within Active Directory.

---

# Architecture Context

The privileged access architecture follows a **separation-of-privilege model**.

Standard user identities are used for daily work activities, while **administrative identities are reserved exclusively for elevated administrative operations**.

Access flow implemented in the environment:

```
Standard User
↓
Administrative Identity
↓
PAM Security Group
↓
Privileged System Access
```

Administrative operations originate from a **dedicated administrative workstation**.

Privileged access targets in the environment include:

• **DC01** — Domain Controller
• **MGMT01** — Administrative Workstation
• **LINUX01** — Privileged Linux Server

Privileged identities are intentionally **excluded from Microsoft Entra ID synchronization** in order to reduce exposure of high-risk administrative accounts.

---

# PAM Security Model

Privileged identities are stored inside a dedicated Active Directory organizational unit.

```
Privileged-Accounts
```

Administrative permissions are delegated through **Privileged Access Management security groups**.

The following PAM groups were created:

```
PAM-Domain-Admins
PAM-Server-Admins
PAM-Security-Admins
```

Administrative identities inherit their permissions through group membership.

```
Administrative Identity
↓
PAM Security Group
↓
Privileged System Permissions
```

This model provides:

• Controlled privilege assignment
• Simplified access auditing
• Reduced direct exposure of administrative privileges

---

# Implementation

## Step 1 — Privileged Accounts Organizational Unit

A dedicated organizational unit was created to store privileged administrative identities.

```
Privileged-Accounts
```

This organizational unit separates privileged identities from standard user accounts.

**Control Demonstrated**

Privileged Identity Isolation

**Screenshot to include**

module6_01_privileged_accounts_ou.png

---

## Step 2 — Privileged Administrative Accounts

Dedicated administrative identities were created to separate administrative activity from normal user accounts.

Example privileged identities:

```
admin.dc01
admin.server
admin.security
```

These accounts are used only for privileged administrative operations.

**Control Demonstrated**

Privileged Identity Separation

**Screenshot to include**

module6_02_privileged_accounts_created.png

---

## Step 3 — PAM Security Groups

Privileged access groups were created to implement role-based administrative delegation.

Groups created:

```
PAM-Domain-Admins
PAM-Server-Admins
PAM-Security-Admins
```

These groups act as the control layer between identities and administrative permissions.

**Control Demonstrated**

Privileged RBAC Delegation

**Screenshot to include**

module6_03_pam_security_groups.png

---

## Step 4 — PAM Group Membership

Administrative identities were assigned to their corresponding PAM roles.

Example assignments:

```
admin.dc01 → PAM-Domain-Admins
admin.server → PAM-Server-Admins
admin.security → PAM-Security-Admins
```

This ensures administrative privileges are granted through **role membership instead of direct assignment**.

**Control Demonstrated**

Role-Based Privileged Access

**Screenshot to include**

module6_04_pam_group_membership.png

---

## Step 5 — Privilege Delegation Through Group Nesting

PAM security groups were nested into the corresponding administrative groups.

Example:

```
PAM-Domain-Admins → Domain Admins
```

This allows administrative permissions to be inherited **indirectly through the PAM delegation model**.

**Control Demonstrated**

Indirect Privileged Access Delegation

**Screenshot to include**

module6_05_pam_group_nesting.png

---

## Step 6 — Administrative Workstation Access

Administrative identities were granted remote access to the **dedicated management workstation**.

```
MGMT01
```

Administrative access was granted using the group:

```
Remote Desktop Users
```

This ensures administrative operations occur from a **controlled workstation environment**.

**Control Demonstrated**

Administrative Workstation Enforcement

**Screenshot to include**

module6_06_mgmt01_rdp_permissions.png

---

## Step 7 — Administrative Login Validation

Administrative login access was tested using a privileged account on the management workstation.

Commands executed during validation:

```
hostname
whoami
```

This confirmed that the administrative identity was operating within the expected privileged session context.

**Control Demonstrated**

Administrative Session Validation

**Screenshot to include**

module6_07_admin_login_mgmt01.png

---

## Step 8 — Privilege Boundary Validation

Administrative login was also tested on a standard workstation.

```
CLIENT01
```

This demonstrates the **difference between privileged administrative systems and standard user endpoints**.

**Control Demonstrated**

Privilege Boundary Awareness

**Screenshot to include**

module6_08_admin_login_client01_gap.png

---

## Step 9 — Linux Administrative Identity

A privileged Linux administrative account was created on the Linux server.

```
admin_server
```

This account was granted elevated privileges through the Linux **sudo authorization model**.

**Control Demonstrated**

Cross-Platform Privileged Identity Management

**Screenshot to include**

module6_09_linux_account_created.png

---

## Step 10 — Linux Privilege Validation

Administrative privileges were verified using the following command:

```
sudo -l
```

This confirms which commands the privileged account is authorized to execute.

**Control Demonstrated**

Privileged Command Authorization

**Screenshot to include**

module6_10_linux_sudo_validation.png

---

## Step 11 — Privileged Access Review

Privileged roles must be periodically reviewed to ensure unauthorized identities do not maintain elevated privileges.

Administrative group membership was audited using:

```
Get-ADGroupMember
```

This process verifies that only approved identities hold privileged access.

**Control Demonstrated**

Privileged Access Governance

**Screenshot to include**

module6_11_privileged_access_review.png

---

# Security Controls Demonstrated

This module implemented multiple enterprise privileged access protections:

• Privileged Identity Isolation
• Administrative Workstation Model
• Role-Based Privileged Delegation
• Cross-Platform Administrative Access
• Privileged Access Review
• Privileged Identity Separation from Standard Accounts

These controls align with enterprise privileged access protection strategies used in modern identity architectures.

---

# Summary

Module 06 demonstrates how privileged access is secured within a hybrid identity environment.

By isolating privileged identities, delegating administrative roles through PAM security groups, enforcing administrative workstation usage, and validating privileged access across both Windows and Linux systems, the environment ensures elevated privileges remain tightly controlled.

These protections reduce the attack surface associated with privileged identities and establish a strong security foundation for enterprise identity management.

---

# Next Module

Module 07 introduces **IAM & PAM Logging / Incident Response**, which will implement:

• Identity authentication logging
• Privileged access monitoring
• Security event auditing
• Incident detection through identity signals

---

**Module:** Privileged Access Management Implementation
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Built by:** Edward E. Spence
**Environment:** IAMPAM.LAB
**Systems:** DC01, MGMT01, LINUX01
**Platform:** Proxmox VE | Active Directory | Microsoft Entra ID

