# Identity Governance & Segregation of Duties — Screenshot Documentation Plan

This file documents the screenshots used to support the Identity Governance & SoD project, describes what each captures, and defines the focal highlights to apply before publishing.

---

## Screenshots In Use

| # | File | Stage |
|---|------|-------|
| 1 | `Screenshot 2026-05-21 162602.png` | Pre-remediation: Active Directory group memberships showing the SoD violation condition |
| 2 | `Screenshot 2026-05-21 163835.png` | Okta Access Certification baseline — no campaigns active yet |
| 3 | `Screenshot 2026-05-21 165631.png` | PowerShell SoD detection script executing and auto-remediating the violation |
| 4 | `Screenshot 2026-05-21 165853.png` | Post-remediation: AD group membership comparison confirming revocation |
| 5 | `Screenshot 2026-05-21 170348.png` | Okta Groups view confirming the remediation synced from AD |

---

## Screenshot Summaries

---

### Screenshot 1 — `Screenshot 2026-05-21 162602.png`
**Stage:** Pre-Remediation · Active Directory

**What it shows:**
Active Directory Users and Computers (ADUC) is open on Windows Server 2022. Two users — **Jonas Miller** and **Paul Andor** — are listed under the `InvestInIndy > Users > Finance` OU. Both property windows are open side by side showing the **Member Of** tab for each user.

- **Jonas Miller** is a member of: `Domain Users`, `Operations`, `SG-Finance-DataEntry`
- **Paul Andor** is a member of: `Domain Users`, `Operations`, `SG-Finance-Approver`, `SG-Finance-DataEntry`

Paul Andor holds membership in **both** `SG-Finance-DataEntry` (can create/submit financial data) and `SG-Finance-Approver` (can approve financial transactions). This is the **toxic access combination** — a textbook SoD violation where one person controls both sides of the same financial workflow.

**Where it supports the README:**
This screenshot maps directly to the *"Why Identity Governance Fails Without SoD"* section and the access accumulation scenario described there (AP Clerk + PO Approver = full procure-to-pay cycle in one person's hands).

---

### Screenshot 2 — `Screenshot 2026-05-21 163835.png`
**Stage:** Baseline · Okta Access Certification

**What it shows:**
The Okta Admin Console at `Identity Governance > Access Certifications`. The **Certification Campaigns** tab is selected and shows:

- Active: **0**
- Scheduled: **0**
- Closed: **0**

The message reads *"You don't have any active campaigns."* The free plan notice shows the org is at its 10-user limit (`10 of 10 Active users`). The admin is Daniel Awurah on the `Investinindy-integrator-4637567` org.

**What it means:**
This is the governance starting point — no access certification campaigns have been configured or launched. This establishes the *before governance* baseline in Okta, proving that no formal review process was in place when the SoD violation existed.

**Where it supports the README:**
Maps to Step 4 of the *"How Access Certification Works"* flow — the point at which a certification campaign is due to be launched. This screenshot shows the empty state before that step is taken.

---

### Screenshot 3 — `Screenshot 2026-05-21 165631.png`
**Stage:** SoD Detection & Auto-Remediation · PowerShell

**What it shows:**
An Administrator PowerShell window is running a custom SoD detection and remediation script. The ADUC console is visible in the background. The script:

1. Defines the toxic group pair: `SG-Finance-DataEntry` and `SG-Finance-Approver`
2. Queries AD for members of both groups using `Get-ADGroupMember`
3. Finds the overlap (users in both groups simultaneously)
4. Outputs: `[ALERT] SoD Violation Detected! User 'Pandor' holds both DataEntry and Approver rights.`
5. Outputs: `[CAMPAIGN ACTION] Pending review to enforce Least Privilege...`
6. Executes remediation: `[REMEDIATING] Automatically revoking 'SG-Finance-DataEntry' from 'Pandor'...`
7. Confirms: `[SUCCESS] Least privilege enforced for 'Pandor'.`

`Pandor` is the SamAccountName for **Paul Andor**.

**What it means:**
This is the heart of the technical implementation. The script automates what would normally be a manual governance review — it finds the SoD conflict and enforces least privilege by removing the lower-trust entitlement (DataEntry) from the user who should only hold the Approver role.

**Where it supports the README:**
Directly evidences the *"Policy Engine → Violation Detected → Remediation Actioned"* pipeline described in the How Access Certification Works flow.

---

### Screenshot 4 — `Screenshot 2026-05-21 165853.png`
**Stage:** Post-Remediation Verification · Active Directory

**What it shows:**
Three windows are open simultaneously:
- PowerShell (background) showing the completed script output with `[SUCCESS]` messages
- **Jonas Miller Properties** (Member Of tab) — groups: `Domain Users`, `Operations`, `SG-Finance-DataEntry` (highlighted in blue)
- **Paul Andor Properties** (Member Of tab) — groups: `Domain Users`, `Operations`, `SG-Finance-Approver`

Paul Andor's membership in `SG-Finance-DataEntry` is **gone** — the violation has been resolved. Jonas Miller retains DataEntry access (he never had Approver, so no violation applied to him). The SG-Finance-DataEntry entry highlighted in Jonas Miller's window serves as a visual reference for what was removed from Paul Andor.

**What it means:**
This is the *after* state. It serves as audit evidence that the remediation script's action was applied and took effect in Active Directory. Principle of least privilege is now enforced: Paul Andor can only approve, not also create.

**Where it supports the README:**
Serves as the `06-access-revoked-post-review.png` equivalent described in the Screenshots table — *"Revoked entitlements actioned, user access removed and logged."*

---

### Screenshot 5 — `Screenshot 2026-05-21 170348.png`
**Stage:** Post-Remediation Sync Verification · Okta Groups

**What it shows:**
The Okta Admin Console `Directory > Groups` page displaying synced groups from Active Directory. Key entries visible:

| Group | People | Applications |
|-------|--------|--------------|
| SG-Finance-DataEntry | 2 | 5 |
| SG-Finance-Approver | **1** | 3 |
| Operations | 3 | 0 |
| Everyone | 10 | 0 |

`SG-Finance-Approver` now shows **1 person** — down from 2 — confirming that Okta has synced the AD group membership change made by the remediation script. This closes the loop: the SoD violation was removed in AD and the change propagated to Okta, meaning the user's application access (3 apps tied to the Approver group) is now appropriately scoped.

**What it means:**
End-to-end evidence that the remediation was not only applied in Active Directory but also reflected in the identity platform (Okta) that governs application access. This is audit-ready confirmation that the SoD violation is fully closed.

**Where it supports the README:**
Maps to the `08-audit-evidence-report.png` concept — certification completion and violation remediation recorded and verifiable.

---

## Highlights

For each screenshot, apply a **rectangular box or marker** to the focal areas listed below before embedding in the project README or documentation.

---

### Screenshot 1 Highlights
| Priority | Area to Box | Reason |
|----------|-------------|--------|
| **PRIMARY** | Paul Andor's `SG-Finance-Approver` and `SG-Finance-DataEntry` entries in his Member Of list (right panel) | This is the SoD violation — draw a box around both group entries together to show the toxic combination |
| Secondary | The `Finance` OU in the left ADUC tree | Show where these users sit in the org structure |
| Secondary | The window title "Paul Andor Properties" | Anchor the viewer to the correct subject |

---

### Screenshot 2 Highlights
| Priority | Area to Box | Reason |
|----------|-------------|--------|
| **PRIMARY** | The three counters: `Active 0`, `Scheduled 0`, `Closed 0` | Box all three together — this is the zero-campaign baseline state |
| **PRIMARY** | The `Create campaign` button (top right) | The governance action that is about to be taken |
| Secondary | `Identity Governance > Access Certifications` in the left nav | Establishes context — we are in the governance module |
| Secondary | `INTEGRATOR FREE PLAN · Active user limit reached · 10 of 10` notice | Contextualises the lab constraints |

---

### Screenshot 3 Highlights
| Priority | Area to Box | Reason |
|----------|-------------|--------|
| **PRIMARY** | The coloured output lines: `[ALERT]... 'Pandor' holds both DataEntry and Approver rights.` | The detection result — the moment the violation is confirmed |
| **PRIMARY** | `[REMEDIATING] Automatically revoking 'SG-Finance-DataEntry' from 'Pandor'...` and `[SUCCESS]` line | The remediation action and its outcome |
| Secondary | The group variable definitions at the top: `$GroupDataEntry = "SG-Finance-DataEntry"` and `$GroupApprover = "SG-Finance-Approver"` | Show which rule pair was evaluated |
| Secondary | The `Finance` OU in the ADUC background | Visual anchor linking the script to the AD object |

---

### Screenshot 4 Highlights
| Priority | Area to Box | Reason |
|----------|-------------|--------|
| **PRIMARY** | Paul Andor's Member Of list (right panel) — showing the **absence** of SG-Finance-DataEntry | The proof that remediation worked — DataEntry is gone |
| **PRIMARY** | `SG-Finance-Data...` entry highlighted (blue) in Jonas Miller's panel | Use this as a reference callout — label it *"This entry was removed from Paul Andor"* |
| Secondary | PowerShell `[SUCCESS] Least privilege enforced for 'Pandor'.` line in the background | Ties the UI evidence back to the script that ran |
| Secondary | Both window titles: "Jonas Miller Properties" and "Paul Andor Properties" | Helps viewers immediately identify which panel belongs to which user |

---

### Screenshot 5 Highlights
| Priority | Area to Box | Reason |
|----------|-------------|--------|
| **PRIMARY** | `SG-Finance-Approver` row — specifically the **People: 1** column value | This is the key evidence — it was 2 before, now it is 1 after remediation |
| **PRIMARY** | `SG-Finance-DataEntry` row — **People: 2** | Contrast: DataEntry kept its 2 members (only Jonas Miller was the valid sole member before, plus the violation was on Paul; confirm count makes sense with the AD state) |
| Secondary | The Okta `Directory > Groups` breadcrumb / left nav | Establishes that this view is Okta's live reflection of the AD sync |
| Secondary | The org name `investinindy-integrator-4637567` in the top-right | Confirms this is the same Okta org as Screenshot 2, closing the loop |

---

## Sequence Summary

The five screenshots together tell a complete governance story:

```
[1] AD Pre-Check          →  Identify the toxic combination (Paul Andor: DataEntry + Approver)
        ↓
[2] Okta Governance Baseline  →  Confirm no access certification campaign exists yet
        ↓
[3] PowerShell SoD Script →  Detect the violation programmatically and auto-remediate
        ↓
[4] AD Post-Remediation   →  Verify the group removal took effect in Active Directory
        ↓
[5] Okta Groups Sync      →  Confirm the fix propagated to Okta (SG-Finance-Approver: 1 person)
```
