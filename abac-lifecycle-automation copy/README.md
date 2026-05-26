<h1 align="center">Enterprise ABAC & Lifecycle Automation</h1>

<p align="center">
  <em>Okta · Active Directory · ABAC · SCIM · PowerShell · JML Lifecycle</em>
</p>

---

## Project Overview

This project implements a **Zero-Touch Joiner-Mover-Leaver (JML) automation** pipeline that maps HR-sourced user attributes to dynamic group memberships in Okta, which drive automatic **Birthright Access provisioning and revocation** across connected applications.

When a new employee joins, their AD attributes (department, job title, location) automatically place them into the correct Okta groups, which grant app access instantly with no manual ticket. When an employee changes role (Mover) or leaves (Leaver), attribute changes trigger real-time group recalculation and access revocation. No standing access lingers.

This is the **identity lifecycle backbone** that underpins every other IAM project in this portfolio. It determines who has access, to what, and for how long.

---

## Screenshots

> *(Upload your screenshots to this folder and they will render below)*

| Screenshot | Description |
|---|---|
| `01-ad-user-attributes.png` | AD user with department, title, and location attributes populated |
| `02-okta-ad-agent-sync.png` | Okta AD Agent running, users and attributes syncing from AD |
| `03-okta-group-rule-config.png` | ABAC group rule configured in Okta, expression matching on user attributes |
| `04-group-rule-active.png` | Group rule status active, users automatically placed into group |
| `05-birthright-app-assignment.png` | Application auto-assigned to user via group membership, no manual action needed |
| `06-mover-attribute-change.png` | AD attribute updated (department change), triggering group recalculation |
| `07-mover-access-updated.png` | User removed from old group, added to new group, apps updated automatically |
| `08-leaver-account-disabled.png` | AD account disabled, Okta session terminated and all app access revoked |
| `09-scim-provisioning-log.png` | SCIM provisioning log showing downstream app receiving the lifecycle event |
| `10-audit-trail.png` | Okta System Log showing full audit trail of provisioning and deprovisioning events |

---

## Environment

| Component | Detail |
|---|---|
| **Identity Platform** | Okta (trial org) |
| **Directory** | Active Directory (on-premises, Windows Server) |
| **Sync Mechanism** | Okta AD Agent for attribute sync from AD to Okta |
| **Access Control Model** | ABAC (Attribute-Based Access Control) via Okta Group Rules |
| **Provisioning Protocol** | SCIM 2.0 for downstream app provisioning |
| **Automation** | PowerShell for AD attribute manipulation and lifecycle simulation |
| **Source of Truth** | Active Directory, HR attributes drive all access decisions |

---

## How JML Lifecycle Automation Works

```
Traditional Manual Model (What this replaces):
────────────────────────────────────────────────
IT ticket raised → Admin manually creates account → Admin manually assigns apps
Leaver: ticket raised → Admin manually disables account → Apps cleaned up (maybe)
Risk: Provisioning delay, missed deprovisioning, orphaned accounts, audit failures

Zero-Touch ABAC Model (What this builds):
────────────────────────────────────────────────
HR updates AD attribute → Okta detects change → Group rule re-evaluates
→ User added/removed from group → App access granted/revoked automatically
Risk eliminated: No manual steps, no delay, no orphaned access
```

### Full Lifecycle Flow

```
JOINER
──────
1. New employee created in Active Directory
         ↓
2. HR populates attributes: department="Engineering", title="Analyst", location="Indiana"
         ↓
3. Okta AD Agent syncs user and attributes into Okta
         ↓
4. Okta evaluates Group Rules against the new user's attributes
         ↓
5. User automatically placed into: "Engineering-Team", "Indiana-Office", "Analyst-Role"
         ↓
6. Groups trigger app assignments, user receives Birthright Access to all entitled apps
         ↓
7. SCIM pushes account creation to downstream apps (e.g., Salesforce, Slack, internal tools)
         ↓
8. User logs in on Day 1 and everything is already there

MOVER
─────
1. Employee promoted, AD attribute updated: title="Senior Analyst"
         ↓
2. Okta AD Agent syncs the attribute change
         ↓
3. Okta re-evaluates group rules, user removed from "Analyst-Role", added to "Senior-Analyst-Role"
         ↓
4. App assignments recalculate, new apps granted and old apps revoked automatically
         ↓
5. Audit trail records the change with old/new values and timestamp

LEAVER
──────
1. Employee exits, AD account disabled by HR/IT
         ↓
2. Okta AD Agent detects disabled status, Okta account deactivated
         ↓
3. All active Okta sessions terminated immediately
         ↓
4. All group memberships cleared, all app assignments revoked
         ↓
5. SCIM deprovisions user from all downstream apps
         ↓
6. Audit log captures full deprovisioning chain, evidence for access review
```

---

### Key Terms

| Term | Meaning |
|---|---|
| **JML** | Joiner-Mover-Leaver, the three lifecycle events every identity program must handle |
| **ABAC** | Attribute-Based Access Control, access decisions driven by user attributes rather than manual role assignment |
| **Birthright Access** | The baseline set of apps every employee in a given role automatically receives on Day 1 |
| **Group Rule** | Okta logic engine that evaluates user attributes and auto-assigns users to groups using expressions |
| **SCIM** | System for Cross-domain Identity Management, a protocol for automated provisioning to downstream apps |
| **Okta AD Agent** | Component installed on-prem to sync AD users, attributes, and group data into Okta in real time |
| **Attribute Sync** | AD attribute changes (department, title, status) flow to Okta and trigger group recalculation |
| **Orphaned Account** | An account that retains access after the user has left. ABAC automation eliminates these. |
| **Least Privilege** | Users hold only the access their current attributes entitle them to, with no excess and no accumulation |

---

## What Was Built

### Active Directory Attribute Structure
- Created test users in AD with structured attributes: `department`, `title`, `l` (location), `employeeType`
- Used **PowerShell** to simulate lifecycle events:
  - New hire creation with full attribute set
  - Mover simulation via attribute update (department/title change)
  - Leaver simulation via account disable
- Structured OUs to reflect real HR org hierarchy

```powershell
# Example: Simulate a Joiner
New-ADUser -Name "Jane Smith" `
  -SamAccountName "jsmith" `
  -Department "Engineering" `
  -Title "Analyst" `
  -Office "Indiana" `
  -Enabled $true `
  -AccountPassword (ConvertTo-SecureString "P@ssword123!" -AsPlainText -Force)

# Example: Simulate a Mover (attribute update)
Set-ADUser -Identity "jsmith" -Title "Senior Analyst" -Department "Engineering-Senior"

# Example: Simulate a Leaver (disable account)
Disable-ADAccount -Identity "jsmith"
```

### Okta AD Agent Attribute Sync
- Installed and configured the **Okta AD Agent** on the domain controller
- Configured attribute mapping, mapped AD fields (`department`, `title`, `l`) to Okta user profile attributes
- Verified real-time sync, attribute changes in AD reflected in Okta within the agent sync interval
- Confirmed user import with full attribute population in Okta dashboard

### ABAC Group Rules Access Policy Engine
- Built **Okta Group Rules** using expression language targeting user profile attributes
- Example rules configured:

| Rule Name | Expression | Target Group |
|---|---|---|
| Engineering Auto-Assign | `user.department == "Engineering"` | `Engineering-Team` |
| Senior Analyst Auto-Assign | `user.title == "Senior Analyst"` | `Senior-Analyst-Role` |
| Indiana Office Auto-Assign | `user.city == "Indiana"` | `Indiana-Office` |
| Contractor Restrict | `user.employeeType == "Contractor"` | `Contractor-Limited-Access` |

- Rules evaluated automatically on attribute change, no manual group management required
- Groups configured as app assignment vehicles, app access follows group membership

### SCIM Provisioning and Downstream App Lifecycle
- Enabled **SCIM 2.0 provisioning** on connected Okta applications
- Configured provisioning operations: Create, Update, Deactivate
- Verified **push provisioning** on Joiner, downstream app received new account via SCIM
- Verified **attribute push** on Mover, downstream app profile updated on attribute change
- Verified **deprovisioning** on Leaver, downstream app account deactivated when Okta account deactivated

### End-to-End Validation
- **Joiner test**: created AD user → confirmed Okta sync → confirmed group rule fired → confirmed app auto-assigned → confirmed SCIM account created in downstream app
- **Mover test**: updated AD department attribute → confirmed Okta attribute updated → confirmed old group removed, new group added → confirmed app assignments updated
- **Leaver test**: disabled AD account → confirmed Okta account deactivated → confirmed all sessions terminated → confirmed all app access revoked → confirmed SCIM deprovisioning
- Reviewed **Okta System Log**, captured provisioning events, group changes, and SCIM operations for audit evidence

---

## Key Concepts Demonstrated

- **Zero-Touch JML Automation**: Full Joiner-Mover-Leaver lifecycle handled automatically via attribute changes, no IT tickets, no manual provisioning
- **ABAC over RBAC**: Access driven by who the user *is* (attributes), not what role was manually assigned. Eliminates privilege creep.
- **Birthright Access**: Day 1 access provisioned automatically on hire, scoped exactly to role entitlements
- **Least Privilege Enforcement**: Attribute changes immediately recalculate access, users never hold more than their current attributes entitle them to
- **Orphaned Account Elimination**: Leaver flow revokes all access automatically, no manual cleanup, no forgotten accounts
- **SCIM as the Provisioning Layer**: Downstream apps stay in sync with identity source of truth via SCIM, no manual app-by-app administration
- **Audit Readiness**: Every provisioning and deprovisioning event logged in Okta System Log, evidence available for access reviews and compliance audits
- **AD as Source of Truth**: HR-driven attribute changes are the authoritative signal for all access decisions, identity governance starts in the directory

---

## Tools & Technologies

![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![SCIM](https://img.shields.io/badge/SCIM_2.0-555555?style=flat-square)
![ABAC](https://img.shields.io/badge/ABAC-555555?style=flat-square)
![JML](https://img.shields.io/badge/JML_Lifecycle_Automation-555555?style=flat-square)
![Okta AD Agent](https://img.shields.io/badge/Okta_AD_Agent-007DC1?style=flat-square&logo=okta&logoColor=white)
![Okta Group Rules](https://img.shields.io/badge/Okta_Group_Rules-007DC1?style=flat-square&logo=okta&logoColor=white)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: Video walkthrough & runbook available in this repository. Full Joiner, Mover, and Leaver lifecycle tested end-to-end with SCIM provisioning logs and Okta System Log audit trail.

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
