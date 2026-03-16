# Module 09 — Identity Security Architecture

## Overview

Module 09 represents the final architectural consolidation of the **IAMPAM.LAB identity security environment**.

While previous modules implemented individual capabilities—such as Active Directory identity authority, hybrid identity synchronization, federation, governance, privileged access management, monitoring, and automation—this module presents the **complete identity security architecture as a unified system**.

The purpose of this module is to demonstrate how modern enterprise organizations design layered identity security environments that integrate on-premises infrastructure, cloud identity providers, privileged access management, and centralized monitoring.

This module therefore focuses on **architecture and system relationships**, rather than step-by-step configuration.

---

## Architecture Objective

Modern organizations rely on identity systems as the **primary security control plane**.

Every authentication request, privileged operation, or cloud access request ultimately depends on the identity infrastructure that governs authentication and authorization.

The architecture implemented in **IAMPAM.LAB** demonstrates how multiple identity security layers work together to provide:

• centralized identity authority
• hybrid identity synchronization
• federated cloud authentication
• governance and privileged access control
• centralized authentication monitoring
• automated detection of identity security anomalies

These capabilities reflect the same layered identity security model commonly deployed in enterprise environments.

---

## Identity Security Architecture Diagram

![IAMPAM Architecture](../screenshots/module-09/module9_01_full_architecture_diagram.png)

The diagram above illustrates the complete identity security architecture built throughout this lab.

The environment is structured around a **segmented privileged identity network (172.31.100.0/24)** where identity authority, synchronization services, administrative workstations, and monitoring infrastructure operate together.

Above this network sits the **cloud identity and federation layer**, where Microsoft Entra ID provides cloud identity services and federates authentication to AWS through SAML trust relationships.

Below the identity systems sits the **infrastructure layer**, where Proxmox provides the virtualization platform supporting the entire lab environment.

Each layer of the architecture builds upon the capabilities of the previous layer.

---

## Identity Authority Layer

At the core of the architecture is the **Active Directory domain controller (DC01)**.

Active Directory serves as the **authoritative identity provider** for the environment, responsible for:

• authenticating domain users
• managing identity objects and group membership
• enforcing domain authentication policies
• providing Kerberos ticketing services

Because Active Directory remains the identity authority, all other identity services—including hybrid identity synchronization and federation—ultimately depend on this system.

This reflects real enterprise environments where on-premises identity directories remain the **primary source of identity truth**.

---

## Hybrid Identity Layer

The **ID-SYNC01 server** runs Microsoft Entra Connect and enables hybrid identity synchronization between the on-premises Active Directory environment and Microsoft Entra ID.

This synchronization process allows user identities and group memberships to be replicated securely to the cloud identity provider.

Hybrid identity enables organizations to maintain **a single identity source while extending authentication capabilities to cloud services**.

This architecture ensures that:

• on-premises identity authority remains intact
• cloud authentication services remain synchronized
• identity governance remains consistent across environments

Hybrid identity therefore serves as the **bridge between enterprise identity infrastructure and modern cloud identity platforms**.

---

## Federation Layer

Once hybrid identity synchronization is established, the environment supports **federated authentication between Microsoft Entra ID and AWS**.

In this model, Microsoft Entra ID functions as the **identity provider**, while AWS trusts Entra through a configured SAML federation relationship.

When a user requests access to AWS resources:

1. The user authenticates using enterprise identity credentials.
2. Microsoft Entra ID validates the identity.
3. AWS accepts the SAML assertion and grants access according to mapped roles.

This design allows organizations to enforce **centralized identity control across multiple cloud platforms**.

Federation eliminates the need for separate credential stores and reduces the risk associated with credential sprawl.

---

## Governance and Privileged Access Management

Identity governance and privileged access management are implemented through a set of administrative systems inside the privileged network.

Key systems include:

• **MGMT01** — administrative workstation used for identity management
• **CLIENT01** — domain workstation representing standard enterprise endpoints
• **LINUX01** — Linux server configured for privileged administrative access
• **PAM01** — privileged access management platform for secure administrative credential storage

This layer ensures that privileged operations are controlled, audited, and protected from misuse.

Privileged access management platforms reduce the risk of credential theft by ensuring that high-privilege accounts are **secured within centralized secrets vaults** and accessed only through authorized workflows.

This architectural layer reflects common enterprise PAM implementations used to protect administrative accounts.

---

## Monitoring and Detection Layer

The monitoring layer is implemented using **Splunk Enterprise (SIEM01)**.

Splunk receives authentication telemetry and security logs from multiple systems in the identity environment through **Splunk Universal Forwarders**.

Authentication telemetry includes events such as:

• Windows authentication attempts
• account lockouts
• failed login attempts
• privilege escalation activity
• administrative operations

These events are indexed and analyzed in Splunk to detect suspicious identity activity.

By centralizing authentication telemetry, the architecture enables security teams to detect identity-related attacks such as:

• brute-force login attempts
• credential misuse
• privilege escalation behavior

Centralized monitoring ensures that identity systems do not operate in isolation but instead feed into a **central security analytics platform**.

---

## Automation and Security Detection

Beyond simple log collection, the environment also demonstrates automated identity security detection.

Splunk searches can be configured to identify suspicious authentication patterns, including repeated login failures.

These automated detections represent the early stages of **identity security automation**, where SIEM platforms continuously evaluate identity telemetry and generate alerts when suspicious behavior is detected.

This capability allows security teams to respond to identity-based threats before they escalate into larger security incidents.

---

## Infrastructure Layer

All systems in the IAMPAM.LAB environment operate on a **Proxmox virtualization platform**.

Proxmox provides the infrastructure layer responsible for:

• hosting the virtual machines used in the environment
• managing virtual networking
• providing isolated network segments for identity systems

The lab uses a dedicated **privileged identity network (172.31.100.0/24)** to isolate identity infrastructure from other environments.

Network segmentation is a critical security design principle because it prevents unauthorized systems from directly interacting with identity services.

In a production enterprise environment, this architecture would include disaster recovery and high availability considerations such as a secondary domain controller, SIEM redundancy, and documented recovery time objectives. These components were intentionally excluded from this simulation as the focus of IAMPAM.LAB is identity security architecture rather than infrastructure resilience.

---

## Lessons Learned

Building a layered identity security architecture highlights the importance of understanding how multiple identity systems interact within an enterprise environment.

Key lessons from this lab include:

• identity infrastructure should remain the authoritative source of authentication
• hybrid identity synchronization must maintain consistent identity state between environments
• federated authentication simplifies cloud access management
• privileged access management protects critical administrative credentials
• centralized monitoring provides visibility into authentication activity across systems

While the lab demonstrates a foundational identity security architecture, future iterations could extend this environment with **additional federation providers and more advanced automated identity lifecycle management capabilities**.

---

## Conclusion

Module 09 concludes the **IAMPAM.LAB identity security project** by presenting the complete architecture that integrates identity authority, hybrid identity, federation, governance, privileged access management, monitoring, and automation.

Together, these layers form a realistic identity security architecture that reflects how modern organizations secure authentication infrastructure across both on-premises and cloud environments.

Rather than functioning as isolated technologies, each system in the architecture contributes to a unified identity security platform designed to protect access to enterprise resources.

