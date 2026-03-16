# Federated Identity — Enabling Single Sign-On Between Microsoft Entra ID and AWS

---

## Why This Project Exists

Once hybrid identity is deployed, identities exist in two places:

• on-premises Active Directory
• Microsoft Entra ID

At this stage the environment supports **synchronized identity**, but users still cannot access external platforms such as cloud infrastructure.

In real enterprise environments, organizations do not create separate accounts inside every system.
That approach leads to:

• credential sprawl
• inconsistent access control
• delayed account deprovisioning
• security risk

Instead, organizations rely on **federated identity**.

Federation allows external platforms to trust an enterprise identity provider for authentication.

This module implemented a federation trust relationship between:

• **Microsoft Entra ID** (Identity Provider)
• **AWS IAM** (Service Provider)

The goal was to allow users authenticated through Entra ID to access AWS infrastructure **without creating AWS-native user accounts**.

---

# Environment

This module extended the hybrid identity environment deployed in Module 03.

### Identity Authority Chain

```
Active Directory
        ↓
Microsoft Entra Connect
        ↓
Microsoft Entra ID
        ↓
Federation (SAML)
        ↓
AWS IAM
```

### Systems Involved

| System    | Role                                              |
| --------- | ------------------------------------------------- |
| DC01      | Active Directory Domain Controller                |
| MGMT01    | Administrative workstation                        |
| ID-SYNC01 | Microsoft Entra Connect synchronization server    |
| CLIENT01  | Domain workstation used for federation validation |

AWS was integrated as an external identity-consuming platform.

---

# The Design Problem

Without federation, cloud access requires one of two approaches.

### Option 1

Create individual AWS IAM users.

Problems introduced:

• separate password management
• no centralized authentication
• slow account revocation
• duplicated identities

### Option 2

Use an enterprise identity provider.

Benefits introduced:

• centralized authentication
• MFA enforcement
• automatic access revocation
• unified identity lifecycle

The design objective for this module was:

> AWS must trust Microsoft Entra ID for authentication.

Users authenticate once to Entra ID and receive access to AWS resources based on their assigned role.

---

# Federation Model

Federation in this environment is based on **Security Assertion Markup Language (SAML)**.

SAML allows one system to authenticate a user and send a signed authentication statement to another system.

In this architecture:

| Role                     | System             |
| ------------------------ | ------------------ |
| Identity Provider        | Microsoft Entra ID |
| Service Provider         | AWS IAM            |
| Authentication Authority | Active Directory   |

The authentication flow becomes:

```
User login
      ↓
Microsoft Entra ID authentication
      ↓
SAML assertion issued
      ↓
AWS validates assertion
      ↓
AWS grants role session
```

AWS does not store passwords or authenticate the user directly.

It trusts the identity provider.

---

# Establishing the Trust Relationship

The federation configuration required components on both the AWS side and the Microsoft Entra side.

### AWS Configuration

AWS IAM must trust Microsoft Entra ID as an identity provider.

This required:

• importing Entra federation metadata
• creating a SAML Identity Provider
• defining IAM roles that federated users can assume

These IAM roles determine the permissions users receive inside AWS.

---

### Microsoft Entra Configuration

An enterprise application representing AWS was configured inside Microsoft Entra ID.

Configuration included:

• SAML single sign-on settings
• federation metadata exchange
• user assignment
• attribute mappings

This application acts as the bridge connecting Entra identities to AWS roles.

---

# Authentication Flow

When a user launches the AWS application from the Entra portal, authentication occurs in the following sequence:

```
User launches AWS application
        ↓
Microsoft Entra ID authentication
        ↓
SAML assertion generated
        ↓
Assertion delivered to AWS
        ↓
AWS verifies signature
        ↓
IAM role session created
        ↓
AWS Management Console access granted
```

Because authentication originates from Entra ID, AWS does not require stored credentials.

Access is controlled entirely through the identity provider.

---

# Validation

Federation was validated using a domain-synchronized user account.

Test procedure:

1. User authenticated to Microsoft Entra ID
2. AWS enterprise application launched from Entra portal
3. SAML authentication assertion generated
4. AWS IAM accepted assertion
5. AWS Management Console session established

Successful login confirmed:

• federation trust relationship functioning
• identity attributes correctly mapped
• AWS role assignment working

The environment now supports federated access to AWS infrastructure.

---

# Why Federation Matters

Federation changes the security model of cloud infrastructure.

Instead of managing users directly inside AWS, identity is controlled centrally through the identity provider.

This provides several operational advantages.

### Centralized Authentication

All authentication flows through the enterprise identity provider.

### Unified Identity Lifecycle

If a user account is disabled in Active Directory, access automatically disappears across integrated systems.

### Stronger Security Controls

Policies such as MFA and conditional access can be enforced at the identity provider layer.

### Reduced Credential Exposure

AWS no longer stores user passwords. Authentication responsibility remains with the identity system.

---

# Operational Lessons Learned

Federation introduces a different mindset compared to traditional account creation.

The cloud platform is no longer responsible for authentication.
It simply **trusts the identity provider**.

This means identity reliability becomes even more critical.

If the identity provider fails:

• authentication fails
• cloud access fails
• infrastructure access fails

Identity becomes a core infrastructure dependency.

This module demonstrated how enterprise identity providers extend authentication authority beyond the local domain and into external platforms.

---

# Skills Demonstrated

• SAML federation architecture
• Microsoft Entra enterprise application configuration
• AWS IAM identity provider integration
• federated authentication validation
• role-based access control within AWS
• cross-platform identity trust establishment
• enterprise identity architecture design

---

# Conclusion

With federation established, the environment now supports a full hybrid identity architecture.

Authentication authority flows from:

```
Active Directory
        ↓
Microsoft Entra ID
        ↓
External cloud platforms
```

Users authenticate once through the enterprise identity system and gain access to authorized resources across environments.

This module extended hybrid identity into **cloud infrastructure federation**, enabling centralized authentication across both internal and external platforms.

---

# Next Module

With federation operational, the next step is controlling **who receives access**.

The next module introduces **Identity Governance**, including:

• role-based access control
• identity lifecycle management
• privileged access approval workflows
• separation of duties enforcement

These controls ensure federated access remains properly governed.

---

**Maintained by:** Edward E. Spence
**Environment:** Fairmont Manufacturing Identity Security Lab
**Module:** 04 — Federated Identity
**Document Type:** Implementation & Operations Article
**Last Reviewed:** March 2026

