← [Back to Main README](../README.md)

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat\&logo=microsoftazure\&logoColor=white)
![Entra Connect](https://img.shields.io/badge/Entra_Connect-PHS-0078D4?style=flat\&logo=microsoft\&logoColor=white)

---

# Module 03: Hybrid Identity (Active Directory ↔ Microsoft Entra ID)

**Module**: 03 - Hybrid Identity
**Status**: ✅ COMPLETE
**Built by**: Edward E. Spence
**Purpose**: Establish hybrid identity using Entra Connect with controlled synchronization.

---

## Hybrid Identity Overview

Active Directory remains the identity authority while Microsoft Entra ID enables cloud authentication.

---

## Root Cause (Incident)

```
IAMPAM.LAB ❌
fairmontmanufacturing.onmicrosoft.com ✅
```

Non-routable namespace caused authentication failure.

---

## Remediation Summary

* Added routable UPN suffix
* Updated admin UPN
* Cleared Kerberos tickets
* Re-ran Entra Connect

---

## 🔍 Verification Evidence

---

### AAD-Sync-Users Group (Scope Control)

![AAD Sync Group](../screenshots/module-03/DC01-AD-AADSyncUsers-SecurityGroup.png)

---

### Sync Service Validation

![Sync Engine](../screenshots/module-03/ID-SYNC01-SyncServiceManager-DeltaSync-Success.png)

---

### Entra User Verification

![User Verified](../screenshots/module-03/Entra-AdminUser-OnPremSync-Verified.png)

---

## ⚙️ Installation & Configuration Evidence

---

### Entra Connect Download Portal

![Download Portal](../screenshots/module-03/archive/SYNC01-EntraConnect-Download-Portal.png)

---

### Entra Connect Download Page

![Download Page](../screenshots/module-03/archive/SYNC01-EntraConnect-DownloadPage.png)

---

### Required Components

![Required Components](../screenshots/module-03/archive/SYNC01-EntraConnect-03-RequiredComponents.png)

---

### Group Filtering (AAD-Sync-Users)

![Group Filtering](../screenshots/module-03/archive/SYNC01-EntraConnect-GroupFiltering-AADSyncUsers.png)

---

### MFA Admin Approval

![MFA Approval](../screenshots/module-03/archive/SYNC01-EntraConnect-MFA-Admin-Approval.png)

---

### Optional Features (Password Hash Sync)

![Optional Features](../screenshots/module-03/archive/SYNC01-EntraConnect-OptionalFeatures-PHS.png)

---

### Kerberos Reset

![Kerberos Reset](../screenshots/module-03/archive/SYNC01-Kerberos-Ticket-Purge-And-Reboot.png)

---

## ✅ Final Status

| Component           | Status |
| ------------------- | ------ |
| Entra Connect       | ✅      |
| Namespace Alignment | ✅      |
| Sync Scope          | ✅      |
| Hybrid Auth         | ✅      |

---

## 🧠 Key Takeaway

Hybrid identity failures are almost always:

* Namespace issues
* Not tool issues

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
