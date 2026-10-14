---
name: flow-proposal
description: ocf:proposal
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

---
description: Author a client-ready commercial proposal from an approved tech spec. Delegates to the business-ops/proposal-writer agent, which reads docs/specs/<slug>/tech-spec.md, runs commercial discovery, invokes C-level experts on pricing and positioning, and produces docs/specs/<slug>/proposal.md.
agent: business-ops/proposal-writer
---

## $flow-proposal

Create the commercial proposal for an approved technical specification.

Usage:

```
$flow-proposal <slug>
```

Example:

```
$flow-proposal dia-educacao-2026
```

## Preconditions

- `docs/specs/<slug>/tech-spec.md` exists and is marked
  `Status: approved` with at least one C-level sign-off.
- Logo asset is in place under `docs/specs/<slug>/assets/`.
- Optional but preferred: `docs/specs/<slug>/proposal-data.json` with the
  client + issuer identities (name, CNPJ, contacts, website, signatory,
  logo). When present, it drives the proposal header, signature, logo and
  footer; when absent, the agent asks the user for identities.

## What happens

1. The `business-ops/proposal-writer` agent reads the approved tech spec
   end-to-end, plus `proposal-data.json` (if present) to resolve the
   **client** and **issuer** identities.
2. It runs commercial discovery (client profile, budget, timeline, terms,
   sponsorship structure) in question batches.
3. It invokes C-level agents for pricing (`cfo`,
   `commercial/pricing-strategist`), positioning (`cmo`), delivery
   feasibility (`cto` + `business-ops/capacity-planner`), and legal
   (`commercial/deal-desk`) as needed.
4. It derives effort and price with visible math, drafts the proposal with
   Mermaid diagrams (flowchart, gantt, pie), runs the quality checklist, and
   asks for explicit sign-off before saving.
5. Output: `docs/specs/<slug>/proposal.md`.

