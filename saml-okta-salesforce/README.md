<h1 align="center">SAML 2.0 SSO Integration: Okta and Salesforce</h1>

<p align="center">
  <em>Okta (IdP) · Salesforce (SP) · Active Directory · SAML 2.0</em>
</p>

---

## Project Overview

This project demonstrates how to configure a real enterprise **Single Sign-On (SSO)** workflow using **SAML 2.0**, with **Okta as the Identity Provider (IdP)** and **Salesforce as the Service Provider (SP)**.

Active Directory serves as the **source of truth** for user identities, synced into Okta via the **Okta AD Agent**. When a user authenticates, Okta issues a signed SAML assertion to Salesforce, which validates it and grants access without the user needing a separate Salesforce password.

This lab is the **foundational prerequisite** for all subsequent IAM projects, establishing the identity federation backbone used across the portfolio.

---

## Screenshots

> *(Screenshots folder , see repo files above)*

| Screenshot | Description |
|---|---|
| `ad-agent-sync.png` | AD Agent installed and users syncing from AD to Okta |
| `okta-app-saml-config.png` | SAML settings configured inside Okta app |
| `attribute-mapping.png` | Attribute statements mapping AD fields to Salesforce |
| `salesforce-sso-settings.png` | Salesforce SP configuration with Okta cert uploaded |
| `sso-login-flow.png` | End-to-end SSO login flow working successfully |
| `access-denied.png` | Unassigned user denied access at Okta |

---

## Environment

| Component | Detail |
|---|---|
| **Identity Provider (IdP)** | Okta (trial org) |
| **Service Provider (SP)** | Salesforce |
| **Directory** | Active Directory, synced to Okta via AD Agent |
| **Source of Truth** | On-premises Active Directory |
| **Protocol** | SAML 2.0 |
| **User Store** | AD users provisioned into Okta via AD Agent |

---

## How SAML 2.0 Works

```
1. User attempts to access Salesforce
         ↓
2. Salesforce redirects browser to Okta with a SAML AuthnRequest
         ↓
3. User authenticates at Okta (credentials validated against AD via AD Agent)
         ↓
4. Okta builds and signs a SAML Assertion (XML) using its private key
         ↓
5. Okta sends the signed Assertion to Salesforce's ACS URL via browser POST
         ↓
6. Salesforce validates the Assertion using Okta's X.509 public certificate
         ↓
7. Session created, user is logged into Salesforce
```

### Key Terms

| Term | Meaning |
|---|---|
| **IdP (Identity Provider)** | Okta, the system that verifies user identity |
| **SP (Service Provider)** | Salesforce, the app the user wants to access |
| **SAML Assertion** | Signed XML document Okta sends to confirm the user's identity |
| **ACS URL** | Salesforce endpoint that receives and validates the SAML assertion |
| **Entity ID** | Unique URI that identifies the SP to Okta |
| **X.509 Certificate** | Okta's public cert, used by Salesforce to verify the assertion was signed by Okta |
| **AD Agent** | Okta component installed on-prem to sync AD users and validate credentials |

---

## What Was Built

### Active Directory → Okta Sync (AD Agent)
- Installed and configured the **Okta AD Agent** on the domain controller
- Configured **OU-scoped sync** to import targeted users and groups from AD into Okta
- AD remains the **source of truth**, password changes, account status, and attributes all flow from AD to Okta
- Verified user import and attribute mapping in Okta dashboard

### Okta SAML App Configuration
- Created a **SAML 2.0 application** in Okta for Salesforce
- Configured:
  - **Single Sign-On URL** (Salesforce ACS URL)
  - **Audience URI / Entity ID** (Salesforce SP Entity ID)
  - **Name ID format** mapped to AD user email attribute
  - **Attribute statements** passed `email`, `firstName`, `lastName` from AD to Salesforce
- Assigned AD-synced **groups** to the Okta app to control who gets access

### Salesforce SP Configuration
- Enabled **Salesforce as a Service Provider** under Identity settings
- Uploaded Okta's **X.509 signing certificate** into Salesforce
- Configured the **SAML SSO settings** in Salesforce with:
  - Issuer (Okta Entity ID)
  - Identity Provider Login URL (Okta SSO URL)
  - Identity Location (Subject, NameID)
- Set the **Login URL** to redirect unauthenticated users to Okta

### End-to-End Testing & Validation
- Validated **IdP-initiated SSO**, logged in via Okta dashboard, clicked Salesforce app and landed in Salesforce session
- Validated **SP-initiated SSO**, navigated to Salesforce login URL, was redirected to Okta, authenticated and returned to Salesforce
- Verified **attribute mapping**, confirmed name and email appeared correctly inside Salesforce from AD data
- Tested **access control**, users not assigned to the Okta app were denied access

---

## Screenshots

> *(Screenshots folder , see repo files above)*

| Screenshot | Description |
|---|---|
| `ad-agent-sync.png` | AD Agent installed and users syncing from AD to Okta |
| `okta-app-saml-config.png` | SAML settings configured inside Okta app |
| `attribute-mapping.png` | Attribute statements mapping AD fields to Salesforce |
| `salesforce-sso-settings.png` | Salesforce SP configuration with Okta cert uploaded |
| `sso-login-flow.png` | End-to-end SSO login flow working successfully |
| `access-denied.png` | Unassigned user denied access at Okta |

---

## Key Concepts Demonstrated

- **Identity Federation**: Connecting an on-prem AD directory to a cloud SaaS application via a cloud IdP
- **SAML 2.0 SP-Initiated and IdP-Initiated flows**: Understanding both directions of the auth handshake
- **AD as Source of Truth**: All identity data originates from AD, flows through Okta and reaches Salesforce
- **Attribute Mapping**: Passing user attributes (email, name) from AD through SAML assertions into the SP
- **Group-Based Access Control**: Controlling which AD users/groups can access Salesforce via Okta
- **Certificate-Based Trust**: Salesforce trusts Okta's signed assertions via X.509 certificate validation

---

## Tools & Technologies

![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Salesforce](https://img.shields.io/badge/Salesforce-00A1E0?style=flat-square&logo=salesforce&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![SAML](https://img.shields.io/badge/SAML_2.0-555555?style=flat-square)
![Okta AD Agent](https://img.shields.io/badge/Okta_AD_Agent-007DC1?style=flat-square&logo=okta&logoColor=white)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: Video walkthrough & screenshots available in this repository.

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
