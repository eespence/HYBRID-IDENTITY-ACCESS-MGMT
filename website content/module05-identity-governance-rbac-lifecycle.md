# Identity Governance — RBAC & Lifecycle Management

## Overview

Identity governance ensures that access to systems and applications is controlled, auditable, and aligned with organizational security policy.

Within this hybrid identity lab, governance controls were implemented across both **Active Directory** and **Microsoft Entra ID** to model how enterprises manage identity lifecycle and access permissions.

This phase of the project introduces structured **Role-Based Access Control (RBAC)**, lifecycle management, and separation-of-duties enforcement.

---

## Governance Architecture

The identity governance model is built on three core concepts:

**Role-Based Access Control (RBAC)**
Access is assigned through security groups rather than individual permissions.

**Identity Lifecycle Management**
User identities follow a predictable lifecycle:

Joiner → Mover → Leaver

**Hybrid Identity Synchronization**
Governed identities are synchronized from on-premises Active Directory into Microsoft Entra ID using Entra Connect.

This ensures governance policies apply consistently across both environments.

---

## RBAC Security Model

Enterprise roles were modeled using Active Directory security groups.

Examples include:

• ENG-Users
• SEC-Analysts
• IT-Admins
• FIN-Approvers
• FIN-Auditors

These groups represent enterprise access roles rather than individual users.

Assigning users to groups allows administrators to manage permissions centrally and reduces configuration errors.

---

## Identity Lifecycle Management

To demonstrate governance processes, a test identity (**John Engineer**) was created and moved through a full lifecycle scenario.

### Joiner

A new identity is created and assigned to the appropriate role group.

This models a new employee onboarding process.

### Mover

The identity’s role changes, requiring reassignment to a different RBAC group.

This simulates department transfers or job responsibility changes.

### Leaver

The identity is disabled when the user leaves the organization.

Disabling the account ensures access is immediately revoked while preserving the identity record for auditing.

---

## Hybrid Identity Governance

All governed identities are synchronized to **Microsoft Entra ID** through Entra Connect.

Synchronization is intentionally restricted using a dedicated scope group:

AAD-Sync-Users

Only identities placed in this group are allowed to synchronize to the cloud directory. This prevents accidental exposure of service accounts, administrative accounts, or internal infrastructure identities.

This pattern reflects a common enterprise governance safeguard used in hybrid identity environments.

---

## Separation of Duties

To reduce the risk of privilege abuse or fraud, governance policies enforce separation-of-duties controls.

For example:

• Finance Approvers cannot also be Finance Auditors
• IT administrators cannot approve financial transactions

These controls help ensure sensitive roles remain isolated and auditable.

---

## Governance Validation

Operational validation was performed through multiple governance scenarios:

• RBAC role assignment verification
• Hybrid identity synchronization checks
• Lifecycle event simulation (Joiner / Mover / Leaver)
• Privileged role membership review

Screenshots captured during execution confirm that governance controls operate correctly across both Active Directory and Microsoft Entra ID.

---

## Why Identity Governance Matters

Identity systems act as the **control plane for access to every application and system in an organization**.

Without governance:

• access permissions become inconsistent
• privileges accumulate over time
• sensitive roles expand unnoticed
• auditing becomes difficult

Strong governance ensures identities remain controlled, traceable, and aligned with organizational security policy.

---

## Next Phase

With identity governance implemented, the identity architecture is prepared for the next stage:

**Privileged Access Management (PAM)**

PAM introduces additional protections around administrative identities, privileged roles, and sensitive system access.

---

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Module:** 05 —  Identity Governance — RBAC & Lifecycle Management
**Document Type:** Implementation & Operations Article
**Last Reviewed:** March 2026

