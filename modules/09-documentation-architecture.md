# Module 09: Documentation & Architecture

**Module:** 09 - Documentation & Architecture
**Status:** Complete
**Environment:** IAMPAM.LAB
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Author:** Edward E. Spence
**Completion Date:** March 2026

---

# Overview

Module 09 serves as the architectural consolidation phase of the **IAMPAM.LAB** identity security environment.

Previous modules implemented the individual components of the identity platform including infrastructure, identity authority, hybrid identity synchronization, federation, governance, privileged access management, centralized monitoring, and automated detection.

This module documents the **entire environment as a unified identity security architecture**, explaining how each system interacts with the others and how the design reflects real-world enterprise identity security practices.

Rather than describing the lab as a sequence of isolated builds, this module explains the environment as a **layered identity control plane** that governs authentication, authorization, monitoring, and detection across the organization.

---

## Architecture Overview

![IAMPAM Architecture](../screenshots/module-09/module9_01_full_architecture_diagram.png)

The **IAMPAM.LAB** environment represents a simulated enterprise identity security architecture designed to demonstrate how modern organizations structure and secure identity infrastructure across on-premises systems, hybrid identity platforms, federated cloud services, governance controls, privileged access boundaries, centralized monitoring, and automated detection.

Rather than existing as isolated technical exercises, the components implemented in Modules 01 through 08 operate as a **single integrated identity security system**.

At the core of the architecture is **Active Directory**, which functions as the authoritative identity provider for on-premises authentication. Hybrid identity synchronization extends this identity authority into **Microsoft Entra ID**, allowing cloud services to authenticate the same identity objects used internally.

Federated trust relationships allow external services, such as **Amazon Web Services**, to rely on Entra ID for authentication using SAML-based federation. Governance and Privileged Access Management layers enforce access control policies that regulate who may access systems and how elevated privileges are assigned.

Operational visibility is provided through **centralized identity telemetry collection using Splunk**, allowing authentication and privilege events across Windows and Linux systems to be monitored and investigated. Automated detection logic further enhances the architecture by transforming authentication telemetry into security alerts.

The resulting architecture models the identity control plane commonly used in enterprise environments where identity systems serve as the foundation for security, access governance, and operational monitoring.

---

# Infrastructure Layer

The infrastructure layer provides the compute, networking, and virtualization foundation upon which all identity services operate.

The entire IAMPAM.LAB environment is hosted on a **Proxmox virtualization platform**, which functions as the hypervisor responsible for running all identity and security infrastructure systems. Virtualization enables network segmentation, system isolation, and flexible resource allocation which are critical for modeling enterprise environments.

The environment uses a segmented network architecture designed to separate identity infrastructure from external exposure. The primary internal identity network operates on the subnet:

```
172.31.100.0/24
```

This network segment hosts all identity-critical systems including the domain controller, synchronization server, administrative workstation, monitoring platform, and authentication endpoints.

Several systems are dual-homed in order to support hybrid connectivity requirements. Management and synchronization systems can access external services when necessary while still operating within the controlled internal identity network.

This infrastructure design mirrors enterprise environments where identity infrastructure is intentionally segmented and protected from direct exposure while still allowing controlled access to external identity providers and monitoring platforms.

All higher layers of the architecture depend on this infrastructure foundation for system availability, network connectivity, and controlled administrative access.

### Disaster Recovery Considerations

In a production enterprise environment, this architecture would include **disaster recovery and high availability considerations** such as a secondary domain controller, SIEM redundancy, and documented recovery time objectives.

These components were intentionally excluded from this simulation as the focus of **IAMPAM.LAB** is identity security architecture rather than infrastructure resilience.

---

# Identity Authority Layer (Active Directory)

The **Identity Authority Layer** is responsible for maintaining the authoritative source of identity objects and authentication services within the environment.

In the IAMPAM.LAB architecture, this role is fulfilled by **Active Directory Domain Services** running on the domain controller:

```
DC01
```

Active Directory provides the following core identity services:

• User and group directory storage
• Kerberos authentication
• LDAP directory queries
• DNS resolution for domain resources
• Security policy enforcement

All domain identities originate in Active Directory. User accounts, security groups, and computer objects are created and managed within the directory and organized through an Organizational Unit structure designed to support governance and privilege delegation.

Active Directory also functions as the **Kerberos Key Distribution Center (KDC)**, issuing authentication tickets that allow domain users and services to securely authenticate across the network.

A carefully designed time hierarchy supports Kerberos authentication stability. The domain controller synchronizes time through an internal NTP relay model using **MGMT01** as the intermediary, ensuring that authentication services remain stable even in a partially isolated network environment.

### Security Hardening Controls

In enterprise environments, the identity authority layer is typically reinforced through domain security policies including:

• **Password complexity policies** enforcing strong credential requirements
• **Account lockout thresholds** to mitigate brute-force authentication attempts
• **Domain audit policy configuration** to ensure authentication and privilege events are logged for monitoring systems

While these controls were not the primary focus of the simulation, they represent standard hardening practices applied to production Active Directory environments.

Because the identity authority layer provides authentication and directory services to all other systems, the entire architecture depends on the availability and integrity of the domain controller.

---

# Hybrid Identity Layer (Microsoft Entra Connect)

The **Hybrid Identity Layer** extends on-premises identity into the cloud by synchronizing Active Directory identities with **Microsoft Entra ID**.

This capability is implemented through the synchronization server:

```
ID-SYNC01
```

ID-SYNC01 runs **Microsoft Entra Connect**, which synchronizes selected identity objects from Active Directory into Microsoft Entra ID using Password Hash Synchronization.

Synchronization is intentionally scoped using the security group:

```
AAD-Sync-Users
```

Only identities placed in this group are synchronized into the cloud directory. This design prevents the entire on-premises directory from being exposed externally and demonstrates how enterprise environments control identity exposure.

Hybrid identity synchronization allows a single identity object to authenticate both internally and within cloud services while still maintaining Active Directory as the authoritative identity source.

The hybrid identity layer depends directly on the identity authority layer because it synchronizes identity objects created and maintained within Active Directory.

---

# Federation Layer (Microsoft Entra → AWS SAML)

The **Federation Layer** allows external service providers to trust Microsoft Entra ID as an identity provider for authentication.

Within the IAMPAM.LAB architecture this capability is demonstrated through **SAML 2.0 federation between Microsoft Entra ID and Amazon Web Services**.

Authentication follows a federated trust flow:

1. The user authenticates to Microsoft Entra ID
2. Entra generates a signed SAML assertion
3. AWS validates the assertion through its configured identity provider
4. AWS Security Token Service issues a temporary role session

This model eliminates the need to create separate AWS IAM users and centralizes authentication through the enterprise identity provider.

Federation ensures that access to external services can be governed through the same identity lifecycle and RBAC policies used internally.

---

# Governance Layer (RBAC and Lifecycle Controls)

The **Governance Layer** enforces policies controlling how identities receive and maintain access across the environment.

Access is implemented using **Role Based Access Control (RBAC)** through Active Directory security groups.

Permissions are never assigned directly to individual users. Instead, users inherit permissions through group membership.

Lifecycle governance includes:

• Joiner events (new account provisioning)
• Mover events (role changes)
• Leaver events (account termination)

Lifecycle changes modify access by adjusting group membership rather than directly modifying permissions.

The governance layer also enforces **Separation of Duties (SoD)** controls ensuring that conflicting roles cannot be assigned to the same user.

These governance controls ensure that access remains structured, auditable, and centrally managed.

---

# Privileged Access Management Layer

The **Privileged Access Management (PAM) Layer** protects administrative privileges within the environment.

Privileged identities are isolated from standard user accounts within a dedicated Active Directory organizational unit:

```
Privileged-Accounts
```

Administrative privileges are delegated using PAM security groups:

```
PAM-Domain-Admins
PAM-Server-Admins
PAM-Security-Admins
```

Administrative activities originate from the controlled management workstation:

```
MGMT01
```

Privileged access extends across both Windows and Linux systems.

Linux administrative access is implemented through a dedicated privileged account on:

```
LINUX01
```

which uses controlled sudo permissions to authorize elevated commands.

This separation of identities significantly reduces the attack surface associated with privileged credentials.

---

# Monitoring Layer (Splunk Logging and Telemetry)

The **Monitoring Layer** provides visibility into authentication activity and privileged access behavior.

Centralized monitoring is implemented using **Splunk Enterprise** on the system:

```
SIEM01
```

Authentication logs from Windows and Linux systems are forwarded using **Splunk Universal Forwarders** over:

```
TCP 9997
```

Identity telemetry collected includes:

• Windows authentication events
• privileged login activity
• group membership changes
• Linux SSH authentication
• Linux sudo command execution

Centralizing this telemetry allows administrators to investigate authentication activity across the entire environment.

---

# Automation Layer (SIEM Detection and Alerting)

The **Automation Layer** converts authentication telemetry into actionable security monitoring.

Splunk scheduled searches evaluate authentication events to detect suspicious behavior including:

• repeated failed logins
• suspicious authentication sequences
• privileged account logins
• Linux privilege escalation activity

Detection rules generate alerts that simulate real security operations workflows.

Automation ensures the monitoring system continuously evaluates identity activity without manual analysis.

---

# Architecture Diagram Description

The final architecture diagram referenced in the evidence section visually represents the complete identity security environment.

The diagram is structured in layered zones beginning with the **Proxmox virtualization host** at the infrastructure level. Above the hypervisor layer the **privileged identity network (172.31.100.0/24)** hosts all identity infrastructure systems.

The **domain controller (DC01)** is positioned as the identity authority at the center of the architecture. Connected to the domain controller are identity-dependent systems including the **management workstation (MGMT01)**, **domain client workstation (CLIENT01)**, **Linux server (LINUX01)**, and the **hybrid synchronization server (ID-SYNC01)**.

The hybrid synchronization server extends identity services upward into the **Microsoft Entra ID cloud identity platform**, which then provides federated authentication to **Amazon Web Services** through SAML trust relationships.

Parallel to the identity infrastructure layer sits the **SIEM monitoring platform (SIEM01)** which receives authentication telemetry from all identity systems through Splunk forwarders.

The diagram visually demonstrates how identity authority, hybrid identity synchronization, federation, governance, monitoring, and detection systems operate together as a unified architecture.

---

# Final Architecture Validation

The integrated identity architecture was validated through the following operational checks:

• Active Directory authentication verified on DC01
• Domain systems successfully joined and authenticating
• Hybrid identity synchronization confirmed through Entra Connect
• AWS federated login validated through SAML role assumption
• RBAC governance groups enforcing role-based access
• Privileged access controls validated through PAM groups
• Splunk receiving authentication telemetry from all hosts
• Detection rules successfully generating alerts

These validations confirm the architecture functions as a **complete identity security system**.

---

# Lessons Learned and Known Limitations

As a simulated architecture, IAMPAM.LAB intentionally focuses on demonstrating identity security design concepts rather than replicating every element of a production enterprise environment.

Key lessons learned during the implementation include:

• The importance of identity authority as the foundational trust anchor for hybrid environments
• The operational benefits of synchronizing identity objects into cloud platforms rather than managing duplicate identity stores
• The security improvements provided by role-based governance and privilege separation
• The value of centralized monitoring for detecting suspicious authentication activity across multiple systems

Several limitations exist within the simulated environment:

• Infrastructure redundancy such as additional domain controllers and SIEM clustering were not implemented
• Disaster recovery capabilities were not modeled
• Identity lifecycle automation was simplified compared to enterprise identity governance platforms
• Cloud federation was demonstrated with a single provider rather than multiple SaaS integrations

**Future Phase Considerations**

If this environment were expanded into a second phase, future iterations would include **multi-provider federation (such as additional SaaS integrations), automated identity lifecycle management, and deeper identity governance automation** to more closely mirror enterprise identity governance platforms.

Despite these limitations, the environment accurately demonstrates the architectural principles used by enterprise organizations to design and secure identity infrastructure.

---

# Evidence & Screenshots

The following evidence demonstrates the operational architecture.

| Screenshot                               | Description                                  |
| ---------------------------------------- | -------------------------------------------- |
| module9_01_full_architecture_diagram.png | Final architecture diagram                   |
| module9_02_identity_flow.png             | Identity synchronization and federation flow |
| module9_03_federated_login.png           | AWS federated login validation               |
| module9_04_siem_visibility.png           | Splunk host telemetry visibility             |
| module9_05_detection_alert.png           | Triggered identity detection alert           |

All screenshots are stored under:

```
screenshots/module-09/
```

---

# Summary

Module 09 consolidates the IAMPAM.LAB environment into a fully documented enterprise identity security architecture.

The system demonstrates how modern organizations integrate:

• On-premises identity infrastructure
• Hybrid identity synchronization
• Federated cloud authentication
• Role-based governance
• Privileged access management
• Centralized identity monitoring
• Automated detection and alerting

Together these layers form a unified identity security control plane capable of managing authentication, enforcing access governance, monitoring identity activity, and detecting suspicious authentication behavior.

The completed environment models the identity architecture used by modern enterprise organizations and serves as the architectural capstone for the **HYBRID-IDENTITY-ACCESS-MGMT** repository.

---

**Built by:** Edward E. Spence
**Environment:** IAMPAM.LAB
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Module Status:** Complete

