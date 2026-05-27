# REST API Automation & Bulk Identity Provisioning

**Platform:** Okta | **Tool:** Postman  
**Domain:** Identity & Access Management (IAM) | **Method:** REST API + CSV-Driven Automation

---

## Overview

This project demonstrates how to automate bulk user provisioning in an enterprise Okta tenant using the **Okta Users API** and **Postman's Collection Runner**. Instead of creating identities one by one through the Admin Console, users are provisioned programmatically from a structured CSV data file — simulating how organizations onboard large cohorts of employees during mergers, migrations, or large-scale hiring events.

The lab covers the full lifecycle: API authentication setup, single-user proof-of-concept, troubleshooting authentication errors, and executing a data-driven bulk run that hits a live Okta tenant.

---

## Problem Statement

Manual user provisioning through the Okta Admin Console is slow, error-prone, and unscalable. An organization onboarding dozens or hundreds of users at once needs a repeatable, auditable method to:

- Create user accounts with correct profile attributes
- Enforce password policies from day one (`nextLogin=changePassword`)
- Verify that accounts appear in the directory immediately after creation
- Scale the process through data files rather than manual input

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Okta (Integrator Free Plan)** | Target identity provider — live tenant at `investinindy.com` |
| **Okta Admin Management API** | REST API used for all user lifecycle operations |
| **Postman** | API client for building, testing, and automating requests |
| **Postman Collection Runner** | Executes a collection multiple times against a CSV data file |
| **CSV Data File** (`Okta_Bulk_Import_Test.csv`) | Supplies per-user profile data for each iteration of the bulk run |
| **SSWS API Key** | Authentication mechanism — stored as a Postman environment variable |

---

## Architecture & Flow

```
CSV Data File (user records)
        │
        ▼
Postman Collection Runner
  ├── Iteration 1 → POST /api/v1/users → Okta API → User Created
  ├── Iteration 2 → POST /api/v1/users → Okta API → User Created
  └── Iteration 3 → POST /api/v1/users → Okta API → User Created
                                                        │
                                                        ▼
                                              Okta Admin Console
                                           (People directory updated)
```

---

## Step-by-Step Walkthrough

### Step 1 — Baseline: Existing Okta Tenant

The starting state of the `investinindy.com` Okta tenant had **7 active users** already provisioned through the Admin Console. These serve as the baseline before any API-driven changes.

![Baseline: 7 users in Okta before provisioning](BULK%20provisioning/Screenshot%202026-05-06%20132307.png)

*Okta People directory showing 7 existing active users — Jessy Pears, Paul Andor, Mary Anderson, James Markins, Jonas Miller, Sarah Jackson, and Daniel Awurah.*

---

### Step 2 — Import & Configure the Okta Admin Management API Collection

The official **Okta Admin Management API** Postman collection was imported and connected to the `Investinindy.com` environment. The `POST Create a user` endpoint was configured with the required query parameters:

- `activate=true` — activates the account immediately upon creation
- `provider=false` — uses Okta as the identity store (not an external IdP)
- `nextLogin=changePassword` — forces a password change on the user's first login

![Postman: Create a user endpoint with query parameters](BULK%20provisioning/Screenshot%202026-05-06%20142540.png)

*Postman shows the full Okta API collection on the left and the configured query parameters for the user creation endpoint.*

---

### Step 3 — Build the JSON Request Body

The request body defines the user profile attributes sent to Okta. The `profile` object maps directly to Okta's user schema fields:

```json
{
  "profile": {
    "firstName": "Isaac",
    "lastName": "Woo",
    "email": "isaac@labs.investinindy.com",
    "login": "isaac@labs.investinindy.com",
    "mobilePhone": "555-415-1337"
  },
  "credentials": {
    "password": { "value": "Welcome123!" }
  }
}
```

![Postman: JSON body for user creation](BULK%20provisioning/Screenshot%202026-05-06%20142607.png)

*The raw JSON body with profile fields before parameterizing for bulk use. This template was later replaced with CSV variable references (`{{firstName}}`, `{{lastName}}`, etc.) for the bulk run.*

---

### Step 4 — Configure API Key Authentication

Okta's Admin API uses SSWS (Session Secret Web Services) token authentication. The API key was stored as an **environment variable** (`{{apiKey}}`) to avoid hardcoding secrets in the request. The Authorization tab was set to **API Key**, with the header name `Authorization` and value `SSWS {{apiKey}}`.

The first live test returned **HTTP 200 OK**, confirming that authentication was correctly wired and the API endpoint was reachable.

![Postman: Auth config and first 200 OK response](BULK%20provisioning/Screenshot%202026-05-06%20151110.png)

*Left: The full Okta Admin Management API collection structure. Right: Authorization tab showing SSWS API key, and the response panel showing 200 OK with the created user JSON object (status: `PASSWORD_EXPIRED`).*

---

### Step 5 — Single User Proof of Concept

To validate the full request before running at scale, a single user ("Isaac Woo") was created with a complete body including credentials. The response confirmed:

- **HTTP 200 OK** — request accepted
- **Status: `PASSWORD_EXPIRED`** — forces password change on first login (as configured)
- **User ID assigned** by Okta: `00u12q4gzwabhsIxr698`
- Timestamp fields (`created`, `activated`, `statusChanged`) all populated

![Postman: Full user creation with credentials, 200 OK](BULK%20provisioning/Screenshot%202026-05-06%20151919.png)

*The complete POST request with profile + credentials block, and the full Okta API response confirming successful user creation with status PASSWORD_EXPIRED.*

---

### Step 6 — Verify User Appears in Okta Directory

Immediately after the API call, the Okta Admin Console was checked. **Isaac Woo appeared in the People directory** with "Password expired" status — confirming real-time synchronisation between the API and the directory.

The user count increased from 7 to **8 of 8**, providing direct evidence that the API wrote to the live tenant.

![Okta: User appears in directory after API call](BULK%20provisioning/Screenshot%202026-05-06%20151948.png)

*Okta Admin Console People page showing 8 users. Isaac Woo (isaac@labs.investinindy.com) is newly visible with "Password expired" status — exactly as specified by the API call.*

---

### Step 7 — Verify User Profile Attributes

The Isaac Woo user profile was opened to verify that all API-supplied attributes were correctly written to Okta's user schema — firstName, lastName, username (login), and email.

![Okta: Isaac Woo profile attributes verified](BULK%20provisioning/Screenshot%202026-05-06%20152105.png)

*Okta Profile tab for Isaac Woo confirming username, first name, and last name were accurately mapped from the JSON request body to Okta's user profile schema.*

---

### Step 8 — Configure Collection Runner for Bulk CSV Import

With single-user creation confirmed, the workflow was scaled using **Postman's Collection Runner**:

- Only `POST Create a user` was selected in the run sequence
- **Iterations: 3** (one per user in the CSV file)
- **Test data file:** `Okta_Bulk_Import_Test.csv` — loaded with three new users (Elena Rodriguez, Julian Chen, Marcus Vance), each with their email, firstName, lastName, and password columns
- Advanced settings: Stop run if an error occurs, persist responses for session

![Postman Collection Runner: CSV data file loaded, 3 iterations](BULK%20provisioning/Screenshot%202026-05-07%20150636.png)

*The Collection Runner configured for bulk provisioning. The CSV data file `Okta_Bulk_Import_Test.csv` is loaded as the iteration data source, replacing static values in the request body with per-row user data.*

---

### Step 9 — Troubleshooting: 403 Forbidden Errors

The first bulk run attempt returned **HTTP 403 Forbidden** across all three iterations. Despite the single-request test working, the Runner was failing.

![Collection Runner: 403 errors on all 3 iterations](BULK%20provisioning/Screenshot%202026-05-07%20150734.png)

*All 3 iterations of the Collection Runner return 403. The problem was not with the CSV data or the endpoint — it was an authentication conflict.*

**Root Cause:** The Users folder inside the collection had its authorization set to **"Inherit auth from parent"**, but the parent collection was configured with **OAuth 2.0** (no active token). This overrode the API key auth configured at the request level when running via the Runner.

![Postman: OAuth 2.0 inherited auth causing 403](BULK%20provisioning/Screenshot%202026-05-07%20150945.png)

*The Authorization tab for the Users collection folder shows "Inherit auth from parent" resolving to OAuth 2.0 — which had no valid token, causing 403 errors. Fixed by overriding auth at the request level with the SSWS API key.*

**Fix applied:** The `Create a user` request's Authorization was explicitly set to the SSWS API key, bypassing the folder-level OAuth 2.0 inheritance.

---

### Step 10 — Bulk Run: Success

After resolving the authentication conflict, the Collection Runner was re-executed. All **3 iterations returned HTTP 200 OK**:

- Iteration 1: 200 ✅ — 580ms
- Iteration 2: 200 ✅ — 327ms  
- Iteration 3: 200 ✅ — 334ms
- **Average response time: 414ms**
- **0 errors, 0 failures**

![Collection Runner: All 3 iterations return 200 OK](BULK%20provisioning/Screenshot%202026-05-07%20172153.png)

*The Collection Runner results confirming all 3 bulk user creation requests succeeded with HTTP 200. Three users were provisioned into Okta in under 9 seconds total.*

---

### Step 11 — Final State: All Users in Okta

The Okta Admin Console confirmed the final result: **10 of 10 active users**, with the three CSV-sourced users (Elena Rodriguez, Julian Chen, Marcus Vance) now appearing in the directory with "Password expired" status — ready for first-login password setup.

The **"Active user limit reached"** notification confirms all created users were counted as active in the tenant.

![Okta: 10/10 users after bulk provisioning](BULK%20provisioning/Screenshot%202026-05-07%20172855.png)

*Final state in Okta Admin Console. All 3 bulk-provisioned users (Elena Rodriguez, Julian Chen, Marcus Vance) are visible with Password expired status. The tenant has hit its 10-user active limit — confirming all accounts were successfully activated.*

---

## Key Concepts Demonstrated

| Concept | How It Was Applied |
|---------|-------------------|
| **REST API Authentication** | SSWS API key stored as an environment variable, injected at runtime via `{{apiKey}}` — no hardcoded credentials |
| **Data-Driven Testing / Automation** | CSV file drives user attribute values per iteration — the same Postman request handles any number of users |
| **Idempotency & Error Handling** | Tested failure scenarios (403) and diagnosed the root cause before re-running — not just retrying blindly |
| **Okta User Lifecycle** | Used `activate=true` and `nextLogin=changePassword` to control the exact post-creation state |
| **API Response Validation** | Verified response body fields (id, status, timestamps, profile) and cross-referenced against the Okta Admin Console |
| **Environment Variables** | Postman environment `Investinindy.com` stores `baseUrl` and `apiKey`, making the collection portable and secret-safe |

---

## Challenges & How They Were Solved

### 403 Forbidden on Bulk Run
**What happened:** Single-user requests via the Send button worked, but the Collection Runner returned 403 on every iteration.

**Root cause:** The Users collection folder had `Auth Type: Inherit auth from parent`, and the parent was configured for OAuth 2.0 with no active token. The Runner respects folder-level auth, while manual Send had overridden it locally.

**Resolution:** Explicitly set the `Create a user` request's Authorization to `API Key` with `SSWS {{apiKey}}`, bypassing the inherited OAuth 2.0 setting entirely.

---

## Results

| Metric | Value |
|--------|-------|
| Users provisioned via API | 3 new users (bulk run) + 1 single-user test = **4 total** |
| Okta tenant state | 7 → 10 active users |
| Bulk run success rate | 3/3 iterations — **100%** |
| Average API response time | **414ms** |
| Authentication method | SSWS API key via environment variable |
| Data source | CSV file (`Okta_Bulk_Import_Test.csv`) |

---

## Skills Demonstrated

- Okta Admin Management REST API (Users endpoint)
- API authentication configuration (SSWS / API Key)
- Postman Collection Runner with CSV data files
- Troubleshooting HTTP 403 authorization errors
- User lifecycle management (activate, force password change)
- Identity verification across API and Admin Console
- Environment variable management for credential security

---

## Project Structure

```
bulk-identity-provisioning/
├── README.md                    ← This file
├── whattodo.md                  ← Screenshot inventory and analysis
└── BULK provisioning/
    ├── Okta_Bulk_Import_Test.csv    ← CSV data file (3 users)
    └── Screenshot 2026-05-06 *.png  ← Single user test screenshots
    └── Screenshot 2026-05-07 *.png  ← Bulk run screenshots
```

---

*Lab environment: Okta Integrator Free Plan | Tenant: investinindy-integrator-4637567*
