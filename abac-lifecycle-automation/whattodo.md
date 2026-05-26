# ABAC Screenshot Plan

This file maps all 17 available screenshots to the detail page narrative, selects the best ones to use, and specifies exactly what to highlight in each image before publishing.

---

## Full Screenshot Inventory (All 17)

| File | Time | What It Shows | Use? |
|---|---|---|---|
| `Screenshot 2026-05-18 151523.png` | 3:15 PM | Okta Add Rule — IT Department Rule configured, no preview test yet | Skip — redundant with 151801 |
| `Screenshot 2026-05-18 151711.png` | 3:17 PM | Okta Add Rule — red "User doesn't match rule" banner, James Markins in preview | **KEEP** — proof the rule failed before AD was set |
| `Screenshot 2026-05-18 151801.png` | 3:18 PM | Okta Add Rule — same rule, empty preview (reset after failure) | Skip — duplicate of 151523 |
| `Screenshot 2026-05-18 152113.png` | 3:21 PM | Okta user profile for James Markins, Profile tab, "Profile sourced by Active Directory" — only name attributes visible, no department shown | Skip — diagnostic step only, department not visible to viewer |
| `Screenshot 2026-05-18 152350.png` | 3:23 PM | ADUC — James Markins Properties, Organization tab, Department field being filled in as "IT", IT Staff OU visible in left tree | **KEEP** — shows the root fix: setting the source attribute |
| `Screenshot 2026-05-18 153517.png` | 3:35 PM | Okta Edit Rule — green "User matches rule" banner, James Markins in preview, rule confirmed working after AD sync | **KEEP** — the green confirmation after the fix |
| `Screenshot 2026-05-18 154019.png` | 3:40 PM | Okta Edit Rule — same as 153517, slightly wider view, rule confirmed | Skip — redundant with 153517 |
| `Screenshot 2026-05-18 154651.png` | 3:46 PM | ADUC — James Markins Properties fully filled: Department = IT, Job Title = "Asistant IAM Manager", Company = Investinindy, IT Staff OU selected | Skip — 152350 is more dynamic (shows the attribute being set); use this only if a clean final AD state is needed |
| `Screenshot 2026-05-18 162710.png` | 4:27 PM | Okta Admin > Target SaaS App (SCIM Lab) > Assignments tab — app assigned to Okta-Dynamic-IT group at Priority 1 | **KEEP** — birthright provisioning proof: app wired to group, not individual users |
| `Screenshot 2026-05-18 163235.png` | 4:32 PM | Split screen: Left = James Markins inside Okta-Dynamic-IT group People tab, "Managed: By rule IT Department Rule". Right = James' My Apps showing 5 apps including Target SaaS App (SCIM Lab) | **KEEP** — most important screenshot: proves automation worked end-to-end |
| `Screenshot 2026-05-18 163758.png` | 4:37 PM | Split screen: Left = Okta-Dynamic-IT group, People tab "Showing 0 of 0 — no members". Right = James' My Apps showing 4 apps, no SCIM app | Skip — near-duplicate of 163820 |
| `Screenshot 2026-05-18 163820.png` | 4:38 PM | Same as 163758 — group empty, James has 4 apps | Skip — duplicate |
| `Screenshot 2026-05-18 163820 - Copy.png` | 4:38 PM | Exact copy of 163820.png (file copy, same content) | Skip — literal duplicate file |
| `Screenshot 2026-05-18 171059.png` | 5:11 PM | PowerShell script running Move-ADObject, Mary Anderson Properties open (Department: IT), Mary in root Users OU | Skip — midpoint of automation; 171633 shows the result |
| `Screenshot 2026-05-18 171410.png` | 5:14 PM | Mary Anderson Properties, Organization tab (Department: IT), ADUC showing Mary still in root Users container | Skip — setup step; 171633 shows the outcome |
| `Screenshot 2026-05-18 171609.png` | 5:16 PM | Same PowerShell script, slightly different view — Mary Anderson Properties (Department: IT) + script output "Automation Triggered: Moving Mary Anderson to IT Staff OU..." | Skip — midpoint; 171633 is the conclusive shot |
| `Screenshot 2026-05-18 171633.png` | 5:17 PM | PowerShell complete, ADUC with IT Staff OU selected showing both James Markins and Mary Anderson listed as members | **KEEP** — Mover/Joiner automation result for second user |

---

## Selected Screenshots and Narrative Order

Six screenshots were selected. Together they tell a clean, sequential story from attribute setup through end-to-end provisioning.

---

### Step 1 — Setting the Source Attribute (The Trigger)

**File:** `Screenshot 2026-05-18 152350.png`
**Rename to:** `01-ad-department-attribute-set.png`

**What it shows:**
Active Directory Users and Computers on Windows Server 2022. The OU tree on the left shows `lab.investinindy.com > InvestInIndy > Users`, with IT Staff, Executive, and Operations OUs visible. James Markins Properties is open on the Organization tab. The Department field shows "IT" being typed in (cursor in the field), Job Title and Company are still empty. James and Mary Anderson are listed in the root Users container.

**How it supports the detail page:**
This is the starting point of the entire ABAC chain. It shows that the department attribute in AD is the input that drives all downstream access decisions. Without this attribute set correctly, the rule cannot match the user. This validates the README's claim that Active Directory is the source of truth and that HR-sourced attributes control access.

**Highlight section:**
- Box the `Department` field with "IT" being typed — this single field is what drives the entire automated workflow
- Box the `IT Staff` OU in the left-hand tree — this shows where users with `Department = IT` are expected to live and signals the OU structure used in the automation

---

### Step 2 — The Rule Fails First (Showing Why It Matters)

**File:** `Screenshot 2026-05-18 151711.png`
**Rename to:** `02-rule-fails-before-sync.png`

**What it shows:**
Okta Admin Console, Groups section, Add Rule dialog for the "IT Department Rule." The rule is fully configured: IF `department | string` Equals `IT` THEN Assign to `Okta-Dynamic-IT`. The Preview field shows "James Markins" typed in. The result is a red banner at the top: "User doesn't match rule." This was captured before the Department attribute was set in AD, while the rule logic was correct but Okta had not yet received the attribute via sync.

**How it supports the detail page:**
This is the most instructive screenshot in the set. It shows that the ABAC policy logic was correct from the start — the failure was a data problem, not a configuration problem. It makes visible why accurate, timely attribute management matters in an ABAC model: no attribute, no access.

**Highlight section:**
- Box the red "User doesn't match rule" banner at the top — the visual failure state, which is the whole point of this screenshot
- Box the IF condition row: `User attribute | department | string | Equals | IT` — show the viewer what the rule is checking
- Box "James Markins" in the Preview field — anchors the failure to a real identity

---

### Step 3 — The Rule Confirms After Sync (Validation)

**File:** `Screenshot 2026-05-18 153517.png`
**Rename to:** `03-rule-confirmed-after-sync.png`

**What it shows:**
Okta Admin Console, Groups section, Edit Rule dialog for the same "IT Department Rule." Same rule configuration as Step 2. The Preview field shows "James Markins." This time the result is a green banner: "User matches rule." This was captured after the Department attribute was set in AD (Step 1) and the Okta AD sync cycle completed.

**How it supports the detail page:**
This completes the before-and-after across Steps 2 and 3. It proves that once the correct attribute exists in AD and syncs to Okta, the rule fires correctly with no manual intervention. This is the ABAC engine doing its job.

**Highlight section:**
- Box the green "User matches rule" banner — the direct contrast to the red banner in Step 2
- Box the IF condition row again — makes clear the rule did not change, only the underlying data did
- Box the Preview: "James Markins" — confirms the match is for the right identity

---

### Step 4 — SCIM App Assigned to Group (Birthright Provisioning Setup)

**File:** `Screenshot 2026-05-18 162710.png`
**Rename to:** `04-scim-app-group-assignment.png`

**What it shows:**
Okta Admin Console, Applications section, Target SaaS App (SCIM Lab) detail page, Assignments tab. The Filters pane shows "Groups" selected. The assignment table shows one entry: Priority 1, assigned to the group `Okta-Dynamic-IT`. The app status shows Active. There are also links for "View Logs" and "Monitor Imports."

**How it supports the detail page:**
This is the provisioning layer. It shows that the SCIM app is not assigned to individual users — it is assigned to the `Okta-Dynamic-IT` group. Any user who lands in that group via the ABAC rule automatically receives this app through SCIM provisioning. This validates the README's claim about birthright application assignment and SCIM-based downstream provisioning.

**Highlight section:**
- Box the `Okta-Dynamic-IT` group entry in the Assignments table — this is the link between group membership and app access
- Box the `Priority 1` label next to it — signals this is the primary automated assignment, not a manual override
- Box the Filters pane showing "Groups" selected — distinguishes group-based assignment from individual assignment, which is the key architectural point

---

### Step 5 — End-to-End Result: James Provisioned by Rule (Joiner Complete)

**File:** `Screenshot 2026-05-18 163235.png`
**Rename to:** `05-joiner-result-full.png`

**What it shows:**
Split screen. Left panel: Okta Admin Console, Okta-Dynamic-IT group, People tab. "Showing 1 of 1." James Markins / Jmarkins@investinindy.com listed with Status: Active and Managed: "By rule IT Department Rule" (clickable link). Right panel: James' Okta My Apps dashboard (logged in as James in an InPrivate browser window). Five apps are provisioned under Work: Fileshare, HubSpot SWA, Salesforce.com, Google, and Target SaaS App (SCIM Lab).

**How it supports the detail page:**
This is the proof screenshot for the entire Joiner flow. The left side confirms James entered the group automatically through the ABAC rule, not through manual admin assignment. The right side confirms that all five birthright apps were provisioned, including the SCIM-connected app. Together they show the complete chain: AD attribute → Okta group rule → group membership → app provisioning.

**Highlight section:**
- Left panel: box the "Managed: By rule IT Department Rule" text — this is the evidence that no admin touched the assignment
- Left panel: box "Showing 1 of 1" — shows the rule is actively maintaining one member in the group
- Right panel: box the "Target SaaS App (SCIM Lab)" icon — this is the 5th app, provisioned via SCIM, which would not exist without the group membership

---

### Step 6 — Second User Moved by Automation (Mover / Scalability Proof)

**File:** `Screenshot 2026-05-18 171633.png`
**Rename to:** `06-mover-powershell-result.png`

**What it shows:**
Split/composite view. A PowerShell terminal shows the output line "Automation Triggered: Moving Mary Anderson to IT Staff OU..." confirming the script completed successfully. The ADUC window shows the IT Staff OU selected in the left tree. In the right panel, two users are listed in the IT Staff OU: James Markins and Mary Anderson. Mary Anderson's Properties dialog shows Department: IT, Organization tab.

**How it supports the detail page:**
This screenshot demonstrates that the automation scales beyond the first user. A second employee (Mary Anderson) with Department = IT was processed by the PowerShell automation script, which detected her department attribute and moved her to the correct OU. Once in the IT Staff OU and with the correct attribute, the same ABAC group rule would pick her up on the next sync and provision her access identically. This validates the Mover scenario described in the README.

**Highlight section:**
- Box the PowerShell output line "Automation Triggered: Moving Mary Anderson to IT Staff OU..." — this is the machine-readable proof of the automation executing
- Box both "James Markins" and "Mary Anderson" in the IT Staff OU user list — shows two users now correctly placed by attribute-driven logic, not by manual OU assignment
- Box the `Department: IT` field in Mary Anderson's Properties dialog — confirms the same attribute pattern applies to the second user

---

## Highlight Summary

| Step | File | What to Box |
|---|---|---|
| 1 | `01-ad-department-attribute-set.png` | Department field ("IT" being typed) + IT Staff OU in left tree |
| 2 | `02-rule-fails-before-sync.png` | Red "User doesn't match rule" banner + IF condition row + "James Markins" in Preview |
| 3 | `03-rule-confirmed-after-sync.png` | Green "User matches rule" banner + IF condition row + "James Markins" in Preview |
| 4 | `04-scim-app-group-assignment.png` | Okta-Dynamic-IT group in assignment table + Priority 1 label + Groups filter |
| 5 | `05-joiner-result-full.png` | "Managed: By rule IT Department Rule" (left) + Target SaaS App (SCIM Lab) icon (right) |
| 6 | `06-mover-powershell-result.png` | PowerShell output line + both users in IT Staff OU list + Department: IT in Properties |

---

## Screenshots Still Needed for a Complete Story

The selected six screenshots cover the Joiner and partial Mover. The following are still missing if the full JML narrative is to be shown:

| What to Capture | Maps to README Section |
|---|---|
| Okta Admin > Directory Integrations > AD Agent status showing Active sync | Okta AD Agent Attribute Sync |
| Okta System Log or App Provisioning log showing a SCIM create event for James | SCIM Provisioning and Downstream App Lifecycle |
| AD account with disabled flag set or Okta user deactivated (Leaver scenario) | End-to-End Validation (Leaver) |
