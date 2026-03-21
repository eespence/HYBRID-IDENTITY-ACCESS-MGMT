← [Back to Main README](../README.md)

---

![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?style=flat)
![IAM](https://img.shields.io/badge/IAM-Identity_Engineering-blue?style=flat)
![PAM](https://img.shields.io/badge/PAM-Privileged_Access-purple?style=flat)

---

# Identity Automation Modules

This directory contains PowerShell-based automation projects designed to support identity lifecycle management, privileged access control, and security auditing.

These automation modules extend the identity platform by enabling **repeatable, auditable, and scalable identity operations** across Active Directory and hybrid environments.

---

## Module Status Overview

| Module                    | Status     | Focus           |
| ------------------------- | ---------- | --------------- |
| 01 — User Lifecycle       | ✅ Complete | Provisioning    |
| 02 — PAM Temporary Access | ✅ Complete | Least Privilege |
| 03 — Identity Audit       | ✅ Complete | Governance      |

---

## Modules

### 01 — User Lifecycle Automation

**Status:** ✅ Complete

Automates user provisioning, OU placement, group assignment, and account configuration using structured CSV input.

**Capabilities:**

* Bulk user creation via CSV input
* Automatic group membership assignment
* Standardized account configuration
* Execution logging for audit validation

**Input:** CSV file containing user attributes
**Output:** Active Directory user objects, group assignments, execution logs

🔗 [View Module](./01-user-lifecycle/README.md)

---

### 02 — PAM Temporary Access

**Status:** ✅ Complete

Implements time-bound privileged access by adding users to administrative groups with automated removal after a defined duration.

**Capabilities:**

* Temporary admin group assignment
* Automatic privilege revocation
* Execution tracking and logging
* Supports least privilege enforcement

**Input:** User account + target admin group + duration
**Output:** Temporary privileged access with enforced removal and logs

🔗 [View Module](./02-pam-temporary-access/README.md)

---

### 03 — Identity Audit

**Status:** ✅ Complete

Audits identity and privilege posture by enumerating privileged accounts, last logon activity, and exporting findings for analysis.

**Capabilities:**

* Privileged account enumeration
* Last logon and activity review
* Detection of stale or inactive accounts
* Exportable audit reports (CSV)

**Input:** Active Directory environment
**Output:** Structured audit report (CSV) for review and compliance

🔗 [View Module](./03-identity-audit/README.md)

---

## Evidence & Validation

Execution evidence, screenshots, and output samples are stored within each module directory:

```
automation/<module-name>/sample-output.txt
automation/<module-name>/sample-report.csv
```

Each module README includes:

* Command execution examples
* Expected outputs
* Validation steps
* Supporting screenshots (where applicable)

---

## Why This Matters

Manual identity operations do not scale and introduce risk.

These automation modules demonstrate:

• Consistent identity provisioning
• Enforcement of least privilege
• Reduction of human error
• Audit-ready operational workflows
• Scalable identity engineering practices

---

**Author:** Edward E. Spence
**Focus:** IAM | PAM | Identity Automation
