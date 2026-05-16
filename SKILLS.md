<h1 align="center">Daniel Awurah</h1>

<p align="center">
  <em>Identity & Access Management Specialist &nbsp;·&nbsp; GRC Strategist &nbsp;·&nbsp; Security Advisor</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/B.Sc._Information_Technology-KNUST-1B5E20?style=flat-square&logo=googlescholar&logoColor=white" />
  &nbsp;
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">
    <img src="https://img.shields.io/badge/LinkedIn-daniel--awurah-0A66C2?style=flat-square&logo=linkedin&logoColor=white" />
  </a>
  &nbsp;
  <a href="mailto:awurahdaniel@gmail.com">
    <img src="https://img.shields.io/badge/Email-awurahdaniel%40gmail.com-D14836?style=flat-square&logo=gmail&logoColor=white" />
  </a>
  &nbsp;
  <img src="https://img.shields.io/badge/Location-Carmel%2C_Indiana-555555?style=flat-square" />
</p>

---

> **About**
>
> IAM and GRC professional specializing in **enterprise identity architecture** — designing and governing access controls across **Active Directory, Okta, Microsoft Entra ID, and Cloudflare Zero Trust**. I build identity programs that enforce least privilege, automate the JML lifecycle, and align access governance to frameworks like **NIST CSF, ISO 27001, and SOC 2**.
>
> Currently building out a hands-on IAM homelab portfolio to document real-world configurations in Active Directory, Okta, and Entra ID. Open to entry-level and mid-level IAM and GRC roles where I can contribute, keep learning, and grow within a team.

---

## 01 · Identity & Access Management

| Workflow Project | Proof | Purpose | Stack | Status |
|---|---|---|---|---|
| **SAML Integration with Service Provider (Salesforce)** | Video & Screenshots | Pre-requisite lab establishing foundational SSO configuration before all proceeding identity labs. | Okta · SAML 2.0 · Salesforce | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| **Privileged Access Management (PAM) & Just-in-Time Access** | Screenshots & Video | Implements a JIT access workflow where elevated privileges are requested, approved, and automatically expired — eliminating standing access and reducing blast radius. | Okta · Entra ID · PIM · JIT · Approval Workflow | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| **Enterprise ABAC & Lifecycle Automation** | Video & Runbook | Demonstrates "Zero-Touch" provisioning using Attribute-Based Access Control (ABAC). Automates the full Joiner-Mover-Leaver (JML) lifecycle by mapping HR attributes to dynamic group memberships, ensuring Birthright Access is granted instantly and revoked automatically during role changes. | Okta · Active Directory · ABAC · SCIM · PowerShell | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| **Identity Governance & Segregation of Duties** | Audit Logs & Screenshots | Focuses on mitigating Privilege Creep and Insider Threat risks. Implements a Segregation of Duties (SoD) framework to prevent conflicting access (e.g., Requestor vs. Approver) and conducts a simulated Access Certification campaign to validate and prune elevated permissions per the Principle of Least Privilege. | Okta · SailPoint · Access Reviews · Audit Logs · CSV | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| **REST API Automation & Bulk Identity Provisioning** | Postman Collections · JSON Payloads · Console Screenshots | Demonstrates programmatic identity lifecycle management using REST APIs. Uses Postman to execute bulk user creation, manipulate user attributes via HTTP methods (POST, PUT, PATCH), and leverage API response codes to troubleshoot failed provisioning cycles — bypassing the GUI for scalable operations. | Okta · Entra ID API · Postman · REST APIs · JSON · HTTP Methods | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| **Modern Protocol Mastery (OIDC + PKCE)** | Screenshots | Integrates a custom application (WordPress) using OIDC with PKCE — demonstrating secure authorization code flow without a client secret, suitable for public clients. | Okta · WordPress · OIDC · PKCE · OAuth 2.0 | ![Queued](https://img.shields.io/badge/Queued-888888?style=flat-square) |
| **Ortoorg — Multi-Org Identity Federation** | Screenshots | Configures cross-organization identity federation, demonstrating how users from an external org can authenticate into a target environment without separate credentials. | Okta · Org2Org · Federation · SAML | ![Queued](https://img.shields.io/badge/Queued-888888?style=flat-square) |

### Zero Trust Architecture & Secure Remote Access

| Workflow Project | Proof | Purpose | Stack | Status |
|---|---|---|---|---|
| **Identity-Centric Zero Trust Network Access (ZTNA)** | Architecture Diagram & Screenshots | Eliminates the need for traditional VPNs by implementing a Cloudflare Tunnel to secure internal Active Directory resources. Enforces identity-verified, least-privilege access to internal apps without exposing them to the public internet. | AD · Cloudflare Zero Trust · ZTNA · Cloudflare Tunnel · MFA | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |

---

## 02 · Governance, Risk & Compliance (GRC)

> I approach GRC as a practical discipline — not a checkbox exercise. My focus is on building risk programs that are aligned to recognised frameworks (**NIST CSF, ISO 27001, SOC 2**) and actually usable by the organisations they serve. This means conducting honest gap analyses, building dynamic risk registers, and translating control requirements into clear documentation that holds up under audit.
>
> On the operational side I manage **third-party and supply chain risk**, own the full policy lifecycle from drafting to review, and have delivered compliance advisory across **Healthcare, Fintech, Retail, and Technology** sectors. I also integrate **AI governance** into risk programs — building controls for responsible AI adoption and RAG-based automation — and I treat **human risk** (phishing, social engineering, security culture) as a first-class GRC concern, not an afterthought.

| Capability | Detail | Proof |
|---|---|---|
| **Framework Implementation** | NIST CSF, ISO 27001, SOC 2 — gap analysis, control mapping, audit readiness | [Controls Mapping](https://github.com/danielawurah/grc-security-policies/tree/main/CONTROLS-MAPPING) |
| **Risk Operations** | Enterprise risk assessments, risk quantification, dynamic risk register management | [Risk Assessment Template](https://github.com/danielawurah/grc-security-policies/blob/main/TEMPLATES/risk-assessment-template.xlsx) |
| **Third-Party Risk (TPRM)** | Vendor security reviews, supply chain governance, procurement collaboration | [Exception Request Form](https://github.com/danielawurah/grc-security-policies/blob/main/TEMPLATES/exception-request-form.md) |
| **Policy Lifecycle** | End-to-end security policy development, documentation standards, governance processes | [Global Controls](https://github.com/danielawurah/grc-security-policies/tree/main/GLOBAL-CONTROLS) |
| **Compliance Advisory** | Sector experience across Healthcare, Fintech, Retail, and Technology | [Industry Verticals](https://github.com/danielawurah/grc-security-policies/tree/main/INDUSTRY-VERTICALS) |
| **AI Governance** | Responsible AI controls, RAG system risk management, AI automation policy | [Automated Compliance Guide](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/automated-compliance-guide.md) |
| **Human Risk Management** | Security awareness programs, phishing mitigation, social engineering defense | [Awareness Training Policy](https://github.com/danielawurah/grc-security-policies/blob/main/GLOBAL-CONTROLS/awareness-training.md) |

> Full repository → [danielawurah/grc-security-policies](https://github.com/danielawurah/grc-security-policies)

---

## 03 · Certifications

**Earned**

![CompTIA Security+](https://img.shields.io/badge/CompTIA_Security%2B-FF0000?style=flat-square&logo=comptia&logoColor=white)

![SailPoint](https://img.shields.io/badge/SailPoint_Certified_Identity_Security_Leader-003087?style=flat-square)

![Cybersecurity Ops](https://img.shields.io/badge/Cybersecurity_Risk_%26_Operations_Intensive_(10--Week)-555555?style=flat-square)

![Forage Tata](https://img.shields.io/badge/Cybersecurity_Analyst_Simulation_(Forage_%2F_Tata)-1d4289?style=flat-square)

**In Progress / Queued**

![SC-900](https://img.shields.io/badge/SC--900_Security_%26_Compliance-queued-888888?style=flat-square)
![SC-300](https://img.shields.io/badge/SC--300_Identity_%26_Access_Admin-queued-888888?style=flat-square)
![Okta Pro](https://img.shields.io/badge/Okta_Certified_Professional-queued-888888?style=flat-square)
![AZ-900](https://img.shields.io/badge/AZ--900_Azure_Fundamentals-queued-888888?style=flat-square)

---

## 04 · Education

<p>
  <img src="https://img.shields.io/badge/B.Sc._Information_Technology-KNUST_%2F_GTUC-1B5E20?style=flat-square&logo=googlescholar&logoColor=white" />
  &nbsp;
  <img src="https://img.shields.io/badge/Graduated-2020-555555?style=flat-square" />
</p>

**Kwame Nkrumah University of Science and Technology (KNUST)**
Affiliated Institution: Ghana Technology University College (GTUC) &nbsp;·&nbsp; 2016 – 2020

| | |
|---|---|
| **Degree** | Bachelor of Science — Information Technology |
| **Relevant Coursework** | Systems Design · Network Architecture · Database Management · Operating Systems · Information Security Fundamentals |
| **Leadership** | President, Students' Representative Council (SRC) — led student governance, stakeholder engagement, and campus-wide initiatives |

---

## 05 · Supporting Technical Skills

*Infrastructure and IT foundation that underpins IAM and security work.*

![Windows Server](https://img.shields.io/badge/Windows_Server-0078D4?style=flat-square&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux_%2F_cPanel-FCC624?style=flat-square&logo=linux&logoColor=black)
![Microsoft 365](https://img.shields.io/badge/Microsoft_365-D83B01?style=flat-square&logo=microsoftoffice&logoColor=white)
![Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Cloud Security](https://img.shields.io/badge/Cloud_Security_Governance-0089D6?style=flat-square&logo=microsoftazure&logoColor=white)
![DNS/DHCP](https://img.shields.io/badge/DNS_%2F_DHCP-555555?style=flat-square)
![TCP/IP](https://img.shields.io/badge/TCP%2FIP_Networking-555555?style=flat-square)
![VPS Hardening](https://img.shields.io/badge/VPS_Hardening-555555?style=flat-square)
![Web Dev](https://img.shields.io/badge/Web_Development-555555?style=flat-square)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat-square&logo=mysql&logoColor=white)

---

## 06 · IAM & GRC Project Work

| Project | IAM / GRC Focus | Outcome |
|---|---|---|
| **Cyber GRC Consulting** (Multi-Client) | NIST CSF, ISO 27001, SOC 2 gap analysis · risk register development · TPRM · AI governance | Audit-ready GRC programs delivered across U.S. and African clients |
| **ZeeHost — Identity & Infrastructure** | IAM model design · least privilege enforcement · account lifecycle · incident command | Secure multi-tenant hosting environment with enforced access controls |
| **Zelus Technologies — AppSec & IAM** | AuthN/AuthZ architecture · OWASP Top 10 mitigation · SSDLC · vCISO advisory · Entra ID app registrations | Embedded identity and access controls into client SaaS products |
| **Smart Campus — RBAC & Privacy by Design** | Granular RBAC for multi-role SaaS · SoD enforcement · PII data governance · Entra ID Conditional Access | Secure school management platform with compliant data handling |
| **Imperial Communications — Risk Advisory** | Digital asset audits · credential theft prevention · Entra ID governance · cloud security policy | Hardened client digital footprint and reduced human risk exposure |

---

<p align="center">
  <a href="https://www.linkedin.com/in/daniel-awurah-09912b123/">Connect on LinkedIn</a>
</p>
