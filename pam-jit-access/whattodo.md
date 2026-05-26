# PAM & JIT Access — Screenshot Documentation Plan

This file maps all 5 available screenshots to the PAM detail page narrative, describes what each captures in context, and defines the exact areas to highlight before publishing.

---

## Full Screenshot Inventory (All 5)

| # | File | Time | What It Shows | Use? |
|---|------|------|---------------|------|
| 1 | `Screenshot 2026-05-25 165046.png` | May 25, 4:50 PM | Okta Groups list — `JIT-Cloud-Admins` shows **0 people** — the privileged group exists but is empty, no standing access | **KEEP** — baseline state before any JIT request |
| 2 | `Screenshot 2026-05-25 143626.png` | May 25, 2:36 PM | Okta Workflows Flow Chart — "Determine if user added to temporary group" pipeline, 14-step automated flow | **KEEP** — the JIT automation engine |
| 3 | `Screenshot 2026-05-25 171414.png` | May 25, 5:17 PM | Okta Workflows Table — "Users Added to Temporary Groups" — 1 record with User ID, Expiration Timestamp, Group ID logged | **KEEP** — the time-bound access ledger / audit log |
| 4 | `Screenshot 2026-05-26 112224.png` | May 26, 11:22 AM | Okta Groups — `JIT-Cloud-Admins` now shows **1 person** — JIT window is ACTIVE, access granted | **KEEP** — proof the access was granted |
| 5 | `Screenshot 2026-05-26 112321.png` | May 26, 11:23 AM | Okta Groups — `JIT-Cloud-Admins` back to **0 people** — expiry passed, access automatically revoked | **KEEP** — proof the access was revoked without manual action |

All 5 screenshots are used. Together they close the complete JIT lifecycle loop.

---

## Screenshot Summaries & Narrative Order

---

### Step 1 — Baseline: Privileged Group Exists with Zero Members
**File:** `Screenshot 2026-05-25 165046.png`

**What it shows:**
Okta Admin Console, `Directory > Groups`. The `JIT-Cloud-Admins` group is at the top of the list with **0 People** and 1 Application. Below it are standard operational groups (`Dev-Team`, `SG-Finance-DataEntry`, `Okta-Dynamic-IT`, etc.) — none of which are privileged admin groups. Timestamp: May 25, 4:50 PM.

**What it means:**
This is the zero-standing-privilege state. The `JIT-Cloud-Admins` group exists and is wired to an application, but nobody is in it. There is no persistent admin account. If an attacker compromised an identity right now, they would find no standing privilege to exploit. This is the core security posture of JIT access.

**Where it supports the README:**
Maps directly to the *"No Standing Privilege"* principle stated in the Project Overview and the JIT Lifecycle flow section.

---

### Step 2 — The Automation Engine: Okta Workflows Flow Chart
**File:** `Screenshot 2026-05-25 143626.png`

**What it shows:**
Okta Workflows interface, Flow Chart tab, for the flow titled **"Determine if user added to temporary group"** inside the folder *"Assign Group Memberships Temporarily Based on Time."* Status badge shows **"Flow Is ON."** The pipeline contains 14 steps:

`User Added to Group` → `Comment` → `Trim` → `Comment` → `Search Rows` → `Comment` → `Continue If` → `Comment` → `Now` → `Comment` → `Add` → `UNIX` → `Comment` → `Create Row`

**What it means:**
This is the JIT policy engine. When a user is added to a privileged group, this flow fires: it looks up any existing access record, evaluates whether the request is valid (`Continue If`), captures the current timestamp (`Now`), calculates the expiry time (`Add` + `UNIX`), and writes the time-bound access record to a table (`Create Row`). The access window is defined entirely in logic, not by a human manually revoking anything later.

**Where it supports the README:**
Evidences the Okta Workflows JIT component described under the Environment table and the JIT Lifecycle flow.

---

### Step 3 — The Access Ledger: JIT Entry Logged with Expiry Timestamp
**File:** `Screenshot 2026-05-25 171414.png`

**What it shows:**
Okta Workflows Tables view, table named **"Users Added to Temporary Groups"** (same folder as the flow). One record is present:

| Field | Value |
|-------|-------|
| rowId | `7657c000-587b-11f1-b532-c...` |
| updated | `5/25/26, 8:51 PM UTC` |
| User ID | `00ui2jkcxw4Ex4fig698` |
| Expiration Time | `1779742571000` (Unix ms → ~8:56 PM UTC May 25) |
| Group ID | `00g13bjelf57wSyWU698` |

The expiry timestamp is 5 minutes after the entry was written — confirming this was a timed-window test with a short lease.

**What it means:**
This is the machine-written audit record. The JIT access window is not tracked in someone's head or a ticket — it is a structured data entry with a cryptographic row ID, a precise expiry, and the identity of both the user and the group. A separate scheduled flow uses this table to check expiry timestamps and remove users when the window closes.

**Where it supports the README:**
This is the equivalent of a Vault lease record — time-bound, machine-managed, audit-ready. Maps to the JIT audit log and the automated revocation chain.

---

### Step 4 — JIT Window Active: Privileged Access Granted
**File:** `Screenshot 2026-05-26 112224.png`

**What it shows:**
Okta Admin Console, `Directory > Groups`, taken on May 26 at 11:22 AM. `JIT-Cloud-Admins` now shows **1 person** and 1 application. A black rectangular box is already drawn in the screenshot around the `JIT-Cloud-Admins` and `Dev-Team` rows, drawing the viewer's eye to the key group. The timestamp at the bottom left of the Okta panel shows *"Updated May 26, 2026, 11:21:56 AM."*

**What it means:**
A JIT access request was processed. The workflow ran, logged the entry, and a user is now inside the `JIT-Cloud-Admins` privileged group. Their elevated access is live — but it has an expiry timestamp attached. This is what "temporary privilege" looks like in practice: the group has exactly one member and the clock is running.

**Where it supports the README:**
This is the *"Credential Issued, Lease Active"* moment — the JIT window is open, the privileged group is populated, the user can act.

---

### Step 5 — Access Window Closed: Auto-Revocation Confirmed
**File:** `Screenshot 2026-05-26 112321.png`

**What it shows:**
Okta Admin Console, `Directory > Groups`, taken one minute later at 11:23 AM. `JIT-Cloud-Admins` is back to **0 people**. Same black rectangular box annotation remains around the group rows. Everything else is unchanged — no other groups were affected. The timestamp shows *"Updated May 26, 2026, 11:23:04 AM."*

**What it means:**
The expiry timestamp in the Workflows table was reached. The companion scheduled flow detected it, removed the user from `JIT-Cloud-Admins`, and the privileged group is empty again — all within a one-minute window shown across Screenshots 4 and 5. No admin manually did anything. The entire grant-and-revoke cycle was automated and happened without a single ticket or manual action.

**Where it supports the README:**
This is the closing evidence of the JIT lifecycle: *"Lease expiry reached, credential automatically revoked."* It is the most important screenshot for a security-focused audience because it proves the revocation is real and automatic, not aspirational.

---

## Highlight Summary

| Step | File | What to Box |
|------|------|-------------|
| 1 | `165046.png` | `JIT-Cloud-Admins` row — specifically **People: 0** — draw attention to the empty privileged group as the desired security state |
| 2 | `143626.png` | The `Continue If` block — this is the policy gate; also box `Flow Is ON` badge in top right to confirm the workflow is live |
| 3 | `171414.png` | The **Expiration Time** column value (`1779742571000`) and the **User ID** and **Group ID** columns — these three fields together are the time-bound access record |
| 4 | `112224.png` | `JIT-Cloud-Admins` row — **People: 1** — box already present; ensure it clearly contrasts with the Step 1 screenshot |
| 5 | `112321.png` | `JIT-Cloud-Admins` row — **People: 0** — same box, same position as Step 4, but the count has dropped back to zero |

---

## Sequence Summary

The five screenshots tell a complete JIT privilege lifecycle story:

```
[1] Baseline           →  JIT-Cloud-Admins exists, 0 members — no standing privilege
        ↓
[2] Automation Engine  →  Okta Workflows flow built: user added → timestamp logged → expiry set
        ↓
[3] Access Ledger      →  Workflows Table entry: User ID + Expiration Timestamp + Group ID written
        ↓
[4] Window Active      →  JIT-Cloud-Admins: 1 person — privileged access granted for the window
        ↓
[5] Auto-Revocation    →  JIT-Cloud-Admins: 0 people — expiry passed, access removed automatically
```
