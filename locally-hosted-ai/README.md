<h1 align="center">Locally Hosted AI for Enterprise (Air-Gapped LLM)</h1>

<p align="center">
  <em>Ollama · Hugging Face · Local Inference · AI Governance Policy</em>
</p>

---

## Project Overview

Most enterprises are adopting AI tools — but sending internal data to public AI endpoints (ChatGPT, Claude, Gemini) creates significant **data privacy, compliance, and IP leakage risks**. This project demonstrates how to deploy a **self-hosted, air-gapped Large Language Model (LLM)** for internal enterprise use, keeping all data on-premises while enforcing identity-based access controls and a documented AI governance policy.

The goal is to give a security-conscious organisation the productivity benefits of AI without the risk of confidential data leaving the network.

---

## Screenshots

> *(Screenshots folder — see repo files above)*

| Screenshot | Description |
|---|---|
| `ollama-running.png` | Ollama server running locally — model loaded and responding |
| `model-inference.png` | Local LLM responding to internal enterprise query |
| `access-control-config.png` | Identity-based access controls restricting who can query the model |
| `network-isolation.png` | Network configuration confirming no external AI API calls |
| `ai-governance-policy.png` | AI usage and governance policy document |
| `architecture-diagram.png` | Full architecture — local inference stack with access controls |

---

## Environment

| Component | Detail |
|---|---|
| **Inference Engine** | Ollama |
| **Model Source** | Hugging Face (self-hosted weights) |
| **Deployment** | Local server / on-premises VM |
| **Access Control** | Identity-based access — restricted to authorised internal users |
| **Network** | Air-gapped — no outbound calls to public AI endpoints |
| **Governance** | AI Usage Policy · Acceptable Use Guidelines · Risk Controls |

---

## Why Air-Gapped AI Matters

```
Standard Enterprise AI Adoption (Risky)
─────────────────────────────────────────
Employee → Public AI API (ChatGPT/Claude)
             └── Sends: Internal docs, PII, source code,
                        financial data, client records
             └── Risk:  Data stored externally, used for training,
                        visible to vendor, potential breach

Air-Gapped AI (This Project)
─────────────────────────────────────────
Employee → Local LLM (Ollama on-prem)
             └── Sends: Internal queries
             └── Data:  Never leaves the network
             └── Risk:  Governed by internal access controls and policy
```

### Risk Comparison

| Risk | Public AI API | Locally Hosted AI |
|---|---|---|
| Data leaves the network | Yes | No |
| Vendor data retention | Yes (varies by policy) | No |
| Compliance (HIPAA / SOC 2 / GDPR) | Difficult | Achievable |
| Access control enforcement | None | Full (identity-based) |
| IP / confidential data exposure | High | Eliminated |
| Auditability | Limited | Full |

---

## What Was Built

### Local LLM Deployment (Ollama)
- Installed and configured **Ollama** on a local server/VM
- Pulled and hosted open-source model weights from **Hugging Face**
- Validated model inference entirely on local hardware — no outbound network calls to any public AI API
- Tested response quality and latency for internal enterprise use cases (document summarisation, policy Q&A, report drafting)

### Identity-Based Access Controls
- Restricted access to the local AI endpoint — only authorised internal users can query the model
- Documented access tiers: who can use the model, what data types are permitted, and what use cases are approved
- Applied least-privilege principles to the AI system consistent with the organisation's broader IAM framework

### Network Isolation
- Configured the deployment environment to prevent outbound connections to external AI APIs
- Validated air-gap with network traffic monitoring — confirmed all inference stays local

### AI Governance Policy
- Drafted an **AI Usage Policy** covering:
  - Approved use cases and prohibited inputs (PII, financial data, client records)
  - User responsibilities and acceptable use guidelines
  - Data classification rules for AI interactions
  - Incident response procedure for AI-related security events
  - Review and update cadence for the policy

---

## Key Concepts Demonstrated

- **Enterprise AI Risk Management** — Identifying and controlling the data privacy and compliance risks of AI adoption
- **Air-Gapped Deployment** — Running AI inference with zero dependency on external cloud APIs
- **AI Governance** — Building policy, controls, and guardrails for responsible AI adoption
- **Identity-Controlled AI Access** — Applying IAM principles to AI system access — who can use it, what they can do, and what's logged
- **Compliance Alignment** — Structuring AI deployment to support HIPAA, SOC 2, GDPR, and internal data classification requirements

---

## Tools & Technologies

![Ollama](https://img.shields.io/badge/Ollama-000000?style=flat-square)
![Hugging Face](https://img.shields.io/badge/Hugging_Face-FFD21E?style=flat-square&logo=huggingface&logoColor=black)
![Local Inference](https://img.shields.io/badge/Local_Inference-555555?style=flat-square)
![AI Governance](https://img.shields.io/badge/AI_Governance_Policy-555555?style=flat-square)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)

---

## Project Status

![Complete](https://img.shields.io/badge/Status-Complete-2ea44f?style=flat-square)

Proof: Architecture Diagram · Screenshots · AI Governance Policy Document

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/danielawurah">Back to Portfolio</a>
</p>
