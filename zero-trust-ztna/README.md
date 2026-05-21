<h1 align="center">Identity-Centric Zero Trust Network Access (ZTNA)</h1>

<p align="center">
  <em>Active Directory · Cloudflare Zero Trust · Cloudflare Tunnel · MFA · ZTNA</em>
</p>

---

## Project Overview

This project replaces the traditional VPN model with a **Cloudflare Tunnel-based Zero Trust Network Access (ZTNA)** architecture that enforces identity-verified, least-privilege access to internal Active Directory resources **without exposing any service to the public internet**.

Instead of granting broad network-level access after a single VPN login, every request must be authenticated against a verified identity (AD-backed via Okta), pass device posture checks, and match a defined access policy before reaching the internal resource. The network perimeter is effectively eliminated. Trust is never assumed, it is earned at the application layer.

This lab demonstrates a **production-grade Zero Trust deployment** aligned to the NIST SP 800-207 Zero Trust Architecture standard.

---

## Architecture

```
User Device
     │
     │  HTTPS (any network, no VPN required)
     ▼
Cloudflare Access (Identity & Policy Enforcement)
     │
     │  Validates identity via Okta (AD-backed)
     │  Checks device posture (managed/compliant)
     │  Evaluates access policy (group, MFA, location)
     ▼
Cloudflare Tunnel (cloudflared daemon, outbound only)
     │
     │  Encrypted tunnel, no inbound firewall rules
     │  No public IP required on internal server
     ▼
Internal Resource (Active Directory / Internal App)
     │
     └── Only reachable through the tunnel
         Never exposed to the internet
```

> No inbound firewall rules. No VPN client. No public IP. The internal server calls out and Cloudflare routes in.

---

## Screenshots

> *(Upload your screenshots to this folder and they will render below)*

| Screenshot | Description |
|---|---|
| `01-cloudflare-tunnel-active.png` | Cloudflared daemon running, tunnel connected and healthy |
| `02-access-application-policy.png` | Cloudflare Access application with identity policy configured |
| `03-okta-idp-connected.png` | Okta connected as Identity Provider in Cloudflare Zero Trust dashboard |
| `04-mfa-enforcement.png` | MFA prompt triggered on access attempt, Okta enforcing second factor |
| `05-access-granted.png` | Authenticated user successfully reaching internal resource through tunnel |
| `06-access-denied.png` | Blocked access attempt, user fails policy check (wrong group / no MFA) |
| `07-device-posture-rule.png` | Device posture check configured, only managed/compliant devices allowed |
| `08-session-logs.png` | Cloudflare Access session logs showing auth events, user identity, and policy decision |

---

## Environment

| Component | Detail |
|---|---|
| **Zero Trust Broker** | Cloudflare Zero Trust (Access + Tunnel) |
| **Identity Provider (IdP)** | Okta (AD-backed via Okta AD Agent) |
| **Directory** | Active Directory (on-premises) |
| **Tunnel Agent** | `cloudflared` daemon installed on internal host |
| **Protected Resource** | Internal Active Directory / internal web application |
| **Auth Protocol** | OIDC (Okta → Cloudflare Access) |
| **MFA** | Enforced via Okta, required by Cloudflare Access policy |
| **Device Posture** | Managed device requirement enforced at policy layer |

---

## How Cloudflare Zero Trust Works

```
Traditional VPN Model (What this replaces):
─────────────────────────────────────────────
User authenticates once → Gets full network access → Moves laterally freely
Risk: Overprivileged access, lateral movement, insider threat

Zero Trust Model (What this builds):
─────────────────────────────────────────────
User requests specific app → Identity verified per-request → Least-privilege access only
Risk eliminated: No network access granted, only application-layer access per session
```

### Authentication & Policy Flow

```
1. User navigates to internal app URL (e.g., internal.corp.example.com)
         ↓
2. Cloudflare Access intercepts and redirects to Okta login
         ↓
3. User authenticates to Okta (AD credentials validated via AD Agent)
         ↓
4. Okta enforces MFA (push notification / TOTP)
         ↓
5. Okta returns OIDC token to Cloudflare Access
         ↓
6. Cloudflare Access evaluates policy:
     - Is the user in the allowed group? (AD group → Okta → Cloudflare)
     - Did the user complete MFA?
     - Does the device pass posture requirements?
         ↓
7. Policy PASS → Request proxied through Cloudflare Tunnel to internal resource
   Policy FAIL → Request blocked, 403 returned, no tunnel traffic initiated
         ↓
8. Session logged, user identity, device, timestamp and policy outcome all recorded
```

### Key Terms

| Term | Meaning |
|---|---|
| **Zero Trust** | Security model: never trust, always verify. No implicit trust based on network location. |
| **ZTNA** | Zero Trust Network Access, application-level access control replacing VPN |
| **Cloudflare Access** | Identity-aware proxy that enforces policy before any request reaches internal resources |
| **Cloudflare Tunnel** | `cloudflared` daemon creates an outbound-only encrypted tunnel, no inbound ports required |
| **Identity Provider (IdP)** | Okta verifies user identity and enforces MFA, connected to AD via AD Agent |
| **Device Posture** | Check that the connecting device is managed and meets security requirements |
| **Least-Privilege Access** | Users access only the specific application they are authorized for, no lateral movement |
| **Blast Radius** | The scope of damage if credentials are compromised. ZTNA minimizes this to a single app. |
| **NIST SP 800-207** | NIST's Zero Trust Architecture standard that defines the principles this deployment follows |

---

## What Was Built

### Cloudflare Tunnel Setup
- Installed `cloudflared` daemon on the internal host (domain-joined Windows Server)
- Authenticated the tunnel to the Cloudflare Zero Trust organization
- Created a **named tunnel** and configured a public hostname route pointing to the internal resource
- Verified tunnel health and connectivity in the Cloudflare dashboard, no inbound firewall rules created

### Okta as Identity Provider
- Configured **Okta as an OIDC Identity Provider** within Cloudflare Zero Trust
- Okta is AD-backed via the **Okta AD Agent**, AD remains the source of truth for credentials
- Scoped the Okta application to only allow users in specified AD groups to authenticate

### Cloudflare Access Policy
- Created an **Access Application** mapped to the tunnel hostname
- Built access policy with the following conditions:
  - **Identity check**: user must be in the approved AD group (synced to Okta)
  - **MFA enforcement**: Okta MFA required before token is issued
  - **Device posture**: managed device requirement enforced
- Policy denies access silently if any condition is not met, with no indication of internal resource existence

### Validation & Testing
- Verified **authorized user access**, authenticated through Okta + MFA and landed on internal resource
- Verified **unauthorized user block**, user outside the policy group received 403 with no resource exposed
- Verified **MFA enforcement**, access attempt without MFA completion was blocked at Okta layer
- Confirmed **no open firewall ports** on internal host, tunnel traffic is outbound-only
- Reviewed **session logs** in Cloudflare Access and confirmed user identity, device, and policy decision logged for each access event

---

## Key Concepts Demonstrated

- **Zero Trust Architecture (NIST SP 800-207)**: Never trust, always verify. Identity and device posture checked per request, not per session.
- **VPN Elimination**: Internal resources accessible with zero inbound firewall rules and zero public IP exposure
- **Identity-Verified Access**: Every access request tied to a verified AD identity, enforced through Okta + Cloudflare Access
- **MFA as an Access Gate**: MFA is not optional or advisory, it is a hard policy requirement for tunnel access
- **Device Posture Enforcement**: Only managed, compliant devices can establish a session, unmanaged devices blocked at policy layer
- **Least-Privilege Segmentation**: Users access only the specific application they are authorized for, no lateral movement possible
- **Audit Logging**: Every session is logged with identity, device, timestamp, and policy outcome for a full accountability trail

---

## Tools & Technologies

![Cloudflare Zero Trust](https://img.shields.io/badge/Cloudflare_Zero_Trust-F48120?style=flat-square&logo=cloudflare&logoColor=white)
![Cloudflare Tunnel](https://img.shields.io/badge/Cloudflare_Tunnel-F48120?style=flat-square&logo=cloudflare&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![MFA](https://img.shields.io/badge/MFA_Enforcement-555555?style=flat-square)
![ZTNA](https://img.shields.io/badge/ZTNA-555555?style=flat-square)
![NIST 800-207](https://img.shields.io/badge/NIST_SP_800--207-555555?style=flat-square)

---

## Project Status

![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square)

Tunnel active. Policies enforced. MFA required. Access verified and denied tested. Session logs captured. Architecture diagram produced.
