<h1 align="center">Identity-Centric Zero Trust Network Access (ZTNA)</h1>

<p align="center">
  <em>Active Directory · Cloudflare Zero Trust · Cloudflare Tunnel · MFA · ZTNA · Least-Privilege Access</em>
</p>

---

## Project Overview

This project replaces the traditional VPN model with a **Cloudflare Tunnel-based Zero Trust Network Access (ZTNA)** architecture that enforces identity-verified, least-privilege access to internal Active Directory resources **without exposing any service to the public internet**.

Instead of granting broad network-level access after a single VPN login, every request must pass through a verified identity check, satisfy multi-factor authentication, match a defined access policy (identity + location + IP range), and be proxied through an outbound-only encrypted tunnel before reaching the internal resource. The network perimeter is eliminated. Trust is never assumed — it is earned at the application layer, per request.

This lab demonstrates a **production-grade Zero Trust deployment** aligned to the NIST SP 800-207 Zero Trust Architecture standard.

---

## Architecture

```
User Device
     │
     │  HTTPS (any network — no VPN client required)
     ▼
Cloudflare Access (Identity & Policy Enforcement)
     │
     │  Validates identity (email-scoped, AD-backed)
     │  Checks country and IP range (geofence + network trust)
     │  Enforces MFA (biometrics or authenticator app)
     │  Evaluates Allow-Lab-Admins policy (all conditions must pass)
     ▼
Cloudflare Tunnel (cloudflared daemon — outbound only)
     │
     │  Encrypted tunnel, no inbound firewall rules
     │  No public IP required on internal server
     │  Internal host initiates the connection to Cloudflare
     ▼
Internal Resource (Active Directory / lab.investinindy.com — ***.***.***.**)
     │
     └── Only reachable through the tunnel
         Never exposed to the internet
```

> No inbound firewall rules. No VPN client. No public IP. The internal server calls out; Cloudflare routes back in — only after policy passes.

---

## Implementation

The implementation followed four phases: deploying the tunnel infrastructure, confirming the AD identity chain, building the access policy, and protecting the application.

---

### Phase 1 — Tunnel Infrastructure

#### Step 1 — Deploy the Connector to the Internal Host

The `cloudflared` daemon is installed as a persistent Windows service on the domain-joined internal server. It opens a single outbound-only encrypted connection to Cloudflare's edge — no inbound firewall rule is created, no public IP is assigned to the server. The tunnel token binds this specific service instance to the named tunnel; anyone with the token can run the tunnel, so it is treated as a credential.

![Cloudflare Zero Trust dashboard showing cloudflared Windows connector install command with security token warning](<./Zero trust - cloudflare/Screenshot 2026-04-20 155342.png>)

---

#### Step 2 — Bind a Public Hostname to the Internal Resource

The "Route Traffic" step (Step 4 of 4 in the Cloudflare tunnel wizard) creates a published application route for `Windows-Server-Lab`. A Cloudflare-managed public hostname is mapped to the internal resource. Cloudflare automatically configures DNS. When a request hits this hostname, Cloudflare receives it at the edge, evaluates the access policy, and — only if the user passes — forwards the request through the encrypted tunnel. The internal host never receives traffic from the internet directly.

![Cloudflare Route Traffic wizard showing published application route configuration for Windows-Server-Lab tunnel](<./Zero trust - cloudflare/Screenshot 2026-04-20 160210.png>)

---

#### Step 3 — Tunnel Confirmed HEALTHY

The `Windows-Server-Lab` tunnel dashboard confirms the architecture is operational. Status: **HEALTHY**. The `cloudflared` connector on `WIN-***` (Origin IP: `***.***.***.***`) is **Connected** to Cloudflare's `ord` (Chicago) data centre. No VPN. No inbound rule. No public IP on the server. The internal resource is reachable exclusively through Cloudflare's edge — from this point on, all access is mediated by policy.

| Field | Value |
|-------|-------|
| Tunnel name | Windows-Server-Lab |
| Tunnel type | cloudflared |
| Tunnel ID | ****-****-****-****-**** |
| Status | **HEALTHY** |
| Uptime | 31 minutes |
| Connector hostname | WIN-*** |
| Data centre | ord (Chicago) |
| Origin IP | ***.***.***.*** |
| Platform | windows_amd64 |
| Connector status | **Connected** |

![Cloudflare tunnel overview showing Windows-Server-Lab HEALTHY status with connector Connected at ord data centre](<./Zero trust - cloudflare/Screenshot 2026-04-20 165648.png>)

---

#### Step 4 — AD Identity Anchor: UPN Suffix Verified

PowerShell on the internal Windows Server confirms the AD forest UPN suffix is `investinindy.com`. This is the identity namespace that backs the entire Zero Trust chain. Every user who authenticates through Cloudflare Access has their identity validated against this AD domain. The command is run twice — same output both times — confirming the forest is correctly configured and the identity layer is properly anchored.

```powershell
Get-ADForest | Select-Object -ExpandProperty UPNSuffixes
# Output: investinindy.com
```

![PowerShell on internal Windows Server confirming AD forest UPN suffix investinindy.com as the Zero Trust identity anchor](<./Zero trust - cloudflare/Screenshot 2026-04-20 172745.png>)

---

### Phase 2 — Access Policy

#### Step 5 — Define Least-Privilege Policy Rules

The `Allow-Lab-Admins` policy is built with three independent rule dimensions in an Include (OR) block. Access is granted only when the request matches at least one entry across all three selectors:

- **Emails** — specific AD-backed identities: `d*****@investinindy.com`, `j*******@investininy.com`
- **Country** — United States (geographic restriction)
- **IP ranges** — `***.***.***.***` and a trusted IPv6 CIDR

This is not group-based broad access. It is explicit, multi-dimensional, identity-scoped least-privilege control.

![Cloudflare Access Add Rules page showing Include policy with Emails, Country United States, and IP ranges selectors](<./Zero trust - cloudflare/Screenshot 2026-05-18 015304.png>)

---

#### Step 6 — Enforce MFA at Platform Level

MFA is configured in Cloudflare Access settings — not delegated to individual applications. **Biometrics** and **Authenticator application** are both enabled. Authentication duration is set to **24 hours**: users must re-authenticate with MFA after each session expires. "Use identity provider MFA" is enabled with an 8-hour IdP override, ensuring MFA is always enforced regardless of application-level settings.

![Cloudflare Access settings showing MFA methods: Biometrics ON, Authenticator app ON, 24-hour authentication duration, IdP MFA ON](<./Zero trust - cloudflare/Screenshot 2026-05-18 020329.png>)

---

#### Step 7 — Policy Created: Allow-Lab-Admins Registered

The `Allow-Lab-Admins` policy is registered as a reusable policy in Cloudflare Access: Action=**ALLOW**, 3 rules configured (the email + country + IP dimensions from Step 5). The policy is now ready to be attached to any protected application. Any request that does not satisfy the rules is silently denied — no indication of the internal resource's existence is returned.

![Cloudflare Access Policies list showing Allow-Lab-Admins reusable policy with ALLOW action and 3 rules configured](<./Zero trust - cloudflare/Screenshot 2026-05-18 020513.png>)

---

### Phase 3 — Application Protection

#### Step 8 — Add Application: Self-Hosted and Private

A new application is added in Cloudflare Access using the **Self-hosted and private** type. The Add Application modal illustrates the Zero Trust model: Sources (Cloudflare One Client, WAN sites, Isolated browser) → Policy → Destinations. Access is brokered entirely through defined policy — there is no direct network path from a user to the internal resource.

![Cloudflare Add an application modal showing Self-hosted and private type selected with Sources-Policies-Destinations architecture diagram](<./Zero trust - cloudflare/Screenshot 2026-05-18 020649.png>)

---

#### Step 9 — Configure App Destination: lab.investinindy.com

The application is configured with `lab.investinindy.com` as its public hostname destination (subdomain=**lab**, domain=**investinindy.com** from the Cloudflare-managed domain). This is the URL users will navigate to — Cloudflare Access intercepts requests to this hostname before anything reaches the internal server. The internal IP (`***.***.***.**`) is referenced only internally via the tunnel; it is never publicly reachable.

![Cloudflare Create new self-hosted application showing Destinations section with subdomain lab and domain investinindy.com configured](<./Zero trust - cloudflare/Screenshot 2026-05-18 020805.png>)

---

#### Step 10 — Assign Policy and Review the Access Model

The `Allow-Lab-Admins` policy is attached to the application. The **Policy Preview** diagram confirms the complete access model before the application is created:

- **Sources**: Site users / All authenticated users  
- **Policy**: Allow-Lab-Admins  
- **Destinations**: `lab.investinindy.com` / `***.***.***.**`

"Authenticate with Cloudflare One Client" is enabled — users with an active Cloudflare One Client session (device posture confirmed) are granted seamless access. All other requests are evaluated against the policy rules at the edge.

![Cloudflare Access application Authentication tab showing Cloudflare One Client enabled and Policy Preview mapping Allow-Lab-Admins to lab.investinindy.com and ***.***.***.**](<./Zero trust - cloudflare/Screenshot 2026-05-18 022414.png>)

---

#### Step 11 — Set Session Duration and Create the Application

The application details are finalised: name=**investinindy.com**, Session Duration=**24 hours** (matching the global MFA authentication duration). The Policy Preview is visible in full, confirming the routing before the Create button is clicked. After this step the Zero Trust application goes live.

![Cloudflare Access application details showing investinindy.com name, 24-hour session duration, Policy Preview, and Create button](<./Zero trust - cloudflare/Screenshot 2026-05-18 022723.png>)

---

### Phase 4 — Validation

#### Step 12 — Application Live: SELF-HOSTED, 1 Policy Enforcing

Cloudflare `Access controls > Applications` confirms the application is active. **`investinindy.com`** is listed with Application URL `lab.investinindy.com`, **2 total domains**, **1 policy assigned**, type **SELF-HOSTED**. The internal resource is now fully protected. No unauthenticated or unauthorised request can reach it. The policy is in force.

![Cloudflare Access Applications list showing investinindy.com SELF-HOSTED with 1 policy assigned protecting lab.investinindy.com](<./Zero trust - cloudflare/Screenshot 2026-05-18 023036.png>)

---

#### Step 13 — The Identity Gate: Zero Trust Enforced at the Application Layer

A browser navigates to `lab.investinindy.com`. Cloudflare Access intercepts the request immediately — before any tunnel traffic is initiated — and redirects to `investinindy-lab.cloudflareaccess.com`. The user sees **"Log in to investinindy.com"**. The internal server is invisible. The internal network is invisible. The only surface the user touches is the Cloudflare identity gate.

No identity verification passed → no access granted → no tunnel traffic → no exposure of the internal resource. This is Zero Trust working in practice.

![Browser showing Cloudflare Access login page intercepting access to lab.investinindy.com with Log in to investinindy.com prompt](<./Zero trust - cloudflare/Screenshot 2026-05-18 024941.png>)

---

## Environment

| Component | Detail |
|---|---|
| **Zero Trust Broker** | Cloudflare Zero Trust (Access + Tunnel) |
| **Directory** | Active Directory on-premises (`investinindy.com` forest) |
| **Tunnel Agent** | `cloudflared` 2026.3.0 daemon (Windows service on internal host) |
| **Internal Host** | WIN-*** (windows_amd64, Origin IP: ***.***.***.***) |
| **Protected Resource** | `lab.investinindy.com` → internal IP `***.***.***.**` |
| **Auth Protocol** | Cloudflare Access (identity gate + policy enforcement) |
| **MFA** | Biometrics + Authenticator app enforced via Cloudflare Access settings |
| **Session Duration** | 24 hours (global MFA + application session aligned) |
| **Access Policy** | Allow-Lab-Admins: email identity + country + IP range (3 rules, ALLOW) |
| **Device Posture** | Cloudflare One Client authentication enforced |

---

## How Zero Trust Access Works Here

```
Traditional VPN (What this replaces)
─────────────────────────────────────────────────────
User authenticates once → Gets full network access
→ Moves laterally freely → Blast radius: entire network

Zero Trust ZTNA (What this builds)
─────────────────────────────────────────────────────
User requests lab.investinindy.com
         ↓
Cloudflare Access intercepts — identity gate presented
         ↓
User identity checked (email must match allowed list)
         ↓
Country check (must be United States)
         ↓
IP range check (must match trusted IPs)
         ↓
MFA enforced (biometrics or authenticator app)
         ↓
Allow-Lab-Admins policy: PASS → request proxied through tunnel
Allow-Lab-Admins policy: FAIL → 403, no tunnel traffic, no resource exposure
         ↓
Session valid for 24 hours, then full re-authentication required
```

---

## What Was Built

### Cloudflare Tunnel
- Installed `cloudflared` daemon on the internal domain-joined Windows Server as a persistent Windows service
- Created a named tunnel (`Windows-Server-Lab`) authenticated to the Cloudflare Zero Trust organisation
- Configured a public hostname route mapping `lab.investinindy.com` to the internal resource at `***.***.***.**`
- Verified tunnel health: Status=**HEALTHY**, Connector=**Connected** (no inbound firewall rule created at any point)

### Access Policy
- Built a reusable **Allow-Lab-Admins** policy with three rule dimensions:
  - **Email identity** — explicit AD-backed addresses (not group, not wildcard)
  - **Country** — United States geographic restriction
  - **IP range** — trusted IPv4 and IPv6 CIDRs
- Configured **MFA enforcement** at the platform level: biometrics and authenticator app both enabled, 24-hour session duration
- Enabled **Cloudflare One Client authentication** for device posture-aware access

### Application Protection
- Created a **Self-hosted and private** Access Application mapped to the tunnel hostname
- Attached the Allow-Lab-Admins policy with a 24-hour session duration
- Confirmed policy routing via the Policy Preview before application creation

### Validation
- Navigated to `lab.investinindy.com` from a browser — Cloudflare Access intercepted and presented the identity gate
- Confirmed the internal server is invisible from the internet — no direct route, no open port, no public IP
- Verified tunnel remained HEALTHY under sustained operation (31-minute uptime confirmed; connector persisted on `WIN-***`)
- Confirmed AD identity anchor: UPN suffix `investinindy.com` registered in the forest, backing the identity chain end-to-end

---

## Key Concepts Demonstrated

| Concept | Implementation |
|---|---|
| **Zero Trust Architecture (NIST SP 800-207)** | Never trust, always verify — identity, location, and device evaluated per request, not per session |
| **VPN Elimination** | Zero inbound firewall rules, zero public IP, zero VPN client — tunnel is entirely outbound-initiated |
| **Least-Privilege Access** | Three-dimension policy (email + country + IP) — not broad group membership but explicit per-identity allow rules |
| **MFA as a Hard Gate** | MFA enforced at platform level (24h session) — not advisory, not app-level optional |
| **Blast Radius Minimisation** | Compromise of credentials grants access to one application only, not network-level lateral movement |
| **Identity-Verified Application Access** | Every request tied to a verified AD-backed identity before any tunnel traffic is initiated |
| **Device Posture Enforcement** | Cloudflare One Client authentication required — unmanaged devices cannot bypass the policy gate |

---

## Key Terms

| Term | Meaning |
|---|---|
| **Zero Trust** | Security model: never trust, always verify. No implicit trust based on network location. |
| **ZTNA** | Zero Trust Network Access — application-level access control replacing VPN |
| **Cloudflare Access** | Identity-aware proxy that enforces policy before any request reaches internal resources |
| **Cloudflare Tunnel** | `cloudflared` daemon creates an outbound-only encrypted tunnel — no inbound ports required |
| **Allow-Lab-Admins** | The reusable access policy: email + country + IP (3 rules, ALLOW action) |
| **Blast Radius** | Scope of damage if credentials are compromised. ZTNA minimises this to a single application. |
| **NIST SP 800-207** | NIST's Zero Trust Architecture standard that defines the principles this deployment follows |
