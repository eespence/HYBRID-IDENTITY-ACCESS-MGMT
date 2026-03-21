← [Back to GRC README](./README.md)

![NIST](https://img.shields.io/badge/NIST_800--53-Mapped-blue?style=flat)
![CSF](https://img.shields.io/badge/NIST_CSF-Aligned-lightgrey?style=flat)
![ISO 27001](https://img.shields.io/badge/ISO_27001-Mapped-green?style=flat)
![SOC2](https://img.shields.io/badge/SOC_2-Controls-orange?style=flat)

---

# GRC Framework Mapping — Identity & Access Controls

**Author:** Edward E. Spence
**Lab:** IAMPAM.LAB
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Version:** 1.0
**Last Updated:** 2026-03-20

---

## Overview

This document maps implemented identity, access control, and monitoring capabilities within the **HYBRID-IDENTITY-ACCESS-MGMT** lab to established security frameworks.

All mappings are based on **actual implemented configurations and documented procedures** within this repository.

This document demonstrates how technical identity controls support:

* Governance requirements
* Risk reduction
* Compliance alignment

---

## Frameworks Referenced

* **NIST 800-53**
* **NIST Cybersecurity Framework (CSF)**
* **ISO/IEC 27001**
* **SOC 2 (Trust Services Criteria)**

---

## Control Mapping Matrix

| Control Domain      | Capability                      | NIST 800-53 | NIST CSF | ISO 27001 | SOC 2 | Implementation                   | Evidence             |
| ------------------- | ------------------------------- | ----------- | -------- | --------- | ----- | -------------------------------- | -------------------- |
| Identity Management | Centralized Identity (AD)       | AC-2        | PR.AC-1  | A.9.2     | CC6   | Active Directory Domain Services | ../modules/module-02 |
| Authentication      | Kerberos Authentication         | IA-2        | PR.AA-1  | A.9.4     | CC6   | Domain Authentication (DC01)     | ../modules/module-02 |
| Access Control      | RBAC (AD Groups)                | AC-2        | PR.AC-4  | A.9.1     | CC6   | Group-Based Access Control       | ../modules/module-05 |
| Least Privilege     | Tiered Admin Separation         | AC-6        | PR.AC-4  | A.9.2     | CC6   | Privileged vs Standard Accounts  | ../modules/module-06 |
| Privileged Access   | Controlled Admin Workstation    | AC-5        | PR.AC-5  | A.9.4     | CC6   | MGMT01 Access Restrictions       | ../modules/module-06 |
| Audit Logging       | Centralized Log Collection      | AU-2        | DE.CM-1  | A.12.4    | CC7   | Splunk Log Aggregation           | ../modules/module-07 |
| Monitoring          | Security Event Detection        | SI-4        | DE.CM-7  | A.12.4    | CC7   | SIEM Alerting (Splunk)           | ../runbooks/         |
| Incident Response   | Authentication Failure Recovery | IR-4        | RS.RP-1  | A.16.1    | CC7   | Runbook Procedures               | ../runbooks/         |
| Integrity           | Secure Channel Validation       | IA-3        | PR.AA-1  | A.9.4     | CC6   | Domain Trust Repair              | ../runbooks/         |

---

## Control Implementation Summary

### Identity and Authentication

Identity is centrally managed using Active Directory, with Kerberos providing authentication services across domain-joined systems.

These controls ensure:

* Verified identity of users and systems
* Consistent authentication enforcement
* Integrity of domain trust relationships

---

### Access Control and Least Privilege

Access is assigned using role-based access control (RBAC) through Active Directory group membership.

Least privilege is enforced through:

* Separation of standard and administrative accounts
* Tiered administrative access (PAM-aligned design)
* Restricted administrative login paths

These controls reduce the risk of unauthorized access and privilege escalation.

---

### Privileged Access Controls

Privileged access is restricted to designated systems and accounts.

Controls include:

* Dedicated administrative workstation (MGMT01)
* Controlled administrative access paths
* Segmentation between user and privileged sessions

> Full privileged access management (PAM) implementation is extended in the **IAM-PRIVILEGED-ACCESS-ENGINEERING** repository.

---

### Audit Logging and Monitoring

Security events are centrally collected and analyzed using Splunk.

This enables:

* Real-time monitoring of authentication activity
* Detection of abnormal behavior
* Audit trail generation for investigation and compliance

---

### Incident Response and Recovery

Documented runbooks provide structured procedures for detecting and resolving identity-related issues.

Example:

* Secure channel failure detection and repair

These controls ensure operational resilience and rapid recovery from authentication failures.

---

## Risk Alignment

The implemented controls reduce key enterprise risks:

| Risk                   | Mitigation                                     |
| ---------------------- | ---------------------------------------------- |
| Credential Theft       | Account separation and restricted admin access |
| Privilege Escalation   | RBAC and least privilege enforcement           |
| Lateral Movement       | Controlled administrative pathways             |
| Authentication Failure | Runbooks and validation procedures             |
| Lack of Visibility     | Centralized logging and monitoring             |

---

## Conclusion

This mapping demonstrates that the HYBRID-IDENTITY-ACCESS-MGMT lab is not only a functional identity environment, but also a security-aligned system that supports enterprise governance and compliance objectives.

The integration of identity, access control, and monitoring capabilities provides a foundation for:

* Secure system administration
* Privileged access control (via PAM extension)
* Audit readiness and compliance alignment

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**

