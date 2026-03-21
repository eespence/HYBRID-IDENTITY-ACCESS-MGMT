← [Back to Main README](../README.md)

![NIST](https://img.shields.io/badge/NIST_800--53-Compliant-blue?style=flat)
![ISO 27001](https://img.shields.io/badge/ISO_27001-Aligned-green?style=flat)
![SOC2](https://img.shields.io/badge/SOC_2-Controls-orange?style=flat)

---

# Governance, Risk, and Compliance (GRC)

**Author:** Edward E. Spence
**Lab:** IAMPAM.LAB
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Version:** 1.0
**Last Updated:** 2026-03-20

---

## Overview

This directory contains Governance, Risk, and Compliance (GRC) documentation for the **HYBRID-IDENTITY-ACCESS-MGMT** lab environment.

The purpose of this section is to demonstrate how implemented identity, access control, and monitoring capabilities align with industry-recognized security frameworks and reduce real-world enterprise risk.

All mappings in this section are directly tied to **implemented controls within this repository**.

---

## Scope of the Environment

The lab simulates a small enterprise identity environment consisting of:

* **Active Directory Domain Services (DC01)** — Centralized identity provider
* **Microsoft Entra Connect (ID-SYNC01)** — Hybrid identity synchronization
* **Administrative Workstation (MGMT01)** — Controlled privileged access point
* **User Workstation (CLIENT01)** — Standard user endpoint
* **Linux System (LINUX01)** — Cross-platform identity integration
* **SIEM Platform (Splunk)** — Logging, monitoring, and detection

---

## Framework Alignment

This environment is aligned to:

* **NIST 800-53**
* **NIST Cybersecurity Framework (CSF)**
* **ISO/IEC 27001**
* **SOC 2 (Trust Services Criteria)**

Detailed mappings are provided in:

➡️ [`grc-framework-mapping.md`](./grc-framework-mapping.md)

---

## Control Mapping Summary

| Control           | Framework | Implementation                   | Evidence             |
| ----------------- | --------- | -------------------------------- | -------------------- |
| Access Control    | NIST AC-2 | AD RBAC Groups                   | ../modules/module-05 |
| Least Privilege   | NIST AC-6 | Tiered Administrative Separation | ../modules/module-06 |
| Authentication    | NIST IA-2 | Kerberos / Active Directory      | ../modules/module-02 |
| Audit Logging     | NIST AU-2 | Splunk Logging                   | ../modules/module-07 |
| Monitoring        | NIST SI-4 | SIEM Alerting (Splunk)           | ../runbooks/         |
| Incident Response | NIST IR-4 | Recovery Runbooks                | ../runbooks/         |

---

## Control Domains Implemented

### Identity and Authentication

* Centralized identity via Active Directory
* Kerberos-based authentication
* Domain trust validation and recovery

**Evidence:**

* `modules/`
* `runbooks/`

---

### Access Control and Least Privilege

* Role-based access control (RBAC)
* Separation of administrative and standard accounts
* Tiered administrative separation (PAM-aligned design)
* Controlled administrative access via MGMT01

**Evidence:**

* `modules/`
* `architecture/`

---

### Privileged Access (PAM Foundations)

* Dedicated administrative workstation (MGMT01)
* Restricted administrative pathways
* Segregation of privileged and non-privileged sessions

> Full PAM implementation is extended in the **IAM-PRIVILEGED-ACCESS-ENGINEERING** repository.

---

### Audit Logging and Monitoring

* Centralized log aggregation using Splunk
* Event monitoring and alerting
* Authentication and system activity visibility

**Evidence:**

* `modules/`
* `runbooks/`
* `screenshots/`

---

### Incident Response Support

* Documented recovery and troubleshooting runbooks
* Authentication failure remediation procedures

**Evidence:**

* `runbooks/`

---

## Risk Reduction Summary

This environment reduces the risk of:

* Credential theft
* Privilege escalation
* Lateral movement
* Authentication failure impact
* Undetected malicious activity

---

## Relationship to PAM Engineering Repository

This repository provides the **identity foundation layer**.

The companion repository:

**IAM-PRIVILEGED-ACCESS-ENGINEERING**

extends this environment by implementing:

* Tiered administrative model
* Privileged access controls
* Enhanced boundary enforcement

Together:

* Identity → Access Management
* PAM → Privileged Control
* SIEM → Monitoring & Detection

---

## Conclusion

This lab demonstrates how identity infrastructure can be engineered with controls aligned to enterprise security frameworks.

It bridges:

* Identity Administration
* Security Engineering
* Governance, Risk, and Compliance (GRC)

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
