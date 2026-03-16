# AWS SAML Federation Incident — Missing SAML Response

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Document Type:** IAM Operations Runbook
**Last Reviewed:** March 2026

---

**Incident Title:** AWS SAML Federation Authentication Failure
**System:** Microsoft Entra ID ↔ AWS IAM Federation
**Error:** "Your request did not include a SAML response."
**Incident Type:** Identity Federation Failure
**Status:** Resolved
**Environment:** IAMPAM.LAB
**Systems:** DC01, ID-SYNC01, Microsoft Entra ID, AWS IAM
**Platform:** Proxmox VE + Microsoft Entra ID + AWS

---

# Incident Summary

During implementation of SAML federation between **Microsoft Entra ID** and **Amazon Web Services (AWS)**, authentication failed when attempting to access the AWS console through the **MyApps portal**.

Instead of authenticating successfully, AWS returned the following error page:

> **Your request did not include a SAML response**

This prevented users from accessing AWS resources through federated identity authentication.

---

# Architecture Context

The federation architecture for this module was designed as follows:

```
Active Directory
        ↓
Microsoft Entra ID (Hybrid Identity)
        ↓
SAML Federation
        ↓
AWS IAM Identity Provider
        ↓
AWS STS AssumeRoleWithSAML
        ↓
AWS Console Access
```

Authentication should occur entirely through **Microsoft Entra ID**, eliminating the need for locally managed AWS IAM users.

---

# Symptoms Observed

When the **AWS-Federation** application was launched from the Entra **MyApps portal**, the AWS login page displayed:

```
Amazon Web Services Sign In
Your request did not include a SAML response
```

The failure occurred immediately after selecting the AWS application.

No AWS credentials were requested because the SAML assertion was never received.

---

# Initial Investigation

Multiple potential causes were evaluated:

• AWS IAM SAML Identity Provider configuration
• AWS IAM federated role trust policy
• SAML metadata exchange
• Attribute and claim mapping
• User assignment within Microsoft Entra ID

All components were verified to be configured correctly.

---

# Root Cause

The issue was caused by a **misconfigured Sign-on URL field in the Microsoft Entra SAML configuration**.

The following value had been populated:

```
https://signin.aws.amazon.com/saml
```

This forced Microsoft Entra ID to treat the application as **Service Provider Initiated (SP-initiated) SSO**.

Under this configuration, Entra attempted to redirect authentication rather than **POSTing a SAML assertion to AWS**.

Because AWS never received the SAML assertion, it returned the error indicating that the SAML response was missing.

---

# Remediation

The issue was resolved by removing the **Sign-on URL** value from the SAML configuration.

Navigation path:

```
Microsoft Entra Admin Center
Enterprise Applications
AWS-Federation
Single Sign-On
Basic SAML Configuration
Edit
```

The **Sign-on URL field was cleared completely** and the configuration was saved.

---

# Why This Resolved the Issue

When the **Sign-on URL field is empty**, Microsoft Entra treats the application as **Identity Provider Initiated (IdP-initiated) SSO**.

This allows the MyApps portal to:

1. Generate a SAML assertion
2. POST the assertion directly to the AWS Assertion Consumer Service
3. Allow AWS to validate the identity and issue temporary credentials

This is the correct behavior for AWS console federation through the MyApps portal.

---

# Validation

After the configuration was corrected:

• Microsoft Entra successfully generated a SAML assertion
• AWS IAM accepted the federated authentication
• AWS STS issued temporary role credentials
• The AWS console loaded under the federated role

Authenticated role:

```
EntraID-Federated-Admin
```

The AWS console confirmed successful role assumption.

---

# Evidence

Federation configuration and validation screenshots are available in the module documentation.

Refer to:

```
screenshots/module-04/
```

Key evidence files include:

```
module4_03_saml_configuration_applied.png
module4_09_aws_federated_console_login_success.png
module4_10_aws_role_trust_policy_saml_federation.png
module4_11_entra_saml_claim_mapping_aws_role.png
```

---

# Lessons Learned

This incident highlights an important behavior in **SAML federation architecture**.

Incorrect IdP configuration can prevent assertion delivery even when all identity provider and service provider trust relationships are valid.

When implementing SAML federation with AWS:

• The **Sign-on URL field should remain blank**
• Authentication should occur through **IdP-initiated login via the MyApps portal**
• AWS expects a **POSTed SAML assertion** to the Assertion Consumer Service endpoint

---

# Final State

After remediation:

• Microsoft Entra ID functions as a trusted SAML Identity Provider
• AWS IAM accepts federated authentication from Entra
• Users authenticate using centralized identity
• AWS roles are assumed using STS temporary credentials
• AWS IAM users are no longer required

The federation architecture is now fully operational and validated.
