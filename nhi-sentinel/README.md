<h1 align="center">NHI-Sentinel: Non-Human Identity & Workload Auditor</h1>

<p align="center">
  <em>Python · Microsoft Graph API · Okta API · TruffleHog · PostgreSQL</em>
</p>

---

## Project Overview

Most IAM programs focus entirely on human users, but **Non-Human Identities (NHI)** such as service accounts, API keys, bots, and automation credentials are often the largest and least-governed identity population in any enterprise. They don't log in via MFA, they don't get offboarded when a project ends, and they rarely appear in access reviews.

**NHI-Sentinel** is an automated auditing tool that discovers, inventories, and continuously monitors non-human identities across cloud and SaaS environments. It surfaces **Shadow Identities** (credentials that exist but aren't tracked), orphaned service accounts, and overprivileged API keys, then produces a structured discovery report with before/after privilege comparisons to support remediation.

---

## Screenshots

> *(Screenshots folder, see repo files above)*

| Screenshot | Description |
|---|---|
| `discovery-report.png` | Full NHI discovery report output, service accounts, API keys and bots catalogued |
| `shadow-identities-flagged.png` | Shadow Identities surfaced, credentials with no owner record |
| `orphaned-accounts.png` | Orphaned service accounts identified after project decommission |
| `before-after-privilege.png` | Before/After privilege comparison following remediation |
| `okta-api-scan.png` | Okta API token scan results, unused and overprivileged tokens |
| `graph-api-output.png` | Microsoft Graph API output, Azure service principal audit |
| `trufflehog-secrets.png` | TruffleHog scan detecting exposed secrets in repos/configs |

---

## Environment

| Component | Detail |
|---|---|
| **Human Identity Platform** | Okta |
| **Cloud Identity Platform** | Microsoft Entra ID (Azure AD) |
| **Secret Scanning** | TruffleHog |
| **API Integration** | Okta API · Microsoft Graph API |
| **Data Store** | PostgreSQL |
| **Scripting** | Python |
| **Output** | Discovery Report (PDF) · Before/After Privilege Comparison |

---

## What Non-Human Identities Look Like

```
Enterprise Identity Population
├── Human Identities  (employees, contractors, admins)
│     └── Governed by: Okta, AD, Entra ID, access reviews
│
└── Non-Human Identities  ← this project
      ├── Service Accounts     (automated processes, scheduled jobs)
      ├── API Keys             (SaaS integrations, CI/CD pipelines)
      ├── Bots                 (RPA agents, automation scripts)
      └── Orphaned Credentials (no owner, no expiry, no review)
            └── These become "Shadow Identities"
```

### Why This Matters

| Risk | Impact |
|---|---|
| **Orphaned service accounts** | Former employees' automation still running with valid credentials |
| **Overprivileged API keys** | Keys granted admin scope that only needed read access |
| **Shadow Identities** | Credentials that exist in systems but appear in no inventory |
| **No expiry policy** | API keys active for years with no rotation or review |
| **Blast radius** | A compromised NHI has no MFA, no session timeout, no behaviour analytics |

---

## What Was Built

### Discovery Engine
- Queried **Okta API** to enumerate all service accounts, API tokens, and non-human app assignments
- Queried **Microsoft Graph API** to catalogue all Azure service principals, managed identities, and app registrations
- Cross-referenced active credentials against HR/offboarding records to surface **orphaned accounts**
- Flagged accounts with no last-login record, no owner, or no linked business justification as **Shadow Identities**

### Secret Scanning (TruffleHog)
- Ran **TruffleHog** scans across internal repositories and configuration files
- Identified hardcoded API keys, tokens, and credentials committed to source control
- Produced a prioritised findings list with remediation recommendations

### Privilege Analysis
- Pulled scope assignments for every Okta API token and Azure service principal
- Compared actual permissions used (last 90 days) against permissions granted
- Generated **Before/After privilege comparison**, documenting over-permission and recommended least-privilege scope

### Reporting & Remediation Support
- Produced a structured **Discovery Report (PDF)** with full NHI inventory, risk ratings, and remediation steps
- Stored findings in **PostgreSQL** for trend tracking and repeat audits
- Documented a repeatable audit runbook for quarterly NHI reviews

---

## Key Concepts Demonstrated

- **Non-Human Identity (NHI) Governance**: Applying IAM principles (least privilege, lifecycle, access reviews) to machine identities
- **Shadow Identity Detection**: Surfacing credentials that exist in systems but are absent from any official inventory
- **Secret Scanning**: Identifying exposed credentials in codebases before they are exploited
- **Cross-Platform Enumeration**: Querying both Okta and Entra ID APIs to build a unified NHI inventory
- **Privilege Right-Sizing**: Comparing permissions granted vs. permissions used to reduce standing access
- **Audit Trail & Reporting**: Structured PDF output suitable for GRC audit evidence

---

## Tools & Technologies

![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Microsoft Graph API](https://img.shields.io/badge/Microsoft_Graph_API-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Okta API](https://img.shields.io/badge/Okta_API-007DC1?style=flat-square&logo=okta&logoColor=white)
![TruffleHog](https://img.shields.io/badge/TruffleHog-555555?style=flat-square)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)
![Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: Discovery Report (PDF) · Before/After Privilege Comparison · GitHub Repo

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
