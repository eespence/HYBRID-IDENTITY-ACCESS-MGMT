# 🎯 Simulated Enterprise Identity Security Environment (IAM/PAM)

---

## 📋 Project Overview

This repository documents the design, deployment, operation, and troubleshooting of a simulated enterprise identity platform.

The environment models how an organization centrally manages authentication, authorization, and privileged access across multiple systems.

Rather than focusing only on installing software, this project demonstrates **identity operations**, including:

• user onboarding
• access provisioning and removal
• privileged access control
• authentication troubleshooting
• Kerberos and secure channel repair
• hybrid identity synchronization
• conditional cloud authentication
• identity lifecycle management

Primary Identity Used: **Jane Doe — Finance Department Employee**

**Current State:**
Active Directory operational and validated.
Kerberos authentication stabilized using an internal domain time hierarchy.
Hybrid identity (Microsoft Entra ID) synchronization operational, directory-anchored, and scoped via security group filtering.

---

## Why This Project Exists

Modern organizations depend on identity systems more than any single server.
If identity fails, **everything fails** — login, remote access, file shares, and administrative control.

This environment was built to practice operating identity infrastructure the same way an internal IAM or PAM engineer would inside an organization.

The project emphasizes:

• authentication reliability
• operational procedures
• change control
• recovery capability
• security principles (least privilege, separation of duties)

---

## Simulated Organization

**Organization:** Fairmont Manufacturing (fictional)

Fairmont Manufacturing is modeled as a mid-sized company with multiple departments including Finance, Human Resources, and IT.

The identity platform represents how employee accounts and privileged access are managed inside a business environment.

Primary Identity: Jane Doe
Department: Finance

---

## 🏗️ Architecture Summary

### Network Design

* **Isolated Identity Network:** `172.31.100.0/24` (vmbrPAM)
* **Management NAT Network:** `192.168.100.0/24` (vmbrNAT)
* **Physical Network:** `192.168.8.0/24` (vmbr0)
* **Proxmox Host:** `192.168.8.100`
* **Domain DNS Server:** `172.31.100.10` (DC01)

### VM Inventory (3000 Series)

| VM ID | Hostname  | Role                                   | IP (vmbrPAM)  | Internet |
| ----- | --------- | -------------------------------------- | ------------- | -------- |
| 3000  | DC01      | Domain Controller / KDC                | 172.31.100.10 | No       |
| 3001  | MGMT01    | Management Server / Internal NTP Relay | 172.31.100.20 | Yes      |
| 3002  | CLIENT01  | Domain User Workstation                | 172.31.100.30 | No       |
| 3003  | LINUX01   | Privileged Linux Target                | 172.31.100.40 | No       |
| 3999  | ID-SYNC01 | Microsoft Entra Connect Sync Server    | 172.31.100.25 | Yes      |
| 3004  | PAM01     | Privileged Access Platform (Planned)   | 172.31.100.50 | Yes      |
| 3005  | SIEM01    | Logging & Monitoring Platform          | 172.31.100.60 | Yes      |

---

## 🔐 Critical Engineering Event — Kerberos Authentication Failure

During deployment, domain authentication began failing.
Workstations reported a broken trust relationship with the domain.

Investigation revealed:

**The PDC Emulator (DC01) was using the Local CMOS Clock.**

Kerberos authentication requires synchronized time across all domain systems.
Because the domain controller was not synchronized with a reliable time source, Kerberos ticket validation failed.

### Implemented Solution

An internal domain time hierarchy was designed and deployed:

External NTP → MGMT01 → DC01 (PDC Emulator) → Domain Members

MGMT01 acts as an internal NTP relay because it is dual-homed (isolated network + internet access).

After implementation:

• Kerberos tickets issued successfully
• Secure channel restored
• Domain authentication stabilized

This incident and recovery process is fully documented in the runbooks.

---

## ☁️ Module 03 — Hybrid Identity (Security Group Scoped Synchronization) — Completed

The environment was extended into a hybrid identity architecture by integrating on-premises Active Directory with Microsoft Entra ID.

**Domain:** `IAMPAM.LAB`
**Tenant:** `fairmontmanufacturing.onmicrosoft.com`

A dedicated synchronization server (**ID-SYNC01**) was deployed and validated prior to connector installation.

### Implementation Summary

Microsoft Entra Connect was installed using:

Authentication Method: **Password Hash Synchronization (PHS)**
Installation Type: **Custom**

The connector authenticated to:

• Microsoft Entra ID using Global Administrator credentials
• On-premises Active Directory

Synchronization scope was controlled using a security group:

**AAD-Sync-Users**

Only users added to this group are synchronized to Microsoft Entra ID.

Synchronization was verified by adding domain users (Admin User and Jane Doe) to the AAD-Sync-Users group and running a delta synchronization cycle:

Start-ADSyncSyncCycle -PolicyType Delta

The users appeared in Microsoft Entra ID with:

On-Premises Sync: Yes
Source: Windows Server AD
Immutable ID present

This confirmed directory-anchored hybrid identities were functioning correctly.

---

### Major Incident — Entra Connect Authentication Failure

During configuration, Microsoft Entra Connect authentication failed with:

**"Unsupported Browser"**

Initial troubleshooting focused on:

• WebView2 runtime
• Windows Account Manager
• certificates
• services

The error was misleading.

### Root Cause

The Active Directory domain used a non-routable namespace:

IAMPAM.LAB

Microsoft Entra ID requires a routable UPN namespace for OAuth authentication.

Because the on-premises UPN suffix did not align with the Entra tenant domain, the authentication broker could not construct a valid security context.

This was an **identity architecture failure**, not a software failure.

---

### Remediation

The issue was resolved by aligning identity namespaces:

1. Added routable UPN suffix:
   fairmontmanufacturing.onmicrosoft.com

2. Updated administrator UPN to the new suffix

3. Cleared Kerberos tickets

4. Rebooted the synchronization server

5. Re-ran Microsoft Entra Connect

Authentication immediately succeeded and synchronization initialized.

---

### Final Hybrid Identity State

After correction:

• Connector installation completed
• Synchronization operational
• Scoped users synchronized
• Cloud authentication available
• Directory-anchored identities verified

Hybrid identity authentication now functions across both environments:

Active Directory (Kerberos)
+
Microsoft Entra ID (Cloud Authentication)

---

## 🎓 Identity Operations Demonstrated

• Active Directory deployment and management
• Kerberos authentication troubleshooting
• Domain trust repair
• Secure channel recovery
• Time hierarchy design
• Hybrid identity synchronization
• Namespace architecture correction
• Group-scoped identity synchronization
• Role-based access control (RBAC)
• Access provisioning and deprovisioning
• Change validation and operational documentation

---

## Identity Lifecycle Walkthrough

This environment is operated as a functioning organization.

➡ See: `IDENTITY-LIFECYCLE.md`

The lifecycle models:

1. Employee onboarding
2. Access assignment
3. Privileged elevation
4. Monitoring
5. Termination and deprovisioning

---

# 📚 Module Structure

### Module 01 — Infrastructure & Network Architecture

Design and deployment of isolated identity network and servers.

### Module 02 — Active Directory Identity Core

Active Directory installation, domain configuration, and authentication validation.

Includes:
• Kerberos authentication validation
• Secure channel repair
• Internal NTP hierarchy implementation

### Module 03 — Hybrid Identity

Active Directory synchronized with Microsoft Entra ID.

Includes:
• Microsoft Entra Connect deployment
• Scoped user synchronization
• UPN namespace remediation
• Hybrid authentication validation

### Module 04 — Cloud Identity Federation (Microsoft Entra ID ↔ AWS)

The identity platform was extended beyond Microsoft infrastructure by implementing **SAML-based identity federation between Microsoft Entra ID and Amazon Web Services (AWS)**.

Instead of creating separate AWS IAM users, authentication is centralized through **Microsoft Entra ID**, allowing users to access AWS using their existing enterprise identity.

An Enterprise Application named **AWS-Federation** was created in Microsoft Entra ID and configured for **SAML Single Sign-On**. Federation metadata was exchanged between Entra ID and AWS IAM to establish a trusted identity provider relationship.

A federated IAM role named **EntraID-Federated-Admin** was created in AWS, allowing authenticated Entra users to assume the role through **AWS Security Token Service (STS)** and access the AWS console.

During implementation an authentication failure occurred due to a misconfigured **Sign-on URL** in the Entra SAML configuration.
The issue was resolved by clearing the Sign-on URL field, allowing Entra to correctly perform **IdP-initiated SAML authentication** through the MyApps portal.

After remediation, federated authentication was validated and AWS console access was successfully granted using centralized identity.

---

# Module 05 — Identity Governance

## Overview

Module 05 introduces identity governance controls within the hybrid identity environment. Governance ensures that identity access is assigned, reviewed, and enforced according to enterprise security policies.

The governance model implemented in this module includes:

• Role-Based Access Control (RBAC)
• Identity lifecycle management
• Access review validation
• Separation of Duties (SoD) enforcement

These governance controls operate across the hybrid identity platform connecting **Active Directory** and **Microsoft Entra ID**.

---

# Module 06 — Privileged Access Management

## Overview

Module 06 introduces **Privileged Access Management (PAM)** controls within the enterprise identity architecture.

While previous modules established identity governance and lifecycle management, this phase focuses specifically on **securing high-risk administrative access**.

Privileged identities have the ability to control critical systems such as domain controllers, servers, and security infrastructure.
Because of this elevated capability, privileged accounts must be isolated, monitored, and tightly controlled.

The PAM model implemented in this module demonstrates:

• privileged account isolation
• role-based privileged delegation
• administrative workstation enforcement
• cross-platform privileged administration
• periodic privileged access review

These controls represent the foundational principles used by enterprise IAM/PAM engineering teams to secure administrative access paths.

---

# Implementation

## Step 1 — Privileged Accounts Organizational Unit

A dedicated organizational unit named **Privileged-Accounts** was created inside Active Directory.

This organizational unit isolates privileged identities from standard user accounts, preventing administrative credentials from being mixed with normal business identities.

### Evidence

![Privileged Accounts OU](screenshots/module-06/module6_01_privileged_accounts_ou.png)

---

## Step 2 — Privileged Administrative Identities

Dedicated administrative identities were created for privileged operations.

Examples include:

• admin.dc01
• admin.server
• admin.security

These accounts are used exclusively for elevated administrative activity and are not used for day-to-day user operations.

### Evidence

![Privileged Accounts Created](screenshots/module-06/module6_02_privileged_accounts_created.png)

---

## Step 3 — PAM Security Groups

Privileged access roles were implemented using security groups.

Examples:

• PAM-Domain-Admins
• PAM-Server-Admins
• PAM-Security-Admins

These groups provide **role-based delegation for privileged permissions**.

### Evidence

![PAM Security Groups](screenshots/module-06/module6_03_pam_security_groups.png)

---

## Step 4 — Privileged Role Assignment

Administrative identities were assigned to their respective PAM roles.

This ensures that permissions are inherited through **group membership rather than direct assignment**.

### Evidence

![PAM Group Membership](screenshots/module-06/module6_04_pam_group_membership.png)

---

## Step 5 — Privilege Delegation Through Group Nesting

PAM groups were nested into privileged Active Directory roles.

Example:

PAM-Domain-Admins → Domain Admins

This indirect privilege model improves auditability and reduces direct exposure of privileged roles.

### Evidence

![PAM Group Nesting](screenshots/module-06/module6_05_pam_group_nesting.png)

---

## Step 6 — Administrative Workstation Enforcement

Administrative identities were granted remote access to the **MGMT01 administrative workstation**.

Privileged logins are intended to originate from controlled administrative systems rather than standard user workstations.

### Evidence

![MGMT01 RDP Permissions](screenshots/module-06/module6_06_mgmt01_rdp_permissions.png)

---

## Step 7 — Administrative Login Validation

Administrative access was validated by logging into **MGMT01** using a privileged identity.

Commands such as `hostname` and `whoami` were used to confirm the administrative session context.

### Evidence

![Admin Login MGMT01](screenshots/module-06/module6_07_admin_login_mgmt01.png)

---

## Step 8 — Privilege Boundary Validation

Administrative access behavior was observed from a standard workstation environment.

This test demonstrates the separation between privileged administrative workstations and standard user endpoints.

### Evidence

![Admin Login CLIENT01](screenshots/module-06/module6_08_admin_login_client01_gap.png)

---

## Step 9 — Linux Privileged Identity

Privileged access management was extended to Linux systems by creating an administrative identity on **LINUX01**.

The account was configured with elevated privileges using `sudo`.

### Evidence

![Linux Account Created](screenshots/module-06/module6_09_linux_account_created.png)

---

## Step 10 — Linux Privilege Validation

Administrative privilege capability was validated using the following command:

```
sudo -l
```

This confirms that the Linux administrative account can execute privileged commands.

### Evidence

![Linux Sudo Validation](screenshots/module-06/module6_10_linux_sudo_validation.png)

---

## Step 11 — Privileged Access Review

Privileged roles were reviewed to ensure that only authorized identities possess elevated access.

Periodic access reviews are a critical component of enterprise PAM governance.

### Evidence

![Privileged Access Review](screenshots/module-06/module6_11_privileged_access_review.png)

---

# Outcome

At the conclusion of Module 06, the identity environment now includes a structured **Privileged Access Management model**.

The architecture enforces:

• isolation of privileged identities
• role-based delegation of administrative privileges
• administrative workstation usage
• cross-platform privileged account control
• periodic privileged access validation

These controls significantly reduce the attack surface associated with privileged identities and prepare the environment for **privileged access monitoring and incident detection in the next phase**.

---

# Module 07 — IAM & PAM Logging / Incident Response

With privileged access controls implemented in Module 06, the identity platform was extended to include **centralized monitoring and security event detection**.

Enterprise identity environments must continuously monitor authentication activity and privileged access behavior in order to detect abnormal identity usage, unauthorized access attempts, and administrative misuse.

To provide this visibility, a centralized monitoring platform was deployed using **Splunk Enterprise** on the **SIEM01** system.

Splunk collects authentication telemetry from multiple identity infrastructure systems through **Splunk Universal Forwarders** installed on:

• DC01 — Domain Controller
• MGMT01 — Administrative Workstation
• CLIENT01 — Domain Workstation
• ID-SYNC01 — Entra Connect Synchronization Server
• LINUX01 — Privileged Linux Server

Authentication events and system logs are securely forwarded to Splunk using **TCP port 9997**, where they are indexed and analyzed.

The monitoring platform captures critical identity security signals including:

• Windows authentication events (successful and failed logins)
• privileged login activity
• administrative workstation usage
• Linux sudo command execution
• SSH authentication sessions

Example Windows security events monitored include:

| Event ID | Description               |
| -------- | ------------------------- |
| 4624     | Successful authentication |
| 4625     | Failed authentication     |
| 4672     | Privileged login          |

Linux authentication telemetry is collected from:

```
/var/log/auth.log
```

Centralizing these signals allows administrators to investigate authentication activity across the identity environment and identify abnormal behavior associated with compromised credentials or unauthorized privileged access.

At the conclusion of Module 07, the identity platform now includes a **centralized identity monitoring capability**, enabling administrators to review authentication activity, investigate potential incidents, and maintain operational visibility into privileged access across both Windows and Linux systems.

This monitoring capability prepares the environment for the next phase of the project, which focuses on **identity automation and policy enforcement**.

---

### Module 08 — Identity Automation & Policy Enforcement

Module 08 introduces **automated identity monitoring and enforcement** within the IAMPAM.LAB environment using Splunk scheduled detections.

Previous modules established the core identity security architecture, including Active Directory authentication, hybrid identity federation, privileged access management, and centralized log ingestion. With these foundational controls in place, this module adds the **automation layer** of identity security monitoring.

Authentication telemetry generated across Windows and Linux systems is evaluated using automated Splunk searches that detect suspicious authentication behavior and trigger alerts.

Key detection scenarios validated in this module include:

• Windows authentication telemetry validation  
• Failed login detection across domain systems  
• Authentication sequence investigation (failed → successful login patterns)  
• Privileged account logon monitoring  
• Linux privilege escalation monitoring using `sudo` activity  
• Automated alert generation through Splunk scheduled searches  

By implementing automated identity monitoring rules, the SIEM platform can continuously evaluate authentication telemetry and generate alerts when suspicious activity occurs.

This module demonstrates how modern security operations teams automate identity monitoring workflows to detect credential abuse, brute-force authentication attempts, and privilege escalation events across enterprise identity environments.

**Technologies Used**

• Active Directory  
• Splunk Enterprise  
• Splunk Universal Forwarder  
• Windows Security Event Logs  
• Linux Authentication Logs (`/var/log/auth.log`)  
• SIEM Scheduled Detection Rules

---

# Module 09 — Identity Security Architecture

## Overview

Module 09 concludes the IAMPAM.LAB project by presenting the **complete identity security architecture** that integrates all previously implemented components.

While earlier modules focused on building individual identity capabilities — such as Active Directory authentication, hybrid identity synchronization, federation, governance, privileged access management, and monitoring — this module consolidates those systems into a **single architectural model**.

The objective is to demonstrate how enterprise identity infrastructure operates as a **layered security architecture**, where each component depends on and reinforces the others.

Rather than representing isolated configuration exercises, the environment now functions as a **complete enterprise identity security platform**.

---

## Identity Security Architecture

The final architecture integrates identity authority, hybrid identity synchronization, federation, governance, privileged access control, monitoring, and automation into a single operational model.

![IAMPAM Architecture](screenshots/module-09/module9_01_full_architecture_diagram.png)

The architecture is organized around a **segmented privileged identity network (172.31.100.0/24)** where core identity services operate in isolation from external systems.

Above this network sits the **cloud identity federation layer**, where Microsoft Entra ID provides cloud identity services and federates authentication to AWS.

Below the identity platform sits the **infrastructure layer**, where Proxmox provides the virtualization platform that hosts the environment.

Each layer builds upon the previous layer to create a complete identity security architecture.

---

## Architecture Layers

### Identity Authority Layer

Active Directory Domain Services operates as the **primary identity authority** for the environment.

The **DC01 domain controller** provides:

• Kerberos authentication services
• directory identity storage
• group membership management
• domain security policy enforcement

All other identity services within the architecture ultimately depend on this system.

This mirrors real enterprise environments where Active Directory remains the **authoritative source of identity**.

---

### Hybrid Identity Layer

Hybrid identity synchronization is provided by **Microsoft Entra Connect** running on **ID-SYNC01**.

This system synchronizes on-premises identities to Microsoft Entra ID, allowing organizations to extend authentication capabilities to cloud platforms without abandoning their internal identity authority.

Hybrid identity provides:

• synchronized user identities
• cloud authentication capability
• centralized identity management across environments

This layer bridges traditional identity infrastructure with modern cloud identity systems.

---

### Federation Layer

The architecture extends into cloud infrastructure through **SAML federation between Microsoft Entra ID and AWS**.

In this model:

• Microsoft Entra ID functions as the identity provider
• AWS trusts Entra through a configured SAML federation relationship

When users authenticate through Entra, AWS grants access through federated roles without requiring separate AWS credentials.

This design eliminates credential sprawl and centralizes authentication control.

---

### Governance Layer

Identity governance controls are implemented through role-based access control and structured identity lifecycle procedures.

Governance controls include:

• role-based access assignments
• group-scoped identity synchronization
• access review procedures
• separation of duties

These controls ensure that identity permissions are assigned and maintained according to enterprise security principles.

---

### Privileged Access Management Layer

Privileged access management controls protect administrative accounts and sensitive systems.

The architecture implements:

• privileged administrative identities
• role-based privileged group delegation
• administrative workstation enforcement
• cross-platform privileged access

Administrative operations are performed from the **MGMT01 management workstation**, while privileged Linux access is controlled on **LINUX01**.

These controls reduce the attack surface associated with administrative credentials.

---

### Monitoring and Detection Layer

Centralized monitoring is implemented using **Splunk Enterprise (SIEM01)**.

Authentication telemetry from identity systems is forwarded to Splunk through **Splunk Universal Forwarders** using TCP port 9997.

Logs collected include:

• Windows authentication events
• privileged login activity
• Linux sudo command execution
• SSH authentication attempts

Centralizing identity telemetry allows administrators to detect abnormal authentication patterns and investigate potential security incidents.

---

### Automation Layer

Identity monitoring is extended through automated detection rules configured in Splunk.

Scheduled searches analyze authentication telemetry and generate alerts when suspicious behavior is detected.

Examples include:

• repeated authentication failures
• privileged account activity monitoring
• abnormal login patterns

This automation layer represents how security operations teams detect identity-based threats in real enterprise environments.

---

### Infrastructure Layer

The entire environment operates on the **Proxmox virtualization platform**, which hosts all identity infrastructure systems.

Virtual network segmentation separates identity services from external networks while allowing controlled internet connectivity where required.

Network segments include:

• vmbr0 — physical network
• vmbrNAT — management internet access
• vmbrPAM — isolated privileged identity network

This layered infrastructure design reflects common enterprise architecture patterns used to protect identity systems.

In a production enterprise environment, this architecture would also include disaster recovery and high availability controls such as secondary domain controllers, SIEM redundancy, and documented recovery procedures. These components were intentionally excluded from the simulation because the focus of the project is identity security architecture rather than infrastructure resiliency.

---

## Lessons Learned

Building a layered identity security environment demonstrates how multiple identity technologies interact within a unified architecture.

Key lessons from this project include:

• identity infrastructure must remain the authoritative source of authentication
• hybrid identity synchronization requires careful namespace design
• federated authentication simplifies multi-platform identity management
• privileged accounts must be isolated and tightly controlled
• centralized monitoring provides visibility into authentication behavior

Future iterations of this environment could extend the architecture by introducing **additional identity federation providers and automated identity lifecycle orchestration**.

---

## Final Outcome

At the conclusion of Module 09, the IAMPAM.LAB environment now represents a **complete simulated enterprise identity security architecture**.

The project demonstrates how organizations integrate identity authority, hybrid identity synchronization, federation, governance controls, privileged access management, monitoring platforms, and automation systems into a cohesive identity security platform.

This architecture models the operational responsibilities of enterprise **IAM and PAM engineering teams**, providing hands-on experience with identity infrastructure design, deployment, and security monitoring.

---

## 📸 Evidence & Validation

Authentication validation, hybrid identity synchronization, governance controls, privileged access management, monitoring telemetry, and final architecture design are documented with screenshots captured during system operation.

Locations:

* [baseline screenshots](screenshots/baseline/)
* [connectivity screenshots](screenshots/connectivity/)
* [module 02 screenshots](screenshots/module-02/)
* [module 03 screenshots](screenshots/module-03/)
* [module 04 screenshots](screenshots/module-04/)
* [module 05 screenshots](screenshots/module-05/)
* [module 06 screenshots](screenshots/module-06/)
* [module 07 screenshots](screenshots/module-07/)
* [module 08 screenshots](screenshots/module-08/)
* [module 09 screenshots](screenshots/module-09/)

The Module 09 directory contains the final architecture diagram illustrating how all identity systems integrate into a unified enterprise identity security platform.

Each directory contains captured evidence confirming the identity platform is operating as designed.

---

## Lab Modules

Module 01 — Infrastructure Foundation  
Module 02 — Active Directory Identity Authority  
Module 03 — Hybrid Identity Synchronization (Entra Connect)  
Module 04 — AWS Federation (SAML)  
Module 05 — Identity Governance  
Module 06 — Privileged Access Management Design  
Module 07 — Identity Logging and Security Monitoring (Splunk)  
Module 08 — Automation & Policy as Code  
Module 09 — Architecture & Documentation

---

Maintained by: **Edward E. Spence**
