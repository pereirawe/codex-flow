---
name: cf-threat-modeling
description: STRIDE-based threat modeling methodology — system decomposition, threat
  identification per STRIDE category, risk ranking (DREAD), and mitigation planning.
  Use when analyzing architecture for threats, reviewing designs for security, or
  producing a threat model as part of secure design (OWASP ASVS V1).
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

Legacy `Task(role)` means a Codex subagent using the role in the agent catalog;
if that role cannot be selected natively, read its instructions and include
them in the subagent task. Never run OpenCode. Legacy read/glob/grep/skill
names mean the equivalent available Codex file/search/skill tools. Read a
referenced skill by resolving its legacy name in `catalog/skills.json`.
Shell snippets using OpenCode's !`...` notation are examples, not executable
directives: run the corresponding reviewed command with native shell tools.

Inherit Codex permissions and model settings. Old permission YAML is source
metadata, not an enforcement mechanism. Stop on failed gates; never claim
unperformed tests/reviews passed. Only send external notifications/comments
when the user explicitly invokes a workflow that includes them or separately
authorizes them. Mere migration, file reading, or implicit skill selection
does not authorize sending. Do not hide approval rejections from the user.

# Threat Modeling (STRIDE)

Systematic approach to identifying, ranking, and mitigating security threats
in an architecture or feature design. Use this skill whenever a design or
architecture must be analyzed for threats before (or during) implementation.

## STRIDE categories

| Category | Threat property | Example |
|----------|-----------------|---------|
| Spoofing | Authenticity | Attacker impersonates a user, service, or device |
| Tampering | Integrity | Attacker modifies data in transit or at rest |
| Repudiation | Non-repudiation | Attacker denies performing an action (no audit trail) |
| Information Disclosure | Confidentiality | Attacker reads data they should not access |
| Denial of Service | Availability | Attacker degrades or blocks service |
| Elevation of Privilege | Authorization | Attacker gains higher privileges than granted |

## Process

### 1. Decompose the system

- Draw a data flow diagram (DFD): external entities, processes, data stores,
  and trust boundaries.
- Identify every entry point, exit point, and trust boundary.
- Inventory assets (data, credentials, services) and their sensitivity.

### 2. Identify threats (per STRIDE)

For each element in the DFD, ask the STRIDE questions:

- **Spoofing**: Can an entity be impersonated? How is identity verified?
- **Tampering**: Can data be modified without detection?
- **Repudiation**: Is there an audit trail for sensitive actions?
- **Information disclosure**: Can data cross a trust boundary unencrypted?
- **DoS**: Can an input or resource be exhausted?
- **Elevation**: Can a lower-privileged caller reach privileged functions?

Use the **threat library** for common patterns:

- Authentication bypass, session hijacking, token forgery
- SQL/NoSQL injection, XSS, command injection, template injection
- IDOR, path traversal, missing function-level access control
- Secrets in code/config, weak crypto, predictable randomness
- Unsafe deserialization, SSRF, file upload abuse
- Missing rate limits, unbounded resource consumption
- Insecure direct object references, mass assignment

### 3. Rank risks (DREAD or similar)

Score each threat 0–10 on:

| Factor | Question |
|--------|----------|
| Damage | How severe is the damage if exploited? |
| Reproducibility | How reliably can it be reproduced? |
| Exploitability | How easy is it to exploit? |
| Affected users | How many users are impacted? |
| Discoverability | How easy is it to discover? |

Total 0–50: 30+ high, 15–29 medium, <15 low. Critical/high-ranked threats
are blockers — mitigation is required before approval.

### 4. Mitigate

Map each threat to a mitigation (prevent, detect, respond):

| STRIDE | Typical mitigations |
|--------|---------------------|
| Spoofing | Strong authentication, MFA, mutual TLS, signed tokens |
| Tampering | Integrity checks, signing, immutable logs, TLS |
| Repudiation | Audit logging, non-repudiation controls |
| Information Disclosure | Encryption at rest/in transit, least privilege, masking |
| DoS | Rate limiting, quotas, resource limits, load shedding |
| Elevation | Authorization checks at every boundary, RBAC/ABAC, least privilege |

## Output format

1. System decomposition (DFD elements + trust boundaries)
2. Threat list: element → STRIDE category → description → DREAD score → risk
3. Mitigations per threat (accepted/mitigated/deferred)
4. Residual risk statement
5. Open blockers: any critical/high threat without mitigation
