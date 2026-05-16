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

## 02 · IAM Skills & Capabilities

> *Core technical knowledge underpinning all IAM work above.*

| Capability | Detail |
|---|---|
| **Directory Services** | Active Directory DS, OU design, Group Policy Objects (GPO), user & group lifecycle |
| **Identity Platform** | Okta — SSO, SAML 2.0, OIDC/OAuth 2.0, MFA, Lifecycle Management |
| **Cloud Identity (Microsoft)** | Microsoft Entra ID — Conditional Access, MFA, App Registrations, Entra Connect (AD sync) |
| **Zero Trust Access** | Cloudflare Access, Cloudflare Tunnels, Zero Trust Network Access (ZTNA) |
| **Identity Governance** | SailPoint — access certification, role management, policy enforcement |
| **Access Models** | RBAC design, Least Privilege enforcement, Segregation of Duties (SoD) |
| **Account Lifecycle** | Joiners / Movers / Leavers (JML), automated provisioning & deprovisioning |
| **Protocols** | SAML 2.0 · OIDC · OAuth 2.0 · LDAP · Kerberos |
| **Hybrid IAM** | Bridging on-prem AD with cloud identity providers (Okta, Microsoft Entra ID) |

**IAM Tech Stack**

![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![Entra ID](https://img.shields.io/badge/Microsoft_Entra_ID-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Okta](https://img.shields.io/badge/Okta-007DC1?style=flat-square&logo=okta&logoColor=white)
![Cloudflare Zero Trust](https://img.shields.io/badge/Cloudflare_Zero_Trust-F48120?style=flat-square&logo=cloudflare&logoColor=white)
![SailPoint](https://img.shields.io/badge/SailPoint_IGA-003087?style=flat-square)
![SAML](https://img.shields.io/badge/SAML_2.0-555555?style=flat-square)
![OIDC](https://img.shields.io/badge/OIDC_%2F_OAuth_2.0-555555?style=flat-square)
![RBAC](https://img.shields.io/badge/RBAC_Design-555555?style=flat-square)
![JML](https://img.shields.io/badge/JML_Lifecycle_Automation-555555?style=flat-square)
![Conditional Access](https://img.shields.io/badge/Conditional_Access-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![MFA](https://img.shields.io/badge/MFA-555555?style=flat-square)
![Entra Connect](https://img.shields.io/badge/Entra_Connect_(AD_Sync)-555555?style=flat-square)

---

## 03 · Governance, Risk & Compliance (GRC)

> *Secondary focus area. Building risk programs that function as business enablers, not roadblocks.*

| Capability | Detail |
|---|---|
| **Framework Implementation** | NIST CSF, ISO 27001, SOC 2 — gap analysis, control mapping, audit readiness |
| **Risk Operations** | Enterprise risk assessments, risk quantification, dynamic risk register management |
| **Third-Party Risk (TPRM)** | Vendor security reviews, supply chain governance, procurement collaboration |
| **Policy Lifecycle** | End-to-end security policy development, documentation standards, governance processes |
| **Compliance Advisory** | Sector experience across Healthcare, Fintech, Retail, and Technology |
| **AI Governance** | Responsible AI controls, RAG system risk management, AI automation policy |
| **Human Risk Management** | Security awareness programs, phishing mitigation, social engineering defense |

**GRC Tech & Frameworks**

![NIST CSF](https://img.shields.io/badge/NIST_CSF-003087?style=flat-square)
![ISO 27001](https://img.shields.io/badge/ISO_27001-0052CC?style=flat-square)
![SOC 2](https://img.shields.io/badge/SOC_2-6554C0?style=flat-square)
![TPRM](https://img.shields.io/badge/Third--Party_Risk_(TPRM)-555555?style=flat-square)
![Risk Register](https://img.shields.io/badge/Risk_Register_Management-555555?style=flat-square)
![AppSec](https://img.shields.io/badge/AppSec_%2F_OWASP_Top_10-000000?style=flat-square&logo=owasp&logoColor=white)
![SSDLC](https://img.shields.io/badge/Secure_SDLC-555555?style=flat-square)

### GRC Project Repository

> Full repository → [danielawurah/grc-security-policies](https://github.com/danielawurah/grc-security-policies) — Centralized governance, risk, and compliance security policies, standards, and procedures.

| Project / Deliverable | Proof | Purpose | Frameworks | Status |
|---|---|---|---|---|
| [**Controls Mapping — ISO 27001**](https://github.com/danielawurah/grc-security-policies/blob/main/CONTROLS-MAPPING/iso-27001-2022-map.csv) | CSV Document | Maps organizational controls to ISO 27001:2022 requirements for audit readiness and gap analysis. | ISO 27001 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Controls Mapping — NIST 800-53**](https://github.com/danielawurah/grc-security-policies/blob/main/CONTROLS-MAPPING/nist-800-53-map.csv) | CSV Document | Maps security controls to NIST SP 800-53 control families to support federal and enterprise compliance posture. | NIST 800-53 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Controls Mapping — SOC 2 TSC**](https://github.com/danielawurah/grc-security-policies/blob/main/CONTROLS-MAPPING/soc2-tsc-mapping.md) | Document | Maps internal controls to SOC 2 Trust Services Criteria (Availability, Confidentiality, Security). | SOC 2 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Access Control Policy**](https://github.com/danielawurah/grc-security-policies/blob/main/GLOBAL-CONTROLS/access-control.md) | Document | Defines enterprise-wide access control standards covering identity verification, least privilege, and role-based access governance. | ISO 27001 · NIST CSF | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Security Awareness Training Policy**](https://github.com/danielawurah/grc-security-policies/blob/main/GLOBAL-CONTROLS/awareness-training.md) | Document | Establishes mandatory security awareness training requirements to reduce human risk and social engineering exposure. | NIST CSF · SOC 2 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Encryption Standard**](https://github.com/danielawurah/grc-security-policies/blob/main/GLOBAL-CONTROLS/encryption-standard.md) | Document | Defines data encryption standards for data at rest and in transit across all organizational systems and cloud environments. | ISO 27001 · SOC 2 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Incident Response Plan**](https://github.com/danielawurah/grc-security-policies/blob/main/GLOBAL-CONTROLS/incident-response.md) | Document | Structured incident response playbook covering detection, containment, eradication, recovery, and post-incident review. | NIST CSF · ISO 27001 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Industry Verticals — AI/SaaS, Fintech, Healthcare**](https://github.com/danielawurah/grc-security-policies/tree/main/INDUSTRY-VERTICALS) | Documents | Tailored compliance guidance for regulated sectors including AI/SaaS, Fintech, and Healthcare — addressing sector-specific risks and regulatory requirements. | ISO 27001 · HIPAA · PCI-DSS | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Startup Security Baseline**](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/startup-security-baseline.md) | Document | Minimum viable security baseline for early-stage startups and SMBs to establish foundational controls quickly and cost-effectively. | NIST CSF · SOC 2 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Automated Compliance Guide**](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/automated-compliance-guide.md) | Document | Guide for automating compliance workflows to reduce manual overhead and maintain continuous audit readiness. | SOC 2 · ISO 27001 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Employee Offboarding (Lean)**](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/employee-offboarding-lean.md) | Document | Streamlined offboarding checklist ensuring timely access revocation, data recovery, and account deprovisioning. | ISO 27001 · NIST CSF | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Zero Trust for Remote Access**](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/zero-trust-for-remote.md) | Document | Policy and implementation guide for adopting Zero Trust principles for remote workforce access. | NIST CSF · Zero Trust | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Simple Incident Response (SMB)**](https://github.com/danielawurah/grc-security-policies/blob/main/STARTUPS-SMB/simple-incident-response.md) | Document | Lightweight incident response playbook tailored for small businesses without a dedicated security team. | NIST CSF | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Exception Request Form**](https://github.com/danielawurah/grc-security-policies/blob/main/TEMPLATES/exception-request-form.md) | Template | Standardized form for requesting policy exceptions with risk justification, approver sign-off, and expiry tracking. | ISO 27001 · SOC 2 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |
| [**Risk Assessment Template**](https://github.com/danielawurah/grc-security-policies/blob/main/TEMPLATES/risk-assessment-template.xlsx) | Template | Structured risk assessment workbook for identifying, scoring, and tracking enterprise risks against likelihood and impact. | NIST CSF · ISO 27001 | ![Complete](https://img.shields.io/badge/Complete-2ea44f?style=flat-square) |

---

## 04 · Certifications

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

## 05 · Education

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

## 06 · Supporting Technical Skills

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

## 07 · IAM & GRC Project Work

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
