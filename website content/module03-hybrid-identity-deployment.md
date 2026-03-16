# Hybrid Identity Deployment — Active Directory ↔ Microsoft Entra ID Synchronization

---

## Overview

This module documents the implementation of hybrid identity by integrating on-premises Active Directory with Microsoft Entra ID.
The objective was to allow a single user identity to authenticate both internally (Kerberos domain authentication) and externally (cloud authentication) while remaining directory-anchored to the on-premises domain controller.

Rather than simply installing a connector, the goal of this deployment was to operate identity as infrastructure — meaning authentication reliability, scope control, and recoverability were treated as production requirements.

---

## Environment

**On-Premises Domain:** `IAMPAM.LAB`
**Microsoft Entra Tenant:** `fairmontmanufacturing.onmicrosoft.com`

### Systems Used

| System    | Role                                                        |
| --------- | ----------------------------------------------------------- |
| DC01      | Active Directory Domain Controller / Kerberos KDC           |
| MGMT01    | Administrative management workstation / internal time relay |
| ID-SYNC01 | Microsoft Entra Connect synchronization server              |
| CLIENT01  | Domain user workstation (validation testing)                |

The synchronization server (ID-SYNC01) was dual-homed with internet access and domain connectivity.
No internet connectivity was provided directly to the domain controller.

---

## Design Objective

The design requirement was:

> A user created in Active Directory must automatically exist in Microsoft Entra ID and authenticate to cloud services without becoming a cloud-only account.

This preserves **directory anchoring**, ensuring the on-premises directory remains the authoritative identity source.

Authentication method selected:

**Password Hash Synchronization (PHS)**

This method allows cloud authentication while still sourcing identity from Active Directory.

---

## Synchronization Scope Control

Synchronization was intentionally limited using security group filtering.

A dedicated Active Directory group was created:

```
AAD-Sync-Users
```

Only users placed inside this group are synchronized to Microsoft Entra ID.

This prevents:
• administrative accounts syncing unintentionally
• service accounts appearing in the cloud
• uncontrolled identity sprawl

---

## Installation Summary

Microsoft Entra Connect was installed on **ID-SYNC01** using a custom configuration.

The connector authenticated to:

• Microsoft Entra ID using a Global Administrator account
• Active Directory using domain credentials

Directory synchronization was configured and the scheduler enabled.

After configuration, a manual synchronization cycle was executed:

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

---

## Verification

A test user (Jane Doe) and an administrative account were added to the **AAD-Sync-Users** group.

After the synchronization cycle:

Users appeared inside Microsoft Entra ID with the following properties:

• On-Premises Sync: Yes
• Source: Windows Server AD
• Immutable ID present

This confirmed the accounts were directory-anchored and not cloud-created.

---

## Major Incident — Authentication Failure

During the initial configuration of Microsoft Entra Connect, authentication repeatedly failed with the error:

> “Unsupported Browser”

The error occurred during Global Administrator authentication and prevented connector configuration.

---

## Initial Troubleshooting

Initial investigation focused on client-side causes:

• WebView2 runtime
• Windows Account Manager
• TLS and certificate validation
• service restarts

No remediation corrected the issue.

The error was misleading and not related to the browser or operating system.

---

## Root Cause

The Active Directory domain used a non-routable namespace:

```
IAMPAM.LAB
```

Microsoft Entra ID requires a routable User Principal Name (UPN) suffix during OAuth authentication.
Because the on-premises UPN did not match a verified cloud domain, the Windows authentication broker could not construct a valid security context.

The failure was not a software issue.

It was an **identity architecture issue**.

---

## Remediation

The issue was resolved by aligning the identity namespace with the cloud tenant.

### Steps Performed

1. Added a routable UPN suffix on DC01:

```
fairmontmanufacturing.onmicrosoft.com
```

2. Updated the administrator UPN:

```
Administrator@fairmontmanufacturing.onmicrosoft.com
```

3. Cleared Kerberos tickets on ID-SYNC01:

```powershell
klist purge
```

4. Rebooted the synchronization server

5. Re-ran Microsoft Entra Connect

Authentication immediately succeeded.

---

## Post-Recovery Validation

Synchronization initialized and users appeared in Microsoft Entra ID.

Hybrid authentication was verified:

• On-premises login using Kerberos
• Cloud identity presence
• Directory-anchored attributes maintained
• Successful synchronization cycles

Hybrid identity was now operational.

---

## Final State

After correction:

• Connector installed successfully
• Synchronization scheduler enabled
• Scoped users synchronized
• Cloud authentication available
• Active Directory remained identity authority

Authentication now functions across both environments:

**Active Directory (Kerberos)**
+
**Microsoft Entra ID (Cloud Authentication)**

---

## Operational Lessons Learned

This deployment demonstrated that hybrid identity failures often originate from design assumptions rather than software installation.

Key findings:

• Non-routable namespaces break OAuth authentication
• Connector errors can mislead troubleshooting
• Identity architecture must be validated before deployment
• Group-scoped synchronization prevents unintended exposure
• Hybrid identity depends on directory design, not just tooling

---

## Skills Demonstrated

• Active Directory identity management
• Microsoft Entra Connect deployment
• Hybrid identity architecture design
• Directory-anchored identity synchronization
• UPN namespace remediation
• Authentication troubleshooting
• Kerberos and cloud identity coexistence validation
• Operational documentation and recovery procedures

---

## Conclusion

This module transitioned the environment from a standalone directory service into a hybrid identity platform.

The project demonstrated not only connector deployment, but identity reliability engineering — diagnosing authentication failure, correcting architectural misalignment, and validating cross-environment authentication.

The environment now supports a single enterprise identity that functions both internally and in the cloud while maintaining Active Directory as the authoritative identity source.

---

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Module:** 03 — Hybrid Identity
**Document Type:** Implementation & Operations Article
**Last Reviewed:** February 2026

