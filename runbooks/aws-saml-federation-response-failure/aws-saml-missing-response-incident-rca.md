← [Back to Main README](../../README.md)

---

![Microsoft Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat\&logo=microsoftazure\&logoColor=white)
![AWS](https://img.shields.io/badge/AWS_IAM-FF9900?style=flat\&logo=amazonaws\&logoColor=white)
![SAML](https://img.shields.io/badge/SAML_2.0-Federation-orange?style=flat)

---

# AWS SAML Federation Incident — Missing SAML Response

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Document Type:** IAM Operations Runbook
**Last Reviewed:** March 2026

---

## Runbook Metadata

| Field      | Value                    |
| ---------- | ------------------------ |
| Runbook ID | FED-OPS-INC-001          |
| Service    | SAML Federation          |
| Severity   | SEV-2 Federation Failure |
| Status     | Resolved                 |

---

## Incident Overview

**Incident Title:** AWS SAML Federation Authentication Failure
**System:** Microsoft Entra ID ↔ AWS IAM Federation
**Error:** "Your request did not include a SAML response."
**Incident Type:** Identity Federation Failure
**Environment:** IAMPAM.LAB
**Systems:** DC01, ID-SYNC01, Microsoft Entra ID, AWS IAM

---

# Incident Summary

During implementation of SAML federation between **Microsoft Entra ID** and **AWS**, authentication failed when accessing the AWS console via the **MyApps portal**.

> **Your request did not include a SAML response**

---

# Architecture Context

```text
Active Directory
        ↓
Microsoft Entra ID
        ↓
SAML Federation
        ↓
AWS IAM Identity Provider
        ↓
AWS STS
        ↓
AWS Console
```

---

# Root Cause

Misconfigured **Sign-on URL** forced SP-initiated flow:

```text
https://signin.aws.amazon.com/saml
```

Result:

* Entra redirected instead of POSTing SAML assertion
* AWS never received assertion

---

# Remediation

Removed Sign-on URL:

```text
Entra Admin Center → Enterprise Apps → AWS-Federation → SSO → Edit
```

---

# Why This Fixed It

Now using **IdP-initiated flow**:

1. Entra generates assertion
2. POSTs to AWS
3. AWS validates + issues credentials

---

# Validation

Successful login with role:

```text
EntraID-Federated-Admin
```

---

# Evidence

### SAML Configuration Applied

![SAML Configuration](../../screenshots/module-04/module4_03_saml_configuration_applied.png)

### AWS Federated Console Login Success

![AWS Login Success](../../screenshots/module-04/module4_09_aws_federated_console_login_success.png)

### AWS Role Trust Policy

![AWS Trust Policy](../../screenshots/module-04/module4_10_aws_role_trust_policy_saml_federation.png)

### Entra SAML Claim Mapping

![SAML Claims](../../screenshots/module-04/module4_11_entra_saml_claim_mapping_aws_role.png)

---

# Lessons Learned

* Leave Sign-on URL blank for AWS
* Use IdP-initiated flow
* SAML must POST assertion

---

# Final State

* Entra = IdP
* AWS = SP
* Federation working
* No IAM users required

---

**E.E. Spence — Identity Engineering | IAMPAM.LAB**
