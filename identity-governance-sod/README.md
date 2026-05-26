<h1 align="center">Identity Governance & Segregation of Duties (SoD)</h1>

<p align="center">
  <em>Okta · Active Directory · SailPoint IdentityNow · Python · PowerShell · SoD Policy Engine</em>
</p>

---

## Project Overview

In most organisations, access accumulates silently. Employees change roles, take on side projects, and inherit permissions — but rarely have anything taken away. Over time, this creates a landscape of **toxic access combinations**, where a single user holds conflicting entitlements that, together, enable fraud, data exfiltration, or insider abuse.

**Identity Governance & Segregation of Duties (SoD)** is the discipline of continuously discovering what access exists, who has it, whether it is appropriate, and whether any combination of entitlements violates a business rule. This project builds a working governance programme from scratch: access certification campaigns, SoD policy enforcement, role mining, entitlement analytics, and a repeatable review workflow that produces audit-ready evidence.

The goal is not just to detect violations — it is to establish a **living access governance programme** that ensures the right people have the right access for the right reasons, continuously.

---

## Screenshots

> *(Upload your screenshots to this folder and they will render below)*

| Screenshot | Description |
|---|---|
| `01-entitlement-inventory.png` | Full entitlement inventory showing all user-app-role assignments catalogued |
| `02-sod-policy-definition.png` | SoD conflict rules defined: which permission pairs constitute a violation |
| `03-sod-violations-detected.png` | Violation report showing users with conflicting entitlements flagged |
| `04-access-certification-campaign.png` | Certification campaign launched, managers reviewing direct reports' access |
| `05-reviewer-decision-ui.png` | Reviewer approving or revoking entitlements inline during the campaign |
| `06-access-revoked-post-review.png` | Revoked entitlements actioned, user access removed and logged |
| `07-role-mining-output.png` | Role mining analysis output, peer group comparison and outlier detection |
| `08-audit-evidence-report.png` | Final governance report exported, certification completion and violation remediation recorded |

---

## Environment

| Component | Detail |
|---|---|
| **Identity Governance Platform** | SailPoint IdentityNow (trial) |
| **Identity Provider** | Okta |
| **Directory** | Active Directory (on-premises) |
| **Provisioning** | Okta AD Agent · SCIM 2.0 |
| **Policy Engine** | SoD Rule Builder (IdentityNow native) |
| **Scripting** | Python · PowerShell |
| **Output** | Access Certification Report · SoD Violation Report · Remediation Log |

---

## Why Identity Governance Fails Without SoD

```
Common Enterprise Access Reality (Before Governance):
──────────────────────────────────────────────────────────
Year 1: User joins Finance team → granted AP Clerk role (can create invoices)
Year 2: User moves to Procurement → keeps AP Clerk role + granted PO Approver role
Year 3: User has no role change on record, but can now:
           - Create a purchase order
           - Approve the same purchase order
           - Create an invoice for it
           - Approve the payment
                    ↓
        This is a SoD violation: full procure-to-pay cycle controlled by one person.
        Fraud risk. Audit finding. Regulatory exposure.

With SoD Governance (What this builds):
──────────────────────────────────────────────────────────
SoD policy flags the conflict the moment it is detected.
Certification campaign surfaces it to the manager for remediation.
One entitlement revoked. Violation closed. Evidence retained.
```

---

## How Access Certification Works

```
1. Governance platform pulls entitlement inventory from all connected systems
         ↓
2. SoD policy engine evaluates all entitlement combinations against defined conflict rules
         ↓
3. Violations flagged and added to the certification campaign queue
         ↓
4. Campaign launched: managers receive review tasks for each direct report's access
         ↓
5. Reviewer approves (access confirmed) or revokes (access removed) each entitlement
         ↓
6. Revocation decision triggers automated deprovisioning via SCIM / API
         ↓
7. Campaign closes: full audit log exported showing decisions, reviewers, timestamps
         ↓
8. SoD violations re-evaluated post-remediation, closure confirmed and recorded
```

### Key Terms

| Term | Meaning |
|---|---|
| **Identity Governance (IGA)** | The discipline of managing and reviewing who has access to what, and enforcing that access is appropriate |
| **Segregation of Duties (SoD)** | A control that prevents any single user from holding conflicting entitlements that together enable fraud or abuse |
| **Access Certification** | A structured review campaign where managers or system owners confirm or revoke user access entitlements |
| **Entitlement** | A specific permission, role, or app assignment held by a user |
| **SoD Violation** | A user who holds two or more conflicting entitlements simultaneously |
| **Role Mining** | Analysing actual entitlement patterns across a user population to identify natural role groupings |
| **Toxic Combination** | A pair (or set) of entitlements that together create a control risk, e.g., create + approve in the same process |
| **Orphaned Access** | Entitlements retained after a lifecycle event (role change, offboarding), never cleaned up |
| **Attestation** | The formal act of a reviewer confirming that a user's access is appropriate and still required |
| **Least Privilege** | The principle that a user should hold only the minimum access required for their current role, nothing more |

---

## What Was Built

### Entitlement Inventory
- Connected **SailPoint IdentityNow** to Active Directory and Okta to aggregate all user-entitlement mappings into a single inventory
- Used **Python** to extract and normalise entitlement data from Okta API (app assignments, group memberships, roles)
- Cross-referenced entitlements against the current HR org chart to flag users whose access no longer reflects their role
- Produced a complete entitlement matrix: every user × every entitlement, with last-used date and business owner

### SoD Policy Engine
- Defined a **SoD conflict matrix** covering the most common toxic combinations in Finance, IT, and HR domains
- Configured conflict rules in IdentityNow's policy engine, e.g.:
  - `Create Invoice` + `Approve Payment` → Violation
  - `Provision Users` + `Approve Provisioning Requests` → Violation
  - `Read Salary Data` + `Modify Payroll Records` → Violation
- Ran the policy engine against the full entitlement inventory, surfacing all current violations with user, entitlement pair, and risk rating

```python
# Example: Evaluate SoD conflicts programmatically
sod_rules = [
    ("Create Invoice",        "Approve Payment"),
    ("Provision Users",       "Approve Provisioning"),
    ("Read Salary Data",      "Modify Payroll Records"),
    ("Submit Expense Report", "Approve Expense Report"),
]

violations = []
for user, entitlements in entitlement_matrix.items():
    for rule_a, rule_b in sod_rules:
        if rule_a in entitlements and rule_b in entitlements:
            violations.append({
                "user": user,
                "conflict": f"{rule_a} + {rule_b}",
                "risk": "Critical"
            })
```

### Access Certification Campaign
- Launched a time-boxed certification campaign in IdentityNow targeting all users with flagged violations plus a sample of high-risk entitlements
- Assigned review tasks to each user's **line manager**, with a 10-day completion window
- Tracked campaign completion rate, reviewer decisions, and pending items in real time
- Automated reminder escalation for overdue reviews

### Remediation & Deprovisioning
- Revocation decisions triggered automated deprovisioning via **Okta API** and **SCIM**
- Used **PowerShell** to remove AD group memberships for on-prem entitlements
- Verified every revocation by re-querying the entitlement inventory post-campaign and confirming removal
- Produced a **remediation log** with before/after entitlement state per user

### Role Mining & Peer Analysis
- Analysed entitlement patterns across job titles and departments to identify natural access groupings
- Surfaced **outliers**: users with entitlements significantly outside their peer group
- Produced a role mining report recommending 8 candidate roles that could replace 40+ individual entitlement assignments
- Documented role definitions and intended population for each candidate role

### Audit Evidence Package
- Exported a **certification completion report** showing: campaign dates, total items reviewed, approval/revocation counts, reviewer names
- Exported **SoD violation closure report** showing: violations detected, remediation action taken, closure date
- All evidence formatted and structured for GRC team or external auditor review

---

## Key Concepts Demonstrated

- **IGA Programme Design**: Building access governance from entitlement inventory through to certification and remediation
- **SoD Policy Enforcement**: Defining and automating conflict detection across Finance, HR, and IT entitlements
- **Access Certification Campaign Management**: Running a structured, time-boxed review with real reviewer decisions
- **Automated Remediation**: Revocation decisions driving real deprovisioning via Okta and SCIM
- **Role Mining**: Using entitlement data to identify natural roles and reduce access sprawl
- **Audit Evidence Production**: Structured reports meeting GRC and regulatory review standards
- **Least Privilege Enforcement**: Removing excess access identified through governance reviews

---

## Tools & Technologies

![SailPoint](https://img.shields.io/badge/SailPoint_IdentityNow-003087?style=flat-square&logo=sailpoint&logoColor=white)
![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-003087?style=flat-square&logo=windows&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)
![SCIM](https://img.shields.io/badge/SCIM_2.0-555555?style=flat-square)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: SoD Violation Report · Access Certification Campaign Evidence · Remediation Log · GitHub Repo

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
