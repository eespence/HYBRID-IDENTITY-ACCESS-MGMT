← [Back to Main README](../README.md)

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![RBAC](https://img.shields.io/badge/RBAC-Governance-blue?style=flat)
![Splunk](https://img.shields.io/badge/Splunk-000000?style=flat\&logo=splunk\&logoColor=white)

---

# Identity Lifecycle Operations – Fairmont Manufacturing

**Status:** ✅ COMPLETE
**Environment:** IAMPAM.LAB
**Scope:** IAM / PAM Operational Lifecycle

---

## Evidence Mapping

| Lifecycle Phase   | Evidence Source        |
| ----------------- | ---------------------- |
| Onboarding        | Module 05 — Governance |
| Privileged Access | Module 06 — PAM        |
| Role Changes      | Module 05 — Governance |
| Access Review     | Module 05 — Governance |
| Monitoring        | Module 07 — Splunk     |
| Offboarding       | Module 05 — Governance |

---

## Overview

This document defines how identities are **requested, provisioned, monitored, modified, and revoked** across the environment.

Primary Identity:

**Jane Doe — Finance Department Employee**

---

# Access Governance Model

| Control Area      | Implementation     | Status |
| ----------------- | ------------------ | ------ |
| RBAC              | Group-Based Access | ✅      |
| Direct Assignment | Restricted         | ✅      |
| Approval Workflow | Required           | ✅      |
| Audit Logging     | Enabled            | ✅      |

---

# Lifecycle Summary

| Phase      | Action               | Validation                  | Status |
| ---------- | -------------------- | --------------------------- | ------ |
| Joiner     | Account created      | Access validated            | ✅      |
| PAM Access | Admin access granted | MGMT01 login                | ✅      |
| Mover      | Role reassigned      | Old access removed          | ✅      |
| Review     | Access audited       | Unauthorized access removed | ✅      |
| Monitoring | Events logged        | Splunk visibility           | ✅      |
| Leaver     | Account disabled     | Login failure               | ✅      |

---

# 1. Onboarding (Joiner)

### Validation

• User account created
• Role-based access assigned
• Access validated

![Joiner User Created](../screenshots/module-05/module5_03_joiner_user_created.png)

**Status:** ✅ VERIFIED

---

# 2. Privileged Access (PAM)

### Validation

• Admin login from MGMT01
• Privileged group enforcement

![Admin Login MGMT01](../screenshots/module-06/module6_07_admin_login_mgmt01.png)

**Status:** ✅ VERIFIED

---

# 3. Role Change (Mover)

### Validation

• Role transition completed
• Access updated correctly

![Mover Role Change](../screenshots/module-05/module5_05_mover_role_change.png)

**Status:** ✅ VERIFIED

---

# 4. Periodic Access Review

### Validation

• Privileged access reviewed
• Unauthorized access removed

![Privileged Access Review](../screenshots/module-05/module5_07_privileged_access_review.png)

**Status:** ✅ VERIFIED

---

# 5. Authentication Monitoring

### Validation

• Authentication events visible in SIEM
• Cross-system logging confirmed

![Windows Identity Events](../screenshots/module-07/module7_08_windows_identity_events.png)

**Status:** ✅ VERIFIED

---

# 6. Offboarding (Leaver)

### Validation

• Account disabled
• Access revoked
• Authentication blocked

![Leaver Account Disabled](../screenshots/module-05/module5_06_leaver_account_disabled.png)

**Status:** ✅ VERIFIED

---

# Audit Logging & Accountability

| Event Type          | Logged | Source           |
| ------------------- | ------ | ---------------- |
| Account Creation    | ✅      | Active Directory |
| Group Changes       | ✅      | AD + Splunk      |
| Privilege Elevation | ✅      | PAM              |
| Authentication      | ✅      | Splunk           |
| Account Disablement | ✅      | AD               |

---

# Final Outcome

This lifecycle demonstrates:

• Identity provisioning
• Privilege control
• Access governance
• Monitoring and detection
• Secure deprovisioning

---

**Maintained by:** Edward E. Spence
**Environment:** IAMPAM.LAB

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
