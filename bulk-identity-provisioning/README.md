<h1 align="center">REST API Automation & Bulk Identity Provisioning</h1>

<p align="center">
  <em>Okta API · Entra ID API · Postman · REST · JSON</em>
</p>

---

## Project Overview

This project demonstrates **programmatic identity lifecycle management** — going beyond the GUI to manage users at scale using REST APIs.

Using **Postman** as the API client, this lab executes bulk user creation, attribute updates, and lifecycle operations (activate, deactivate, delete) directly against the **Okta** and **Microsoft Entra ID** APIs. The goal is to show how an IAM engineer automates repetitive provisioning tasks, troubleshoots failed cycles using API response codes, and manages identities in a way that scales across hundreds or thousands of users.

This is the kind of work that separates an IAM practitioner who knows the UI from one who can **operate and automate identity infrastructure programmatically**.

---

## Environment

| Component | Detail |
|---|---|
| **Primary Platform** | Okta (trial org) |
| **Secondary Platform** | Microsoft Entra ID |
| **API Client** | Postman |
| **Auth Method** | API Key (Okta) · OAuth 2.0 Bearer Token (Entra ID) |
| **Data Format** | JSON |
| **HTTP Methods Used** | GET · POST · PUT · PATCH · DELETE |

---

## How the Okta REST API Works

```
1. Generate an API Token in Okta (or use OAuth 2.0 scoped token)
         ↓
2. Build HTTP request in Postman with:
   - Authorization header: SSWS {api_token}
   - Content-Type: application/json
   - JSON body with user attributes
         ↓
3. Send request to Okta API endpoint
   e.g. POST https://{okta-domain}/api/v1/users
         ↓
4. Okta processes the request and returns:
   - 200/201 → Success
   - 400 → Bad request (malformed JSON / missing field)
   - 401 → Unauthorized (invalid token)
   - 409 → Conflict (user already exists)
         ↓
5. Parse response body to confirm user created / identify failure reason
```

---

## What Was Built

### Bulk User Creation (Okta API)
- Built a **POST** request to `/api/v1/users?activate=true` to create and activate users in a single call
- Structured **JSON payloads** with required profile attributes: `firstName`, `lastName`, `email`, `login`, `department`, `title`
- Created multiple users across different departments to simulate an onboarding batch
- Verified all created users appeared correctly in Okta admin console

### Attribute Manipulation (PUT / PATCH)
- Used **PATCH** `/api/v1/users/{userId}` to update individual attributes (e.g. department change on role move)
- Used **PUT** to perform a full profile replace — simulating a user record correction
- Confirmed attribute updates reflected in the Okta user profile and downstream apps

### Lifecycle Management (Activate / Deactivate / Delete)
- **Activated** staged users via `POST /api/v1/users/{userId}/lifecycle/activate`
- **Deactivated** users via `POST /api/v1/users/{userId}/lifecycle/deactivate` — simulating offboarding
- **Deleted** deactivated users via `DELETE /api/v1/users/{userId}`
- Demonstrated the **two-step delete requirement** Okta enforces (deactivate first, then delete)

### Bulk Operations via Postman Collections
- Organised all requests into a **Postman Collection** with logical folders: Create · Update · Lifecycle · Query
- Used **Postman environment variables** to store `base_url` and `api_token` — avoiding hardcoded secrets in requests
- Added **test scripts** in Postman to auto-validate response status codes after each request

### Entra ID API (Microsoft Graph)
- Authenticated using **OAuth 2.0 client credentials flow** to obtain a Bearer token from Microsoft identity platform
- Used **Microsoft Graph API** `POST /v1.0/users` to create users in Entra ID
- Used `PATCH /v1.0/users/{id}` to update user attributes
- Compared the Okta and Entra ID API patterns — highlighting differences in auth, schema, and response structure

### Troubleshooting Failed Provisioning Cycles
- Intentionally triggered common errors:
  - `400` — missing required field in JSON payload
  - `409` — duplicate login/email conflict
  - `401` — expired or invalid API token
- Documented each error, interpreted the response body, and applied the correct fix
- Built a **troubleshooting reference table** (see below)

---

## Troubleshooting Reference

| Error Code | Cause | Fix |
|---|---|---|
| `400 Bad Request` | Missing required field or malformed JSON | Check JSON body — ensure `login`, `email`, `firstName`, `lastName` are present |
| `401 Unauthorized` | Invalid or expired API token | Regenerate API token in Okta admin → Security → API |
| `403 Forbidden` | Token lacks required scope/permission | Assign correct OAuth scopes or check admin role |
| `404 Not Found` | Wrong userId or endpoint path | Verify user ID with GET request first |
| `409 Conflict` | User with that login/email already exists | Search for existing user before creating |
| `429 Too Many Requests` | Rate limit exceeded | Implement request throttling / retry with backoff |

---

## Screenshots

> *(Screenshots folder — see repo files above)*

| Screenshot | Description |
|---|---|
| `postman-collection.png` | Postman collection showing all organised API requests |
| `bulk-create-request.png` | POST request with JSON payload for user creation |
| `create-success-201.png` | 201 response confirming user created in Okta |
| `okta-users-created.png` | Okta admin console showing bulk-created users |
| `patch-attribute-update.png` | PATCH request updating user department |
| `deactivate-delete.png` | Lifecycle deactivation and deletion flow |
| `error-409-conflict.png` | 409 conflict response and resolution |
| `entra-graph-create.png` | Microsoft Graph API user creation in Entra ID |
| `bearer-token-auth.png` | OAuth 2.0 token obtained for Entra ID API auth |

---

## Key Concepts Demonstrated

- **API-driven identity management** — provisioning and lifecycle operations without touching the GUI
- **JSON payload construction** — building correctly structured request bodies for user creation and updates
- **HTTP method semantics** — understanding when to use POST vs PUT vs PATCH vs DELETE
- **API authentication patterns** — API key (Okta SSWS) vs OAuth 2.0 Bearer token (Entra ID / Graph)
- **Error handling & troubleshooting** — interpreting status codes and response bodies to diagnose failures
- **Postman collections & environments** — organising API workflows and securing credentials with variables
- **Scale mindset** — approaching identity operations as automatable, repeatable processes rather than manual tasks

---

## Tools & Technologies

![Okta](https://img.shields.io/badge/Okta_API-007DC1?style=flat-square&logo=okta&logoColor=white)
![Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID_(Graph_API)-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=flat-square&logo=postman&logoColor=white)
![REST](https://img.shields.io/badge/REST_APIs-555555?style=flat-square)
![JSON](https://img.shields.io/badge/JSON-000000?style=flat-square&logo=json&logoColor=white)
![OAuth](https://img.shields.io/badge/OAuth_2.0-555555?style=flat-square)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: Postman collection exports, JSON payloads, and console screenshots available in this repository.

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
