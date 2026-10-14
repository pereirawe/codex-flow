---
name: cf-proposal-writer
description: Turn an approved tech spec into a client-ready commercial proposal (scope,
  deliverables, timeline, investment, terms) with C-level validation on pricing and
  positioning. Use when the user asks to create, refine, or review a commercial proposal,
  SOW, quote, or client-facing project document derived from a spec. "proposal", "commercial
  proposal", "SOW", "proposta comercial", "proposta técnica" also trigger this skill.
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

# Proposal Writer Skill

Author commercial proposals that a client executive can read, understand,
and sign — grounded in an approved technical specification.

## Preconditions

- `docs/specs/<slug>/tech-spec.md` exists and is in `Status: approved`.
- Logo asset is in place at `docs/specs/<slug>/assets/logo.<ext>`.
- The user has confirmed client identity, budget envelope, and timeline.

## Proposal Data (`proposal-data.json`)

`docs/specs/<slug>/proposal-data.json` is the **single source of truth for
commercial identities** (client + issuer). If present, it MUST drive the
header, signature, logo, and footer — do not substitute any other company
name.

```json
{
  "project": { "slug": "...", "title": "...", "doc_dir": "docs/specs/<slug>" },
  "client":  { "name": "...", "segment": "...", "size": "...", "users": "...",
               "products": "...", "website": null, "cnpj": null, "contact": null },
  "issuer":  { "name": "...", "tagline": "...", "cnpj": "...", "website": "...",
               "email": "...", "phones": ["..."], "whatsapp": "...",
               "signatory": "...", "founders": [...], "logo": "./assets/logo.png" }
}
```

Header block (resolved from JSON):

```
## <project.title>                     ← verbatim, without client/issuer names

**Para:** <client.name> (<client.size>)   ← client.name VERBATIM from JSON
**De:** <issuer.signatory> · <issuer.name>
**Contato:** <issuer.email> · <issuer.phones[0]> (WhatsApp)
**Site:** <issuer.website>
**CNPJ:** <issuer.cnpj>
**Data:** <today>
**Validade:** <today + validity days>
```

Signature block resolves from `issuer.signatory`, `issuer.name + tagline`,
`issuer.website`, `issuer.email` and `issuer.whatsapp`.

Rules:
- `client.name` is used **verbatim** — never inferred or renamed.
- The issuer is the JSON issuer (e.g. "Marjô"), **not** Codetomika, when the
  file exists.
- Responsibilities, gates and assumptions belong to the **client**; branding,
  contacts and "why us" belong to the **issuer**. Do not cross them.
- Missing JSON → ask the user for client/issuer identity and flag
  `[TO CONFIRM WITH CLIENT]`; never silently assume.

## Canonical Structure

```
![Logo](./assets/logo.<ext>)

# Commercial Proposal — <Project Name>

- Version: <semver>
- Date: <YYYY-MM-DD>
- Valid until: <YYYY-MM-DD>
- Prepared for: <Client>
- Prepared by: <Company>

## 1. Executive Summary
   Three lines. What, why, how much.

## 2. Understanding of the Need
   Client context in their own words. Show you listened.

## 3. Proposed Solution
   3.1 Scope overview (Mermaid mindmap)
   3.2 Key deliverables (bullet list, each tied to tech-spec §X.Y)
   3.3 Out of scope (explicit exclusions)

## 4. Approach and Methodology
   Delivery model, milestones, review cadence, communication plan.

## 5. Timeline
   Mermaid gantt with phases, milestones, critical dates, freeze windows.

## 6. Team and Roles
   Named roles, allocation %, responsibilities. RACI if useful.

## 7. Effort and Investment
   7.1 Effort table (module → hours)
   7.2 Rate and calculation (show the math)
   7.3 Discounts / sponsorships (explicit deltas)
   7.4 Final price and payment schedule
   7.5 Effort split (Mermaid pie)

## 8. Assumptions and Client Inputs
   What the client must provide, by when. Blocks the timeline if missed.

## 9. Terms
   - Payment schedule
   - IP and ownership
   - Warranty and post-delivery support
   - Change request process
   - Confidentiality
   - Cancellation

## 10. Risks and Mitigations
    Top 3–5 risks with mitigation and owner.

## 11. Why Us
    Short. Track record, differentiators. No fluff.

## 12. Acceptance
    Signature block, date, contact.

## Appendix A — Validation Log
    C-level consultations that shaped this proposal.

## Appendix B — Change Log
    Version history if this is a revision.
```

## Diagrams (Mermaid only)

- **Scope overview**: `mindmap` centered on the project name, branches per
  module.
- **Timeline**: `gantt` with real dates, dependencies (`after`), milestones
  (`milestone`).
- **Effort split**: `pie showData` with modules and hours.
- **Architecture summary** (if useful): condensed `flowchart TB`.

## Effort → Price Math (must be visible)

```
| Module          | Hours |
|-----------------|------:|
| Module A        |   120 |
| Module B        |    80 |
| ...             |   ... |
| **Total**       |   436 |

Base rate:            R$ 195/h
Market value:         436 × 195 = R$ 85 020
Sponsorship (client): R$ –78 020
Final investment:     R$ 7 000
```

Never hide the calculation. Never round without saying so.

## Language Precision

- "Estimated" — best current guess, may change with new information
- "Target" — the number we aim for, subject to conditions
- "Commitment" — contractual, breach has consequences

Use them deliberately. Mixing them erodes trust.

## Quality Checklist

- [ ] Every deliverable line traces to a tech-spec section
- [ ] Timeline uses Mermaid gantt with dependencies and milestones
- [ ] Effort table shows hours per module and totals
- [ ] Price calculation is fully visible (rate × hours, discounts, final)
- [ ] Client-provided inputs are listed with deadlines
- [ ] Payment schedule is explicit
- [ ] Change request process is defined
- [ ] Risks are named with mitigations and owners
- [ ] Valid-until date is set (typically 30–60 days)
- [ ] Logo embedded at the top
- [ ] No internal jargon, no agent names, no code identifiers
- [ ] Locale-correct prose

## Anti-Patterns to Reject

- Deliverables that don't map to the spec
- Round-number pricing with no derivation
- Vague timelines ("Q2") when the spec has hard dates
- Missing "out of scope" section — invites scope creep
- Legal boilerplate that contradicts the client's actual constraints
- ASCII charts when Mermaid renders
- Marketing prose in the executive summary — decision-makers hate it
