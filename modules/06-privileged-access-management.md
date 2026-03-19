← [Back to Main README](../README.md)

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![PAM](https://img.shields.io/badge/Privileged_Access_Management-red?style=flat\&logo=microsoft\&logoColor=white)
![Linux](https://img.shields.io/badge/Ubuntu_22.04-E95420?style=flat\&logo=ubuntu\&logoColor=white)

---

# Module 06: Privileged Access Management

**Module**: 06 - Privileged Access Management
**Status**: ✅ COMPLETE (Privileged Access Controls Validated)
**Built by**: Edward E. Spence
**Completed**: March 2026
**Purpose**: Implement privileged access management controls within the hybrid identity architecture, demonstrating privileged account isolation, role-based administrative delegation, administrative workstation enforcement, cross-platform privileged management, and privileged access auditing.

---

## Overview

Module 06 implements **Privileged Access Management (PAM)** controls within the hybrid identity architecture.

This phase introduces security controls designed to protect **administrative identities, elevated privileges, and privileged access paths**.

The objective of this module is to demonstrate how enterprise identity environments secure privileged access through:

* Privileged account isolation
* Role-based privileged delegation
* Administrative workstation enforcement
* Cross-platform administrative control
* Privileged access auditing

Privileged identities represent **high-risk access paths**. For this reason, they must be separated from standard user accounts and governed by additional security controls.

This module introduces a **dedicated privileged identity model** inside Active Directory.

---

# Architecture Context

The privileged access architecture follows a **separation of privilege model**.

Standard user identities are used for daily work, while **administrative identities are used exclusively for elevated tasks**.

Access flow:

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

Privileged access targets in this environment include:

* **DC01** — Domain Controller
* **MGMT01** — Administrative Workstation
* **LINUX01** — Privileged Linux Server

Privileged identities are intentionally **excluded from cloud synchronization** in order to reduce exposure of high-risk accounts.

---

## Privileged Access Architecture Diagram

The diagram below illustrates the privileged access control model, including administrative flow, PAM group enforcement, and the intentional exclusion of privileged identities from Entra ID synchronization.

![PAM Architecture](../screenshots/module-06/module6_13_pam_architecture.png)

---

# PAM Security Model

Privileged identities are stored in a dedicated organizational unit.

```
Privileged-Accounts
```

Administrative access is delegated using **PAM security groups**.

```
PAM-Domain-Admins
PAM-Server-Admins
PAM-Security-Admins
```

Administrative identities inherit permissions through group membership.

```
Administrative Identity
↓
PAM Security Group
↓
Privileged System Permissions
```

This model ensures:

* controlled privilege assignment
* simplified auditing
* reduced direct privilege exposure

---

# Implementation

## Step 1 — Privileged Accounts Organizational Unit

```
Privileged-Accounts
```

### Evidence

![Privileged Accounts OU](../screenshots/module-06/module6_01_privileged_accounts_ou.png)

### Control Demonstrated

Privileged Identity Isolation

---

## Step 2 — Privileged Administrative Accounts

```
admin.dc01
admin.server
admin.security
```

### Evidence

![Privileged Accounts Created](../screenshots/module-06/module6_02_privileged_accounts_created.png)

### Control Demonstrated

Privileged Account Segmentation

---

## Step 3 — PAM Security Groups

```
PAM-Domain-Admins
PAM-Server-Admins
PAM-Security-Admins
```

### Evidence

![PAM Security Groups](../screenshots/module-06/module6_03_pam_security_groups.png)

### Control Demonstrated

Role-Based Access Control (RBAC)

---

## Step 4 — PAM Group Membership

```
admin.dc01 → PAM-Domain-Admins
admin.server → PAM-Server-Admins
admin.security → PAM-Security-Admins
```

### Evidence

![PAM Group Membership](../screenshots/module-06/module6_04_pam_group_membership.png)

### Control Demonstrated

Least Privilege Enforcement

---

## Step 5 — Privilege Delegation Through Group Nesting

```
PAM-Domain-Admins → Domain Admins
```

### Evidence

![PAM Group Nesting](../screenshots/module-06/module6_05_pam_group_nesting.png)

### Control Demonstrated

Controlled Privilege Escalation Path

---

## Step 6 — Administrative Workstation Access

```
MGMT01
Remote Desktop Users
```

### Evidence

![MGMT01 RDP Permissions](../screenshots/module-06/module6_06_mgmt01_rdp_permissions.png)

### Control Demonstrated

Administrative Workstation Enforcement

---

## Step 7 — Administrative Login Validation

```
hostname
whoami
```

### Evidence

![Admin Login MGMT01](../screenshots/module-06/module6_07_admin_login_mgmt01.png)

### Control Demonstrated

Privileged Access Validation

---

## Step 8 — Privilege Boundary Validation

```
CLIENT01
```

### Evidence

![Admin Login CLIENT01](../screenshots/module-06/module6_08_admin_login_client01_gap.png)

### Control Demonstrated

Privilege Boundary Enforcement

---

## Step 9 — Linux Administrative Identity

```
admin_server
sudo
```

### Evidence

![Linux Account Created](../screenshots/module-06/module6_09_linux_account_created.png)

### Control Demonstrated

Cross-Platform Privileged Access

---

## Step 10 — Linux Privilege Validation

```
sudo -l
```

### Evidence

![Linux Sudo Validation](../screenshots/module-06/module6_10_linux_sudo_validation.png)

### Control Demonstrated

Privilege Verification

---

## Step 11 — Privileged Access Review

```
Get-ADGroupMember
```

### Evidence

![Privileged Access Review](../screenshots/module-06/module6_11_privileged_access_review.png)

### Control Demonstrated

Privileged Access Auditing

---

# Security Controls Demonstrated

* Privileged Identity Isolation
* Administrative Workstation Model
* Role-Based Privileged Delegation
* Cross-Platform Administrative Access
* Privileged Access Review
* Privileged Identity Separation from Standard Accounts

---

# Summary

Module 06 demonstrates how privileged access is secured within a hybrid identity environment.

By isolating privileged identities, delegating administrative roles through PAM security groups, enforcing administrative workstation usage, and validating privileged access across both Windows and Linux systems, the environment ensures elevated privileges remain tightly controlled.

---

# Next Module

Module 07 introduces **IAM & PAM Logging / Incident Response**

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
