← [Back to Main README](../../README.md)

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat\&logo=microsoftazure\&logoColor=white)
![Entra Connect](https://img.shields.io/badge/Entra_Connect-PHS-0078D4?style=flat\&logo=microsoft\&logoColor=white)

---

# Entra Connect UPN Namespace Mismatch Recovery Runbook

## Incident: Microsoft Entra Connect Authentication Failure ("Unsupported Browser")

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Document Type:** IAM Operations Runbook
**Last Reviewed:** February 2026

---

## Runbook Metadata

| Field      | Value                           |
| ---------- | ------------------------------- |
| Runbook ID | HYB-OPS-REC-001                 |
| Service    | Hybrid Identity Synchronization |
| Severity   | SEV-1 Authentication Failure    |
| Status     | Resolved                        |
| Version    | 1.0                             |

---

## Executive Summary

Failure caused by **UPN namespace mismatch** between AD and Entra ID.
Not a browser issue — identity architecture issue.

---

## Root Cause

```text
IAMPAM.LAB  ❌
fairmontmanufacturing.onmicrosoft.com ✅
```

---

## Recovery Procedure

### Step 1 — Add UPN Suffix

![UPN Suffix Added](../../screenshots/module-03/archive/DC01-UPN-suffix-added.png)

---

### Step 2 — Update Administrator UPN

![UPN Changed](../../screenshots/module-03/archive/DC01-AdminUser-UPN-Changed-To-Entra.png)

---

### Step 3 — Verify Domain Context

![Domain Context](../../screenshots/module-03/archive/ID-SYNC01-Domain-Authentication-Context.png)

---

### Step 4 — Kerberos Reset

![Kerberos Reset](../../screenshots/module-03/archive/SYNC01-Kerberos-Ticket-Purge-And-Reboot.png)

---

### Step 5 — Entra Connect Execution

![Download Portal](../../screenshots/module-03/archive/SYNC01-EntraConnect-Download-Portal.png)

![Configuration Complete](../../screenshots/module-03/archive/SYNC01-EntraConnect-ConfigurationComplete-HybridIdentitySuccess.png)

---

## Scoped Synchronization

![AAD Sync Group](../../screenshots/module-03/DC01-AD-AADSyncUsers-SecurityGroup.png)

---

## Validation

![Sync Success](../../screenshots/module-03/ID-SYNC01-SyncServiceManager-DeltaSync-Success.png)

![User Verified](../../screenshots/module-03/Entra-AdminUser-OnPremSync-Verified.png)

---

## Closure Criteria

✔ Authentication successful
✔ Sync operational
✔ Users visible in Entra
✔ On-Prem Sync verified

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
