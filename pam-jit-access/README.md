<h1 align="center">Privileged Access Management (PAM) & Just-in-Time Access</h1>

<p align="center">
  <em>HashiCorp Vault · Active Directory · Okta · CyberArk (Concepts) · PowerShell · Python</em>
</p>

---

## Project Overview

Privileged accounts are the highest-value targets in any environment. Domain admins, root accounts, service accounts with elevated rights, database administrators — if any of these are compromised, the impact is catastrophic. Traditional PAM strategies vault credentials and record sessions, but they still leave standing privilege in place: the admin account exists 24/7, even when nobody needs it.

This project builds a **PAM programme with Just-in-Time (JIT) access** at its core. Instead of permanent admin accounts, privilege is granted for a fixed, purpose-bound window, tied to a specific task, approved through a workflow, fully logged, and automatically revoked when the window closes. No standing privilege. No persistent admin accounts. No credential exposure. If an account is compromised, it is already expired.

The implementation uses **HashiCorp Vault** for dynamic secret generation and credential vaulting, **Okta** for identity-bound access workflows, and **Active Directory** as the privileged identity target. It demonstrates a production-grade approach to eliminating standing privilege in a Windows enterprise environment.

---

## Screenshots

> *(Upload your screenshots to this folder and they will render below)*

| Screenshot | Description |
|---|---|
| `01-vault-pki-secrets-engine.png` | HashiCorp Vault with dynamic secrets engine configured for AD credentials |
| `02-jit-request-submitted.png` | JIT access request submitted by user, specifying task scope and duration |
| `03-approval-workflow.png` | Approval workflow triggered, manager receives and approves the JIT request |
| `04-temp-credential-issued.png` | Temporary privileged credential issued post-approval, time-limited lease active |
| `05-session-recording-active.png` | Privileged session in progress, full session recording capturing all activity |
| `06-credential-auto-revoked.png` | Lease expiry reached, credential automatically revoked and AD account disabled |
| `07-vault-audit-log.png` | Vault audit log showing full credential lifecycle: issued, used, expired |
| `08-break-glass-account.png` | Break-glass emergency access procedure documented and tested |

---

## Environment

| Component | Detail |
|---|---|
| **Secrets & Credential Vault** | HashiCorp Vault (self-hosted) |
| **Identity Provider** | Okta |
| **Directory** | Active Directory (on-premises, Windows Server) |
| **Privileged Target** | AD Domain Admin accounts · Local admin on Windows hosts |
| **JIT Workflow** | Okta Workflows · Python approval script |
| **Session Recording** | Cloudflare Access (for remote sessions) · PowerShell transcript logging |
| **Scripting** | PowerShell · Python |
| **Output** | JIT Access Log · Session Recording Archive · Vault Audit Trail |

---

## The Problem with Standing Privilege

```
Traditional PAM Model (Static Vault):
────────────────────────────────────────────────────
Admin account exists permanently in AD
         ↓
Credential stored in a vault (e.g., CyberArk)
         ↓
User checks out the credential when needed
         ↓
Credential is rotated after check-in
         ↓
But: The account still exists 24/7. It is always there.
      If vault is bypassed or creds are cached — full admin access, no time limit.

JIT Access Model (What this builds):
────────────────────────────────────────────────────
No permanent admin account exists in the directory
         ↓
User raises a JIT access request: task, system, duration
         ↓
Request approved → HashiCorp Vault dynamically creates a temp privileged account
         ↓
Account exists only for the approved window (e.g., 60 minutes)
         ↓
Lease expires → account automatically disabled and credential deleted
         ↓
If the credential is stolen: it is already expired before it can be used
```

---

## How Just-in-Time Access Works

```
1. User identifies a task requiring elevated privilege
         ↓
2. JIT request submitted: system target, privilege level, task description, duration requested
         ↓
3. Approval workflow triggered: request routed to line manager or security team
         ↓
4. Approver reviews request, approves or denies
         ↓
5. On approval: HashiCorp Vault issues a dynamic credential with a fixed time-to-live (TTL)
         ↓
6. User receives temporary credentials, accesses the target system
         ↓
7. All activity during the session is recorded (session transcript, command log)
         ↓
8. TTL expires: Vault revokes the credential, AD account disabled automatically
         ↓
9. Full audit trail retained: who requested, who approved, what was done, when it ended
```

### Key Terms

| Term | Meaning |
|---|---|
| **PAM (Privileged Access Management)** | Controls and tools governing who can access privileged accounts, how, and for how long |
| **JIT (Just-in-Time) Access** | Privilege granted only when needed, for a fixed window, automatically revoked on expiry |
| **Standing Privilege** | Permanent admin access that persists 24/7 regardless of whether it is actively needed |
| **Dynamic Secret** | A credential generated on-demand by Vault with a defined TTL, never stored persistently |
| **TTL (Time-to-Live)** | The lifespan of a JIT credential. When it expires, the credential is automatically revoked |
| **Lease** | Vault's term for the active life of a dynamic secret. Leases expire and can be renewed or revoked |
| **Break-Glass Account** | An emergency access account used only in crisis scenarios, with heavily audited activation |
| **Session Recording** | A full capture of all activity performed during a privileged session, retained as audit evidence |
| **Credential Vaulting** | Storing privileged credentials in an encrypted vault rather than in scripts, docs, or shared files |
| **Blast Radius** | The potential impact of a compromised credential. JIT minimises blast radius by shrinking credential lifespan |
| **Least Privilege** | Granting only the minimum access level required for the specific task, for the minimum time required |

---

## What Was Built

### HashiCorp Vault Setup & Configuration
- Deployed **HashiCorp Vault** in a self-hosted environment on Windows Server
- Enabled and configured the **Active Directory Secrets Engine** to allow Vault to manage AD account credentials dynamically
- Configured **Vault policies** to scope access: which users can request which privilege levels
- Enabled **Vault audit logging** to capture every credential request, issuance, renewal, and revocation

```hcl
# Vault policy: allow engineering admins to request Windows server admin access
path "ad/creds/windows-server-admin" {
  capabilities = ["read"]
}

path "ad/creds/domain-admin" {
  capabilities = ["deny"]  # Domain admin requires separate break-glass workflow
}
```

### JIT Access Request & Approval Workflow
- Built a **Python-based JIT request script** that prompts users to specify: target system, privilege level, task description, and requested duration
- Request submitted to an approval queue in **Okta Workflows**, routing to the appropriate approver based on privilege level
- Approval triggers a call to the Vault API to generate and issue the time-limited credential
- Denial closes the request with no credential issued; logged with reason

```python
# Example: Submit a JIT access request to Vault on approval
import hvac

client = hvac.Client(url='https://vault.internal.corp', token=vault_approver_token)

# Issue dynamic AD credential with 60-minute TTL
response = client.secrets.active_directory.generate_credentials(
    name='windows-server-admin',
    mount_point='ad'
)

temp_username = response['data']['username']
temp_password = response['data']['current_password']
lease_id       = response['lease_id']
lease_duration = response['lease_duration']  # 3600 seconds

print(f"Credential issued. Valid for {lease_duration // 60} minutes.")
print(f"Lease ID: {lease_id} — will auto-revoke at expiry.")
```

### Dynamic Credential Lifecycle in Active Directory
- Vault's AD Secrets Engine creates a **temporary AD account** (or rotates an existing one) with the approved privilege level
- Account placed into the appropriate AD security group for the approved scope
- On TTL expiry, Vault automatically **rotates the password** and removes the account from the privileged group
- Used **PowerShell** to verify account state before and after TTL expiry, confirming clean revocation

```powershell
# Verify account state after TTL expiry
$account = Get-ADUser -Identity "vault-jit-svc-0042" -Properties Enabled, MemberOf
Write-Output "Account Enabled: $($account.Enabled)"       # Expected: False
Write-Output "Group Memberships: $($account.MemberOf)"    # Expected: empty (admin group removed)
```

### Session Recording & Audit Trail
- Enabled **PowerShell transcript logging** on all privileged hosts to capture every command executed during a JIT session
- Configured **Cloudflare Access** session logging for all remote privileged access, capturing auth events, session duration, and actions
- Retained session transcripts in a protected log store inaccessible to the privileged user themselves
- Cross-referenced session transcripts against the original JIT request task description as part of the post-session review

### Break-Glass Emergency Access
- Documented and tested a **break-glass procedure** for scenarios where Vault is unavailable
- Break-glass account stored in a physically secured sealed envelope, with digital audit trigger on access
- Break-glass activation automatically alerts the security team and initiates a mandatory post-incident review
- Account password rotated immediately following any break-glass use

### Vault Audit Trail & Reporting
- Exported Vault audit logs in JSON format and parsed with Python to produce a structured PAM activity report
- Report shows: number of JIT requests, approval rate, average session duration, credentials auto-revoked vs. manually revoked
- Identified sessions where credential lease was renewed (potential flag for review) versus clean single-use issuance

---

## Key Concepts Demonstrated

- **JIT Access Architecture**: Eliminating standing privilege by issuing time-limited credentials on demand
- **Dynamic Secret Generation**: Using HashiCorp Vault's AD Secrets Engine to generate credentials that never exist persistently
- **Privileged Approval Workflow**: Identity-bound request and approval chain before any credential is issued
- **Automated Credential Revocation**: TTL expiry triggering clean, automatic removal of AD group membership and credential rotation
- **Session Recording & Forensics**: Full audit trail of all activity performed during a privileged session
- **Break-Glass Procedure**: Emergency access designed with minimal footprint and maximum auditability
- **Blast Radius Reduction**: Compromised JIT credentials are already expired before they can be weaponised
- **Least Privilege by Design**: Access scoped to the minimum privilege level for the specific task only

---

## Tools & Technologies

![HashiCorp Vault](https://img.shields.io/badge/HashiCorp_Vault-000000?style=flat-square&logo=vault&logoColor=white)
![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-003087?style=flat-square&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare_Access-F38020?style=flat-square&logo=cloudflare&logoColor=white)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: JIT Access Log · Vault Audit Trail · Session Recording Archive · Revocation Evidence · GitHub Repo

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
