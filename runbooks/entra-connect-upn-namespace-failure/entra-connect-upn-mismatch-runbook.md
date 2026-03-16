# Entra Connect UPN Namespace Mismatch Recovery Runbook
## Incident: Microsoft Entra Connect Authentication Failure ("Unsupported Browser")

**Maintained by:** Edward E. Spence  
**Environment:** Fairmont Manufacturing Identity Security Lab  
**Document Type:** IAM Operations Runbook  
**Last Reviewed:** February 2026

---

## Incident Classification

Service: Hybrid Identity (Active Directory ↔ Microsoft Entra ID)  
Severity: High  
Impact: Cloud authentication unavailable  
Affected Systems: DC01, ID-SYNC01

---

## Executive Summary

During Microsoft Entra Connect configuration, authentication failed with the error:

"Unsupported Browser"

Initial investigation suggested a client-side or WebView issue.  
Root cause analysis determined the failure was caused by a UPN namespace mismatch between on-premises Active Directory and Microsoft Entra ID.

The on-premises domain used a non-routable suffix (.LAB), preventing proper OAuth token construction during device registration.

Hybrid identity synchronization was restored after namespace alignment and connector re-authentication.

---

## Symptoms

• Entra Connect sign-in window appears  
• Global Administrator authentication fails  
• Error: "Unsupported Browser"  
• Connector configuration cannot complete  
• No synchronization occurs  
• No users appear in Microsoft Entra ID

---

## Root Cause

Active Directory domain:

```
IAMPAM.LAB
```

Microsoft Entra tenant domain:

```
fairmontmanufacturing.onmicrosoft.com
```

Microsoft Entra requires a routable UPN namespace during OAuth device registration.

Because the on-premises UPN suffix did not match a verified cloud domain, the Windows authentication broker could not construct a valid authentication security context. The authentication broker therefore returned a generic error:

"Unsupported Browser"

This was an identity architecture failure — not a browser or software failure.

---

## Verification Steps

### 1. Confirm UPN Suffix

On DC01:

Open  
Active Directory Domains and Trusts → Properties

If only `.LAB` or `.LOCAL` exists, hybrid identity authentication will fail.

---

### 2. Confirm Administrator UPN

On DC01:

Open  
Active Directory Users and Computers

Locate the Administrator account and review the User Logon Name.

If the UPN suffix does not match a Microsoft Entra verified domain, remediation is required.

---

## Recovery Procedure

### Step 1 — Add Routable UPN Suffix

On DC01:

Active Directory Domains and Trusts → Properties → UPN Suffixes

Add:

```
fairmontmanufacturing.onmicrosoft.com
```

Apply changes.

---

### Step 2 — Update Administrator Account

Modify the administrator account UPN:

From:
```
Administrator@IAMPAM.LAB
```

To:
```
Administrator@fairmontmanufacturing.onmicrosoft.com
```

Apply changes.

---

### Step 3 — Clear Kerberos Tickets

On ID-SYNC01:

```powershell
klist purge
```

Reboot ID-SYNC01.

---

### Step 4 — Re-run Entra Connect

On ID-SYNC01:

Launch:

```
AzureADConnect.msi
```

Select:

```
Custom Installation
```

Authenticate using the updated administrator UPN.

---

## Expected Outcome

• Authentication succeeds  
• Entra Connect configuration completes  
• Synchronization initializes  
• Hybrid identity operational

---

## Post-Recovery Validation

On ID-SYNC01:

```powershell
Start-ADSyncSyncCycle -PolicyType Initial
```

In Microsoft Entra Admin Center:

Users → All Users

Confirm at least one account shows:

```
On-Premises Sync: Yes
```

---

## Post-Recovery Validation — Scoped Synchronization

This environment uses **Security Group-Based Filtering** for Microsoft Entra Connect.

Only users who are members of the following Active Directory group are synchronized:

```
AAD-Sync-Users
```

Connector success alone does not guarantee user provisioning.

If synchronization completes but users do not appear in Microsoft Entra ID, verify synchronization scope.

---

### Step 1 — Verify Group Membership

On DC01:

Active Directory Users and Computers → Users → AAD-Sync-Users → Members

If the user is not listed, add the user to the group.

---

### Step 2 — Trigger Delta Synchronization

On ID-SYNC01:

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

---

### Step 3 — Verify Cloud Identity

In Microsoft Entra Admin Center:

Users → All Users

Open the user account and confirm:

```
On-Premises Sync: Yes
```

---

### Expected Result

The user account appears in Microsoft Entra ID and becomes directory-anchored to Active Directory.

---

### Operational Note

In group-filtered environments, Microsoft Entra ID user provisioning is controlled by Active Directory group membership.

Adding a user to Active Directory alone does not create a cloud identity.  
The user must be added to the AAD-Sync-Users security group.

---

## Preventive Control

Before deploying Microsoft Entra Connect:

• Validate routable UPN namespace  
• Verify tenant domain  
• Confirm DNS resolution  
• Confirm time synchronization  
• Confirm domain trust health

---

## Lessons Learned

Hybrid identity failures frequently stem from:

• Namespace misalignment  
• DNS misconfiguration  
• Time synchronization drift  
• Synchronization scope configuration

Connector errors may present misleading symptoms unrelated to the actual cause.

Identity architecture must always be validated before connector installation.

---

## Closure Criteria

✔ Authentication successful  
✔ Synchronization operational  
✔ Users visible in Microsoft Entra ID  
✔ On-Premises Sync = Yes verified  
✔ No further authentication errors observed
