<h1 align="center">SAML 2.0 SSO Integration: Okta (IdP) → Salesforce (SP)</h1>

<p align="center">
  <em>Active Directory · Okta AD Agent · Okta (IdP) · Salesforce (SP) · SAML 2.0 · JIT Provisioning</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square" />
  <img src="https://img.shields.io/badge/Protocol-SAML_2.0-555555?style=flat-square" />
  <img src="https://img.shields.io/badge/IdP-Okta-007DC1?style=flat-square&logo=okta&logoColor=white" />
  <img src="https://img.shields.io/badge/SP-Salesforce-00A1E0?style=flat-square&logo=salesforce&logoColor=white" />
  <img src="https://img.shields.io/badge/Directory-Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white" />
</p>

---

## Project Overview

This project implements a production-style **SAML 2.0 Single Sign-On (SSO)** pipeline connecting an on-premises **Active Directory** environment to **Salesforce** via **Okta** as the cloud Identity Provider.

The core problem this solves: employees managed in on-prem Active Directory need seamless, password-free access to Salesforce. Rather than maintaining a separate Salesforce credential set, AD remains the single source of truth — users authenticate once at Okta (which validates against AD via the AD Agent) and receive a signed SAML assertion that Salesforce trusts.

**What makes this enterprise-grade:**
- AD Agent bridges on-prem identity to the cloud — no manual user re-entry
- JIT provisioning ensures AD users are auto-created in Salesforce on first login
- Okta's X.509 certificate signing guarantees assertion integrity end-to-end
- Group-based access control means only authorised AD groups reach Salesforce
- The Okta System Log provides a full audit trail of every SSO event

This lab serves as the **identity federation backbone** for the broader IAM portfolio — demonstrating the same architecture enterprises use to connect AD directories to SaaS applications at scale.

---

---

## Highlights

> Key screenshots — real, working proof of implementation. Full configuration walkthrough is below.

---

### Highlight 1 — Salesforce SAML SP Configuration with Okta Certificate Uploaded

![Salesforce SAML SSO Settings Detail](SAML/Screenshot%202026-05-26%20212914.png)

**What this proves:** The Salesforce SP side of the SAML handshake, fully configured. Okta's X.509 certificate (valid until May 2036) is uploaded, the Identity Provider Login URL is pointed at the Okta SSO endpoint, HTTP POST binding is selected, and NameIdentifier identity location is set. Every field maps directly from the Okta app — end-to-end configuration knowledge, not just a tutorial walkthrough.

---

### Highlight 2 — Salesforce.com Tile Active in Okta Dashboard

![Okta Dashboard with Salesforce.com](SAML/Screenshot%202026-05-26%20213002.png)

**What this proves:** The Salesforce SAML app is assigned and live in the Okta end-user dashboard. Clicking this tile triggers an IdP-initiated SAML flow — Okta builds a signed assertion and POSTs it to Salesforce's ACS URL, granting a session with no Salesforce credentials required.

---

### Highlight 3 — AD Agent Running on Domain Controller + Live SSO Events

![AD Agent Running on Domain Controller](SAML/Screenshot%202026-05-08%20171302.png)

**What this proves:** Okta AD Agent physically installed and running on the Windows Server 2022 domain controller (`***-***-***`, v3.22.0.0). The Okta System Log visible in the background confirms `user.authentication.sso SUCCESS` with 723 events — the full AD → Okta → SSO pipeline is live infrastructure, not a simulated environment.

---

### Highlight 4 — JIT Provisioning Configured in AD-Okta Bridge

![JIT Provisioning Settings](SAML/Screenshot%202026-05-08%20162534.png)

**What this proves:** JIT provisioning enabled in the AD-to-Okta integration ("Create and update users on login") — new AD users are automatically provisioned into Salesforce on first SSO login. No pre-provisioning ticket, no manual admin step required.

---

## Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                       On-Premises Environment                        │
│                                                                      │
│   Active Directory (***-***-***)                                     │
│   ├── Users & Groups (source of truth)                               │
│   └── Okta AD Agent v3.22.0.0 ──── syncs / validates ──────────┐    │
└────────────────────────────────────────────────────────────────────┐ │
                                                                     │ │
                          ┌──────────────────┐                       │ │
                          │   Okta (Cloud)   │ ◄─────────────────────┘ │
                          │                  │                          │
                          │  • SAML 2.0 App  │                          │
                          │  • Attribute Map │                          │
                          │  • Group Policy  │                          │
                          │  • System Log    │                          │
                          └────────┬─────────┘                          │
                                   │                                    │
                      SAML Assertion (signed, X.509)                   │
                                   │                                    │
                          ┌────────▼─────────┐                          │
                          │   Salesforce     │                          │
                          │   (Service       │                          │
                          │    Provider)     │                          │
                          │                  │                          │
                          │  • SSO Settings  │                          │
                          │  • ACS URL       │                          │
                          │  • Entity ID     │                          │
                          │  • JIT Prov.     │                          │
                          └──────────────────┘                          │
```

---

## Environment

| Component | Detail |
|---|---|
| **Identity Provider (IdP)** | Okta (org: `***-***-***`) |
| **Service Provider (SP)** | Salesforce |
| **User Directory** | Active Directory (on-premises, Windows Server 2022 Datacenter) |
| **Domain Controller** | `***-***-***` |
| **AD Agent Version** | Okta AD Agent Management Utility v3.22.0.0 |
| **Protocol** | SAML 2.0 |
| **Provisioning** | JIT (Just-In-Time) — Create and update users on login |
| **API Tooling** | Postman (Okta Admin Management API collection) |
| **Client OS** | Windows 10, Chromium Edge |

---

## How SAML 2.0 Works in This Setup

```
1. User navigates to Salesforce login URL
         ↓
2. Salesforce detects no active session — generates SAML AuthnRequest
   and redirects the browser to Okta's SSO URL
         ↓
3. User authenticates at Okta (username + password)
   Okta AD Agent validates credentials against Active Directory on-prem
         ↓
4. Okta builds a SAML Assertion (XML) containing:
   - NameID (mapped to AD email)
   - Attribute statements: email, firstName, lastName (from AD)
   - Validity window (NotBefore / NotOnOrAfter)
   Okta signs the Assertion with its private key (X.509 certificate)
         ↓
5. Browser POSTs the signed Assertion to Salesforce's ACS URL
         ↓
6. Salesforce validates the signature using Okta's uploaded X.509 public certificate
   JIT provisioning creates/updates the Salesforce user profile from Assertion attributes
         ↓
7. Salesforce session is established — user is logged in
   Okta System Log records: user.authentication.sso SUCCESS
```

<details>
<summary><strong>Protocol Reference</strong> — key terms used in this setup</summary>

| Term | Role in This Setup |
|---|---|
| **IdP (Identity Provider)** | Okta — authenticates users and issues SAML assertions |
| **SP (Service Provider)** | Salesforce — consumes and validates SAML assertions |
| **SAML Assertion** | Signed XML from Okta confirming user identity and attributes |
| **ACS URL** | Salesforce endpoint (`/services/auth/saml/...`) that receives the POST |
| **Audience URI / Entity ID** | Unique URI identifying Salesforce to Okta (`https://saml.salesforce.com`) |
| **X.509 Certificate** | Okta's public cert uploaded into Salesforce — proves the assertion is genuine |
| **NameID** | The unique identifier in the assertion — mapped to the AD user's email |
| **JIT Provisioning** | Salesforce auto-creates a user record on first successful SSO login |
| **AD Agent** | Installed on the DC — syncs AD users to Okta and delegates password validation |

</details>

---

## Configuration Walkthrough

### Prerequisites — Provision Users into Okta via API

Before SAML configuration begins, user identities must exist in the Okta org. Rather than manual entry, the **Okta Admin Management API** was used via Postman to bulk-create users programmatically.

The Postman Collection Runner executed `POST /api/v1/users` with `activate=true&provider=false&nextLogin=changePassword` across 3 iterations — each returning **HTTP 200**, confirming successful user creation.

<details>
<summary>Screenshot — Postman: Okta API Bulk User Creation (3x HTTP 200)</summary>

![Postman Okta API Run](SAML/Screenshot%202026-05-07%20172143.png)

*Postman Collection Runner: 3 iterations of `POST Create a user` against `***.okta.com`, all returning HTTP 200 with average response time 414ms. Zero errors.*
</details>

---

### Step 1 — Install and Configure the Okta AD Agent on the Domain Controller

The **Okta AD Agent** is the bridge between on-premises Active Directory and the Okta cloud. It is installed directly on the domain controller so that:
- AD users and groups can be imported into Okta
- Password validation for Okta authentication is delegated back to AD (users authenticate with their actual AD password)

**Installation steps performed:**
1. Downloaded the Okta AD Agent installer from the Okta Admin Console
2. Ran the installer on domain controller `***-***-***` (Windows Server 2022 Datacenter)
3. Authenticated the agent against the Okta org using an admin API token
4. Configured the **Service Account** with appropriate AD read permissions
5. Configured **Domains** to specify which AD domain to sync
6. Verified the agent status: **"The agent is running"** (green status, v3.22.0.0)

The Okta System Log simultaneously shows **723 recorded events** including `user.authentication.sso SUCCESS` — confirming the SSO pipeline is live while the agent runs in the background.

![AD Agent Running on Domain Controller](SAML/Screenshot%202026-05-08%20171302.png)

*Okta AD Agent Management Utility on Windows Server 2022 DC (`***-***-***`) showing "The agent is running" (v3.22.0.0). Background: Okta System Log with `user.authentication.sso` SUCCESS event confirmed — 723 total events recorded.*

---

### Step 2 — Configure AD-to-Okta Sync Settings (JIT Provisioning)

With the AD Agent installed, the import and provisioning behaviour was configured inside the Okta Admin Console under the Active Directory integration settings.

**Key settings configured:**

| Setting | Value | Why |
|---|---|---|
| **Schedule import** | Never | Manual-triggered sync — controlled imports |
| **Okta username format** | Custom | Email-based format matching AD `userPrincipalName` |
| **Update application username on** | Create and update | Username stays in sync when AD attributes change |
| **JIT provisioning** | ✅ Create and update users on login | Auto-creates Salesforce profiles for AD users on first SSO login |
| **USG support** | Disabled | Universal security groups not required for this setup |
| **Activation emails** | Disabled | Suppressed — users activate via AD-delegated auth, not email link |

The JIT provisioning setting is critical: it means an AD user does not need to be manually pre-provisioned in Salesforce. When they log in via SAML SSO for the first time, Salesforce creates their profile automatically from the attributes in the SAML assertion.

![AD Integration JIT Provisioning Settings](SAML/Screenshot%202026-05-08%20162534.png)

*Okta Active Directory integration settings with JIT provisioning ("Create and update users on login") highlighted — configuring how AD users are handled when they authenticate through Okta into connected apps.*

---

### Step 3 — Create and Configure the SAML 2.0 Application in Okta

In the Okta Admin Console (`Applications → Create App Integration → SAML 2.0`), a new SAML application was created for Salesforce with the following configuration:

**General SAML Settings:**
- **Single Sign-On URL (ACS URL):** Salesforce SAML ACS endpoint (SP-provided)
- **Audience URI (SP Entity ID):** `https://saml.salesforce.com` (Salesforce entity identifier)
- **Name ID Format:** `EmailAddress`
- **Application username:** AD email attribute (`user.email`)

**Attribute Statements (claims passed in the SAML assertion):**

| Attribute Name | Value Mapped From AD |
|---|---|
| `email` | `user.email` |
| `firstName` | `user.firstName` |
| `lastName` | `user.lastName` |

**App Assignment:**
- AD-synced groups were assigned to the Okta SAML app
- Only users in authorised AD groups receive a SAML assertion — all others are denied at the IdP

Once the app was configured, Okta exposed the SAML metadata needed to configure Salesforce as the SP. The key URLs retrieved from the Okta app metadata panel:

| Okta-Provided Value | Used In Salesforce |
|---|---|
| **Metadata URL** | `https://***.okta.com/app/***/sso/saml/metadata` |
| **Sign on URL (ACS)** | `https://***.okta.com/app/salesforce/***/sso/saml` |
| **Sign out URL** | `https://***.okta.com` |

![Okta SAML App Metadata](SAML/Screenshot%202026-05-26%20213037.png)

*Okta Admin Console → Applications → Salesforce.com → Sign On tab showing SAML 2.0 metadata details: Metadata URL, Sign on URL, and Sign out URL. The "View SAML setup instructions" button (highlighted) provides a step-by-step guide for configuring the SP side. (Org-specific URLs redacted.)*

---

### Step 4 — Configure Salesforce as the Service Provider

Inside Salesforce (`Setup → Identity → Single Sign-On Settings`), Salesforce was configured to accept SAML assertions from Okta.

**First, SAML federation was enabled at the org level:**

![Salesforce SAML Enabled](SAML/Screenshot%202026-05-26%20213327.png)

*Salesforce Setup → Identity → Single Sign-On Settings with "SAML Enabled" checked under Federated Single Sign-On Using SAML — this unlocks the ability to create SAML SSO configurations.*

**Then the "Okta SAML" SSO configuration was created with the following real values:**

| Field | Actual Value |
|---|---|
| **Name** | Okta SAML |
| **API Name** | Okta_SAML |
| **SAML Version** | 2.0 |
| **Issuer** | `***` (Okta app entity ID) |
| **Entity ID** | `https://saml.salesforce.com` |
| **Identity Provider Certificate** | `CN=***, OU=SSOProvider, O=Okta` — Expiry: 12 May 2036 |
| **Request Signing Certificate** | `SelfSignedCert_***` |
| **Request Signature Method** | RSA-SHA256 |
| **Assertion Decryption** | Assertion not encrypted |
| **SAML Identity Type** | Assertion contains the User's Salesforce username |
| **SAML Identity Location** | Identity is in the NameIdentifier element of the Subject statement |
| **SP-Initiated Binding** | HTTP POST |
| **Identity Provider Login URL** | `https://***.okta.com/app/salesforce/***/sso/saml` |
| **Custom Logout URL** | `https://***.okta.com` |

![Salesforce Single Sign-On Settings Overview](SAML/Screenshot%202026-05-26%20212835.png)

*Salesforce Setup → Single Sign-On Settings page confirming SAML is enabled and showing the configured "Okta SAML" entry (SAML Version 2.0, Issuer: ***, Entity ID: https://saml.salesforce.com).*

![Salesforce SAML SSO Settings Detail](SAML/Screenshot%202026-05-26%20212914.png)

*The full SAML Single Sign-On Settings form in Salesforce showing the Okta X.509 certificate already uploaded (valid until May 2036), the Identity Provider Login URL pointed at the Okta app's SSO endpoint, HTTP POST binding selected, and NameIdentifier-based identity location — exactly matching the Okta app configuration.*

---

### Step 5 — Testing and Validation

**App Assignment Confirmed — Salesforce.com tile in Okta dashboard:**

With the SAML app configured and assigned, the Salesforce.com tile became immediately available in the Okta end-user dashboard — the launch point for IdP-initiated SSO.

![Okta Dashboard — Salesforce.com App Assigned](SAML/Screenshot%202026-05-26%20213002.png)

*Okta end-user dashboard showing Salesforce.com tile active in the Work section — app assigned, provisioned, and ready for IdP-initiated SSO.*

**IdP-Initiated SSO (tested):**
1. Logged into Okta dashboard as an AD-synced user
2. Clicked the **Salesforce.com** tile (visible in the dashboard above)
3. Okta generated and POSTed a SAML assertion to Salesforce's ACS URL
4. Salesforce validated the assertion against the uploaded Okta X.509 certificate
5. JIT provisioning created the Salesforce user profile from assertion attributes
6. User landed in Salesforce without entering a Salesforce password

**SP-Initiated SSO (tested):**
1. Navigated directly to the Salesforce My Domain login URL
2. Salesforce detected no session, generated a SAML AuthnRequest, redirected to Okta
3. Authenticated with AD credentials at Okta's login page
4. Okta validated against AD via the AD Agent, issued a signed SAML assertion
5. Browser POSTed assertion to Salesforce ACS URL — session created

**User Import Confirmation:**

![Salesforce Import Results](SAML/Screenshot%202026-05-26%20213139.png)

*Okta Admin Console → Salesforce.com app → Import tab showing 4 imported users confirmed with 0 needing review — Okta successfully matched and imported Salesforce user records to Okta user assignments.*

**Audit Log Verification:**
The Okta System Log recorded every SSO event, including `user.authentication.sso SUCCESS`, with actor IP, client info, and target app — providing a complete audit trail.

![Okta System Log — SSO Events](SAML/Screenshot%202026-05-07%20173034.png)

*Okta Admin Console System Log (529+ events) showing SSO session events: `User single sign on to app` SUCCESS, OIDC access and ID token grants — actor: Daniel Awurah, IP `***.***.***.***`, client: Chromium Edge on Windows 10.*

---

## Key Concepts Demonstrated

| Concept | How It Was Implemented |
|---|---|
| **Identity Federation** | On-prem AD directory federated to cloud SaaS (Salesforce) via Okta SAML 2.0 |
| **AD as Source of Truth** | All identity data (username, email, name, group membership) originates in AD and flows through the chain |
| **IdP-Initiated SSO** | Login triggered from Okta dashboard — Okta generates assertion and posts to Salesforce |
| **SP-Initiated SSO** | Login triggered from Salesforce — redirects to Okta for authentication then returns |
| **JIT Provisioning** | First-login Salesforce account creation from SAML assertion attributes — no pre-provisioning required |
| **Attribute Mapping** | AD fields (`email`, `firstName`, `lastName`) passed as SAML attribute statements into Salesforce |
| **Group-Based Access Control** | Only AD groups assigned to the Okta app receive a SAML assertion — unassigned users are denied |
| **Certificate-Based Trust** | Salesforce verifies assertion integrity using Okta's X.509 public certificate — no shared secret |
| **Delegated Authentication** | Okta delegates password validation to AD via the AD Agent — AD credentials are never replicated to Okta |
| **Audit Logging** | Okta System Log records every SSO event with actor, IP, client, and target — meets enterprise compliance requirements |

---

## Tools & Technologies

![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Salesforce](https://img.shields.io/badge/Salesforce-00A1E0?style=flat-square&logo=salesforce&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows_Server_2022-0078D4?style=flat-square&logo=windows&logoColor=white)
![SAML 2.0](https://img.shields.io/badge/SAML_2.0-555555?style=flat-square)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=flat-square&logo=postman&logoColor=white)
![Okta AD Agent](https://img.shields.io/badge/Okta_AD_Agent_v3.22-007DC1?style=flat-square&logo=okta&logoColor=white)

| Tool / Service | Purpose |
|---|---|
| **Okta** | Cloud Identity Provider — SAML app config, group policy, system logging |
| **Okta AD Agent v3.22.0.0** | On-prem agent on DC — AD sync, credential delegation |
| **Active Directory** | Source of truth for all user identities and group memberships |
| **Salesforce** | Service Provider — SAML SSO settings, JIT provisioning, ACS endpoint |
| **Postman** | Okta Admin Management API — programmatic user provisioning pre-SAML testing |
| **Windows Server 2022 Datacenter** | Host OS for the domain controller running the AD Agent |

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

All phases complete: AD Agent deployed and running, Okta SAML app configured, Salesforce SP settings applied, JIT provisioning enabled, IdP-initiated and SP-initiated SSO validated, audit log confirmed. Screenshots available in `SAML/`.

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
