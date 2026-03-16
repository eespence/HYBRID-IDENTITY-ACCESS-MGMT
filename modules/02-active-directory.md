# Module 02: On-Premises Identity (Active Directory)

**Module**: 02 - On-Premises Identity (Active Directory)
**Status**: ✅ **COMPLETE (Corrected & Validated)**
**Built by**: Edward E. Spence
**Completed**: February 14, 2026 *(Revised after infrastructure validation)*
**Purpose**: Establish centralized identity and authentication foundation for IAM/PAM lab

---

## 📋 Module Overview

This module establishes the on-premises identity foundation using Active Directory Domain Services, creating a centralized authentication and authorization platform for the IAM/PAM environment.

### What You Built ✅

* ✅ Active Directory Domain Services installed on DC01
* ✅ Domain created: `IAMPAM.LAB`
* ✅ DNS configured and operational
* ✅ Organizational Units (OUs) structure created
* ✅ Test user accounts created
* ✅ Computer accounts domain-joined and organized
* ✅ Production-ready identity infrastructure
* ✅ Enterprise-correct Kerberos time hierarchy implemented

---

## 🏗️ Active Directory Architecture

### Domain Information

| Property                    | Value                              |
| --------------------------- | ---------------------------------- |
| **Domain Name**             | IAMPAM.LAB                         |
| **NetBIOS Name**            | IAMPAM                             |
| **Forest Functional Level** | Windows Server 2016 (WinThreshold) |
| **Domain Functional Level** | Windows Server 2016 (WinThreshold) |
| **Domain Controller**       | DC01 (172.31.100.10)               |
| **DNS Server**              | DC01 (172.31.100.10)               |

---

### Organizational Units Structure

| OU Name                     | Purpose                          | Objects               |
| --------------------------- | -------------------------------- | --------------------- |
| **IAM-PAM-Users**           | Domain user accounts             | Admin User, Jane Doe  |
| **IAM-PAM-Groups**          | Security and distribution groups | (Reserved for future) |
| **IAM-PAM-ServiceAccounts** | Service account objects          | (Reserved for future) |
| **IAM-PAM-Computers**       | Domain-joined computers          | CLIENT01, MGMT01      |

---

## 👥 User Accounts Created

| Display Name | Username  | UPN                                                 | Location         | Status    |
| ------------ | --------- | --------------------------------------------------- | ---------------- | --------- |
| Admin User   | adminuser | [adminuser@iampam.lab](mailto:adminuser@iampam.lab) | OU=IAM-PAM-Users | ✅ Enabled |
| Jane Doe     | jdoe      | [jdoe@iampam.lab](mailto:jdoe@iampam.lab)           | OU=IAM-PAM-Users | ✅ Enabled |

**Password Policy**: Default domain policy (lab usage only)

---

## 💻 Domain-Joined Systems

| Computer Name | Operating System    | IP Address    | OU Location          | Status   |
| ------------- | ------------------- | ------------- | -------------------- | -------- |
| **CLIENT01**  | Windows 11 Pro      | 172.31.100.30 | OU=IAM-PAM-Computers | ✅ Joined |
| **MGMT01**    | Windows Server 2022 | 172.31.100.20 | OU=IAM-PAM-Computers | ✅ Joined |

---

## 🌐 DNS Configuration

### DNS Zones Created

| Zone Type      | Zone Name               | Status   |
| -------------- | ----------------------- | -------- |
| Forward Lookup | IAMPAM.LAB              | ✅ Active |
| Reverse Lookup | 100.31.172.in-addr.arpa | ✅ Active |

### Key DNS Records

| Name                      | Type | Value           | Purpose                 |
| ------------------------- | ---- | --------------- | ----------------------- |
| DC01                      | A    | 172.31.100.10   | Domain Controller       |
| _ldap._tcp.IAMPAM.LAB     | SRV  | DC01.IAMPAM.LAB | LDAP service location   |
| _kerberos._tcp.IAMPAM.LAB | SRV  | DC01.IAMPAM.LAB | Kerberos authentication |
| _gc._tcp.IAMPAM.LAB       | SRV  | DC01.IAMPAM.LAB | Global Catalog          |

---

## 🔧 Implementation Summary

Active Directory Domain Services was installed and DC01 promoted to the first domain controller in a new forest (IAMPAM.LAB). DNS was automatically configured during promotion and verified operational. Organizational Units were created to support role separation and future delegation. Domain users and computer objects were created and organized accordingly. CLIENT01 and MGMT01 successfully joined the domain.

---

## 🔍 Testing & Validation

### Domain Membership Verification

```
systeminfo | findstr /C:"Domain"
Expected:
Domain: IAMPAM.LAB
```

### DNS Resolution

```
nslookup IAMPAM.LAB
nslookup DC01.IAMPAM.LAB
```

Both commands successfully resolved to 172.31.100.10.

---

## 🔐 Kerberos Authentication Validation

After resolving a domain controller authentication instability, domain authentication was verified by obtaining a Kerberos Ticket Granting Ticket (TGT).

The AdminUser domain account successfully authenticated to DC01 and received a valid `krbtgt` ticket.

The ticket shows the Key Distribution Center (KDC) as **DC01.IAMPAM.LAB**, confirming:

• Secure channel communication
• Kerberos ticket issuance
• Functional domain authentication
• Time synchronization within Kerberos tolerance

This is the authoritative proof that Active Directory authentication services are operational.

---

## ⏱️ Active Directory Time Hierarchy (Critical Infrastructure Correction)

During validation, a Kerberos secure channel instability was identified. Investigation revealed that **DC01 (PDC Emulator) was operating on Local CMOS Clock due to absence of an authoritative upstream time source.**

In virtualized Active Directory environments, reliance on Local CMOS Clock can cause Kerberos timestamp validation failures due to drift and lack of hierarchical synchronization.

### Root Cause

The PDC Emulator (DC01) did not have a reachable external time authority. Because the lab network is isolated, DC01 had no upstream NTP server. As a result, Windows Time Service defaulted to Local CMOS Clock, which caused authentication instability.

Kerberos authentication requires timestamp validation within strict tolerance. Without a trusted time source, the secure channel between domain members and the domain controller becomes unreliable.

---

## 🏗️ Implemented Time Synchronization Architecture

An internal time hierarchy was implemented while preserving network isolation.

```
Internet NTP (pool.ntp.org)
        ↓
MGMT01 (172.31.100.20) – Internal NTP Relay
        ↓
DC01 (172.31.100.10) – PDC Emulator / Domain Time Authority
        ↓
Domain Members (CLIENT01)
```

### Design Principles

• DC01 remains isolated from internet access
• MGMT01 acts as dual-homed management and NTP relay server
• PDC Emulator becomes authoritative time source for domain
• Hypervisor time provider disabled
• Windows Time Service configured in NTP mode

---

## 🔧 Final Validated Configuration

### MGMT01

MGMT01 synchronizes with external NTP servers:

```
w32tm /query /source
pool.ntp.org
```

---

### DC01

DC01 synchronizes with MGMT01:

```
w32tm /query /source
172.31.100.20,0x8
```

```
w32tm /query /configuration
NtpServer: 172.31.100.20,0x8
Type: NTP
AnnounceFlags: 5
VMICTimeProvider: Disabled
```

---

### Validation Results

• DC01 successfully synchronizing from MGMT01
• MGMT01 synchronizing from external NTP
• Domain members synchronizing from DC01
• Kerberos ticket issuance stable
• Secure channel verification successful
• Time offset within acceptable Kerberos tolerance

---

## 📊 Configuration Summary

| Component         | Configuration    | Status        |
| ----------------- | ---------------- | ------------- |
| Domain Controller | DC01             | ✅ Operational |
| DNS               | AD Integrated    | ✅ Resolving   |
| Domain            | IAMPAM.LAB       | ✅ Functional  |
| Domain Members    | CLIENT01, MGMT01 | ✅ Joined      |
| Authentication    | Kerberos         | ✅ Verified    |
| Time Hierarchy    | Internal NTP     | ✅ Stable      |

---

## 🎓 Skills Demonstrated

* Active Directory deployment
* Domain join operations
* DNS for directory services
* OU design and organization
* Authentication verification
* Identity infrastructure validation
* Troubleshooting authentication failures
* Kerberos time synchronization troubleshooting
* Enterprise time hierarchy design

---

## 🔐 Security & Operational Notes

The environment now provides a stable identity provider for future IAM and PAM integrations.

All authentication in Active Directory depends on:

• DNS resolution
• Domain controller availability
• FSMO role operation
• **Authoritative time hierarchy (Kerberos dependency)**

Time synchronization is implemented using an internal NTP relay model to preserve isolation while maintaining enterprise-grade authentication stability.

---


## 🚀 Next Module

Module 03 will extend identity into hybrid identity by synchronizing on-premises Active Directory with cloud identity (Microsoft Entra ID).

---

**Built by**: Edward E. Spence
**Environment**: IAMPAM.LAB
**Systems**: DC01, MGMT01, CLIENT01
**Platform**: Proxmox VE

---

*Active Directory authentication infrastructure operational and validated.*

