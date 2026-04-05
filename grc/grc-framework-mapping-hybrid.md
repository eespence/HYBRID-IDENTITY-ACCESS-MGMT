← [Back to GRC README](./README.md)

![NIST](https://img.shields.io/badge/NIST_800--53-Mapped-blue?style=flat)
![CSF](https://img.shields.io/badge/NIST_CSF-Aligned-lightgrey?style=flat)
![ISO 27001](https://img.shields.io/badge/ISO_27001-Mapped-green?style=flat)
![SOC2](https://img.shields.io/badge/SOC_2-Controls-orange?style=flat)

---

# GRC Framework Mapping — Hybrid Identity & Access Controls

**Author:** Edward E. Spence
**Lab:** IAMPAM.LAB
**Repository:** HYBRID-IDENTITY-ACCESS-MGMT
**Version:** 1.1
**Last Updated:** 2026-04-03

---

## Overview

This document maps implemented identity, access control, and monitoring capabilities within the **HYBRID-IDENTITY-ACCESS-MGMT** lab to established security frameworks.

All mappings are based on **actual implemented configurations and documented procedures** within this repository.

---

## Environment in Scope

**Network:** 172.31.100.0/24

| System    | Role                            | IP            |
| --------- | ------------------------------- | ------------- |
| DC01      | Domain Controller               | 172.31.100.10 |
| MGMT01    | Administrative Workstation      | 172.31.100.20 |
| CLIENT01  | Standard User Workstation       | 172.31.100.30 |
| LINUX01   | Privileged Linux Server         | 172.31.100.40 |
| ID-SYNC01 | Entra Connect / Identity Sync   | 172.31.100.25 |
| SIEM01    | Splunk Enterprise 9.2           | 172.31.100.60 |

---

## Frameworks Referenced

* NIST SP 800-53 Rev 5
* NIST Cybersecurity Framework (CSF) 2.0
* ISO/IEC 27001:2022
* SOC 2 Trust Services Criteria

---

## Control Mapping Matrix

| Control Domain         | Capability                          | NIST 800-53 | NIST CSF   | ISO 27001 | SOC 2 | Implementation                              | Evidence             |
| ---------------------- | ----------------------------------- | ----------- | ---------- | --------- | ----- | ------------------------------------------- | -------------------- |
| Identity Management    | Centralized Identity (AD)           | AC-2        | PR.AA-1    | A.9.2     | CC6.1 | Active Directory Domain Services            | modules/module-02    |
| Authentication         | Kerberos Authentication             | IA-2        | PR.AA-1    | A.9.4     | CC6.1 | Domain Authentication via DC01              | modules/module-02    |
| Hybrid Identity        | Entra ID Synchronization            | IA-2, IA-8  | PR.AA-1    | A.9.2     | CC6.1 | Entra Connect (ID-SYNC01)                   | modules/module-03    |
| Federation             | AWS SAML Federation                 | IA-8        | PR.AA-2    | A.9.4     | CC6.1 | SAML-based federated access                 | modules/module-04    |
| Access Control         | RBAC via AD Groups                  | AC-2, AC-3  | PR.AC-4    | A.9.1     | CC6.3 | Group-based access control                  | modules/module-05    |
| Least Privilege        | Tiered Admin Separation             | AC-6        | PR.AC-4    | A.9.2     | CC6.3 | Privileged vs standard account separation   | modules/module-06    |
| Privileged Access      | Controlled Admin Workstation        | AC-5        | PR.AC-5    | A.9.4     | CC6.3 | MGMT01 as administrative entry point        | modules/module-06    |
| Audit Logging          | Centralized Log Collection          | AU-2, AU-3  | DE.CM-1    | A.12.4    | CC7.2 | Splunk log aggregation                      | modules/module-07    |
| Monitoring             | Security Event Detection            | SI-4        | DE.CM-7    | A.12.4    | CC7.2 | SIEM alerting via Splunk                    | modules/module-07    |
| Automation             | Alert-Driven Policy Enforcement     | SI-4, IR-4  | DE.AE-5    | A.16.1    | CC7.3 | Identity automation workflows               | modules/module-08    |
| Incident Response      | Authentication Failure Recovery     | IR-4, IR-5  | RS.RP-1    | A.16.1    | CC7.3 | Documented runbook procedures               | runbooks/            |
| System Integrity       | Secure Channel Validation           | IA-3, SC-8  | PR.DS-2    | A.9.4     | CC6.1 | Domain trust repair and NTP enforcement     | runbooks/            |
| Time Synchronization   | NTP Hierarchy Enforcement           | AU-8        | PR.PT-1    | A.12.4    | CC7.1 | External NTP → MGMT01 → DC01 → Members     | modules/module-01    |
| Configuration Mgmt     | Baseline System Configuration       | CM-2, CM-6  | PR.IP-1    | A.12.1    | CC7.1 | Infrastructure baseline documentation       | modules/module-01    |

---

## Attack Surface Awareness and Control Mapping

The following known IAM attack vectors are addressed by controls implemented in this repository.

| Attack Technique    | MITRE Technique | Description                                                                 | Control Implemented                                      | Evidence          |
| ------------------- | --------------- | --------------------------------------------------------------------------- | -------------------------------------------------------- | ----------------- |
| Kerberoasting       | T1558.003       | Requesting service tickets for SPN accounts and cracking offline            | Strong service account passwords + RBAC enforcement      | modules/module-02 |
| AS-REP Roasting     | T1558.004       | Targeting accounts with Kerberos pre-auth disabled                          | Pre-authentication enforced via AD policy                | modules/module-02 |
| Pass-the-Hash       | T1550.002       | Reusing NTLM hashes without cracking credentials                            | MGMT01 PAW model prevents hash exposure on CLIENT01      | modules/module-06 |
| Pass-the-Ticket     | T1550.003       | Stealing and reusing Kerberos tickets from memory                           | Tiered admin model limits ticket exposure                | modules/module-06 |
| DCSync              | T1003.006       | Simulating a domain controller to pull password hashes                      | DC01 replication rights restricted to domain controllers | modules/module-02 |
| Golden Ticket       | T1558.001       | Forging Kerberos tickets using KRBTGT hash for persistent access            | DC01 Tier 0 isolation + MGMT01-only admin access         | modules/module-06 |
| LSASS Dumping       | T1003.001       | Extracting credentials from LSASS memory on compromised endpoints           | CLIENT01 has no privileged credentials to extract        | modules/module-06 |
| Lateral Movement    | T1021           | Using valid credentials to pivot from CLIENT01 to privileged systems        | MGMT01 enforcement + AD logon restrictions               | modules/module-06 |
| Valid Account Abuse | T1078           | Using legitimate credentials outside approved access paths                  | RBAC + tiered admin model + logon restrictions           | modules/module-05 |

---

## Control Implementation Summary

### Identity and Authentication

Identity is centrally managed through Active Directory with Kerberos providing authentication across all domain-joined systems. Hybrid identity is extended to Microsoft Entra ID via ID-SYNC01, and federated access to AWS is implemented using SAML. These controls ensure verified identity, consistent authentication enforcement, and domain trust integrity.

**Modules:** 02, 03, 04

---

### Access Control and Least Privilege

Access is assigned through role-based access control using Active Directory group membership. Least privilege is enforced through separation of standard and administrative accounts, tiered administrative access aligned with PAM design principles, and restricted administrative login paths originating exclusively from MGMT01.

**Modules:** 05, 06

---

### Audit Logging and Monitoring

Security events are centrally collected and analyzed using Splunk Enterprise. This enables real-time monitoring of authentication activity, detection of anomalous behavior, and audit trail generation for compliance and investigation purposes.

**Modules:** 07, 08

---

### Incident Response and Recovery

Documented runbooks provide structured procedures for detecting and resolving identity-related issues including Kerberos authentication failures, secure channel breaks, and Entra synchronization failures. These controls ensure operational resilience and support rapid recovery from authentication disruptions.

**Runbooks:** runbooks/

---

## Risk Reduction Summary

| Risk                        | Mitigation                                              |
| --------------------------- | ------------------------------------------------------- |
| Credential Theft            | PAW model + no credential exposure on CLIENT01          |
| Privilege Escalation        | RBAC + tiered admin separation                          |
| Lateral Movement            | MGMT01-only admin paths + AD logon restrictions         |
| Authentication Failure      | Runbooks + NTP enforcement + secure channel repair      |
| Kerberoasting               | Strong service account controls + RBAC                  |
| Golden Ticket               | DC01 Tier 0 isolation + MGMT01 enforcement              |
| Undetected Malicious Activity | Centralized logging + SIEM alerting                   |
| Hybrid Identity Gaps        | Entra Connect + UPN suffix alignment                    |

---

## Cross-Module Evidence Reference

| Module    | Control Area                          |
| --------- | ------------------------------------- |
| Module 01 | Infrastructure baseline               |
| Module 02 | Active Directory + Kerberos           |
| Module 03 | Hybrid identity + Entra sync          |
| Module 04 | AWS SAML federation                   |
| Module 05 | Identity governance + RBAC            |
| Module 06 | Privileged access + MGMT01 enforcement|
| Module 07 | Logging + monitoring + detection      |
| Module 08 | Automation + policy enforcement       |
| Module 09 | Architecture documentation            |

---

## Conclusion

This mapping demonstrates that the HYBRID-IDENTITY-ACCESS-MGMT lab is not only a functional identity environment but a security-aligned system that addresses known IAM attack surfaces and supports enterprise governance and compliance objectives. The integration of identity, access control, monitoring, and incident response provides a foundation for secure system administration aligned with NIST 800-53, NIST CSF, ISO 27001, and SOC 2.

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
