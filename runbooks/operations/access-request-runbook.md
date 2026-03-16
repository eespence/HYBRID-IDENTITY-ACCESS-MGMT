# Access Request Runbook

**Maintained by:** Edward E. Spence  
**Environment:** Fairmont Manufacturing Identity Security Lab  
**Document Type:** IAM Operations Runbook  
**Last Reviewed:** February 2026

Fairmont Manufacturing Identity Security Lab

---

## Purpose

This runbook documents the procedure for granting, modifying, and removing user access within the Active Directory environment.

The objective is to provide required access while enforcing least privilege and ensuring administrative actions are traceable.

This runbook also includes **identity platform health verification**.
Access changes must not be performed unless the authentication infrastructure is operating normally.

---

## Environment

| System   | Function                                        |
| -------- | ----------------------------------------------- |
| DC01     | Active Directory Domain Controller              |
| MGMT01   | Administrative Workstation & Internal NTP Relay |
| CLIENT01 | Standard User Workstation                       |
| LINUX01  | Privileged Target System                        |

---

## When To Use

Use this runbook when:

* A new user requires access to resources
* An existing user needs additional permissions
* Temporary administrative access is required
* Access must be removed
* Authentication reliability must be verified

---

## 0. **Pre-Change Health Verification (MANDATORY)**

Before modifying permissions, verify the identity infrastructure is functioning.

This prevents granting access while Active Directory is unhealthy.

---

### Step 1 — Verify Domain Controller Time Authority (DC01)

On **DC01**:

```
w32tm /query /source
```

**Expected Result:**

```
172.31.100.20
```

NOT acceptable:

```
Local CMOS Clock
```

If Local CMOS Clock appears → STOP.
Do NOT modify user access. Escalate to identity infrastructure troubleshooting.

---

### Step 2 — Verify Internal NTP Relay (MGMT01)

On **MGMT01**:

```
w32tm /query /source
```

Expected:

```
pool.ntp.org (or external NTP source)
```

This confirms the domain has a reliable upstream time authority.

---

### Step 3 — Verify Secure Channel (CLIENT01)

On **CLIENT01** (logged in as AdminUser):

```
Test-ComputerSecureChannel -Verbose
```

Expected:

```
True
```

If False → domain authentication is unstable.
STOP and investigate before granting permissions.

---

### Step 4 — Verify Kerberos Ticket Issuance

On **CLIENT01**:

```
klist
```

Expected:

* A Ticket Granting Ticket (TGT) issued by `DC01.IAMPAM.LAB`

This confirms:

* Domain authentication working
* KDC reachable
* Time synchronization valid

---

### Baseline Verification Evidence

The following baseline states confirm a healthy identity platform:

* CLIENT01 authenticated to domain
* DC01 acting as domain time authority
* MGMT01 acting as internal NTP relay

Screenshots stored in:

```
screenshots/module-02/baselines/
```

---

## 1. Request Intake

An access request must contain:

* User identity
* Requested resource
* Business need
* Duration (permanent or temporary)

If business need is unclear, access is not granted.

---

## Authorization Requirement (Separation of Duties)

Access must be approved before implementation.

The implementer of the change must NOT be the approver of the change.

Required approval sources:

• Direct manager of the user
• Resource owner (application owner or system owner)
• Security/IAM administrator (for privileged access)

Requests lacking documented approval must not be fulfilled.

This enforces separation of duties and prevents unauthorized privilege escalation.

---

### Approval Evidence

Approval must be retained and recorded with the change documentation.

Acceptable forms of approval:

• Ticketing system record
• Email approval from authorized manager
• Change request approval record

The following information must be documented:

• Approver name
• Date approved
• Resource authorized
• Duration of access

No approval → No access.

---

## 2. Identity Verification

From **MGMT01**:

1. Open **Active Directory Users and Computers**
2. Navigate to:

```
IAM-PAM-Users OU
```

3. Locate the user account
4. Verify:

* Account exists
* Account is enabled
* User matches the request

If the account does not exist, stop and follow the account provisioning process.

---

## 3. Determine Appropriate Access (Least Privilege)

Access is assigned using **security groups only**.

Never assign permissions directly to a user account.

| Request               | Implementation                   |
| --------------------- | -------------------------------- |
| Department file share | Add to department security group |
| Application access    | Add to application group         |
| Server login          | Add to server access group       |
| Administrative task   | Temporary admin group membership |

---

## 4. Grant Access (GUI)

On **MGMT01**:

1. Open **Active Directory Users and Computers**
2. Locate the user
3. Right-click → **Properties**
4. Select **Member Of**
5. Click **Add**
6. Enter security group
7. Apply and close

---

## 5. Apply and Validate

On CLIENT01:

```
gpupdate /force
```

User signs out and signs back in.

Confirm:

* Successful login
* Access to requested resource
* No additional unintended permissions

---

## 6. Administrative (Temporary) Access

Administrative access must be time-limited.

Procedure:

1. Add user to temporary admin group
2. User performs required task
3. Remove user from group immediately after task completion
4. Confirm group membership removal

---

## 7. Log Verification (Manual)

On DC01:

Open:

```
Event Viewer → Windows Logs → Security
```

Confirm:

* Successful logon events recorded
* Group membership applied
* No repeated authentication failures

---

## 8. Documentation

Record the change:

* Date
* User
* Access granted or removed
* Reason
* Implementer
* Expiration (if temporary)

---

## 9. Revoking Access

When access is no longer required:

1. Remove user from security group
2. Force user sign-out
3. Confirm resource access denied

---

## Security Principles Applied

* Least privilege
* Group-based access control
* Temporary elevation
* Traceable administrative actions
* Identity health verification before change

---
