# 🎯 Enterprise Identity Security Lab (IAM / PAM)

9-module enterprise identity lab covering Active Directory, Microsoft Entra ID, AWS SAML, PAM, and Splunk.
Built under real failure conditions — authentication broke, was diagnosed, and repaired.
Each module is validated with screenshots and operational evidence.

---

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat\&logo=microsoft\&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat\&logo=microsoftazure\&logoColor=white)
![AWS SAML](https://img.shields.io/badge/AWS_SAML-FF9900?style=flat\&logo=amazonaws\&logoColor=white)
![Splunk](https://img.shields.io/badge/Splunk-000000?style=flat\&logo=splunk\&logoColor=white)

---

## 🧠 Overview

This repository documents a simulated enterprise identity environment built to understand how authentication, authorization, and privileged access behave in a real-world setting.

This is not just a setup lab.

During this build, authentication failed, identity synchronization broke, and access control had to be diagnosed and repaired — mirroring real IAM/PAM engineering work.

---

## 🏗️ Architecture (High-Level)

```mermaid
graph LR
    AD[Active Directory] --> Entra[Microsoft Entra ID]
    Entra --> AWS[AWS SAML Federation]
    AD --> PAM[Privileged Access Mgmt]
    AD --> Splunk[Splunk Monitoring]
```

---

## 🔍 What This Lab Demonstrates

• Active Directory (Kerberos, secure channel repair, domain trust)
• Microsoft Entra ID (hybrid identity synchronization)
• AWS SAML federation (centralized identity access)
• Privileged Access Management (role isolation, admin control)
• Identity governance (RBAC, lifecycle, separation of duties)
• Splunk monitoring (authentication + privilege activity)
• Identity automation and detection workflows

---

## 🏢 Simulated Organization

**Organization:** Fairmont Manufacturing (fictional)
**Primary Identity:** Jane Doe — Finance Department

---

## 🔥 Key Engineering Incidents

### 1. Kerberos Authentication Failure

* Domain trust broke due to time desynchronization
* Root cause: Domain Controller using local CMOS clock

**Fix implemented:**

```
External NTP → MGMT01 → DC01 → Domain Members
```

**Result:**
Authentication restored, secure channel repaired, domain stabilized

---

### 2. Entra Connect Authentication Failure

**Error:** "Unsupported Browser"

**Root Cause:**
Non-routable domain (`IAMPAM.LAB`) incompatible with Entra authentication

**Fix:**

* Added routable UPN suffix
* Updated identity configuration
* Re-ran synchronization

**Result:**
Hybrid identity successfully synchronized and validated

---

## 📸 Validation Example

![Entra Sync Validation](screenshots/module-03/Entra-AdminUser-OnPremSync-Verified.png)
---

## 📚 Lab Modules

* [Module 01 — Infrastructure & Network](modules/module-01.md)
* [Module 02 — Active Directory Core](modules/module-02.md)
* [Module 03 — Hybrid Identity](modules/module-03.md)
* [Module 04 — AWS Federation](modules/module-04.md)
* [Module 05 — Identity Governance](modules/module-05.md)
* [Module 06 — Privileged Access Management](modules/module-06.md)
* [Module 07 — Logging & Monitoring (Splunk)](modules/module-07.md)
* [Module 08 — Automation & Detection](modules/module-08.md)
* [Module 09 — Identity Security Architecture](modules/module-09.md)

---

## 📁 Evidence Structure

Each module includes validation artifacts:

* screenshots/baseline/
* screenshots/connectivity/
* screenshots/module-02/
* screenshots/module-03/
* screenshots/module-04/
* screenshots/module-05/
* screenshots/module-06/
* screenshots/module-07/
* screenshots/module-08/
* screenshots/module-09/

---

## 🧾 Maintained By

**Edward E. Spence**
IAM / PAM Engineering | Identity Security

[LinkedIn](https://linkedin.com/in/edward-e-spence-6598bb312)
[Portfolio](https://edwards-it-portfolio.com)

---

## 📌 About

Enterprise identity lab demonstrating:

Active Directory, Microsoft Entra ID, AWS federation, RBAC governance, Privileged Access Management, and Splunk-based monitoring.

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**


