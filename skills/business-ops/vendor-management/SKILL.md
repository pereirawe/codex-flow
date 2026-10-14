---
name: cf-vendor-management
description: Vendor lifecycle management — vendor selection, RFP, evaluation, contracting,
  performance management, offboarding.
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

# Vendor Management Skill

Manage vendors effectively across the full lifecycle.

## Vendor Lifecycle

### 1. Needs Assessment
- Business requirement clearly defined
- Build vs buy analysis
- Budget range and approval

### 2. Selection Process
- RFP/RFI with weighted scoring criteria
- Shortlist top 3-5 vendors
- Demos and proof of concept
- Reference calls with existing customers
- Total cost of ownership (TCO) analysis

### Vendor Evaluation Scorecard

| Criterion | Weight | Vendor A | Vendor B | Vendor C |
|-----------|--------|----------|----------|----------|
| Feature fit | 30% | 4 | 5 | 3 |
| Cost | 25% | 3 | 4 | 5 |
| Support & reliability | 20% | 5 | 3 | 4 |
| Integration ease | 15% | 4 | 4 | 2 |
| Strategic alignment | 10% | 5 | 3 | 4 |
| Weighted total | 100% | 4.0 | 3.9 | 3.7 |

### 3. Contracting
- Key terms: price, SLA, termination, data ownership, liability cap
- Legal review checklist
- Signature authority levels

### 4. Performance Management
- Quarterly business reviews (QBRs)
- SLA tracking and breach remediation
- Satisfaction surveys
- Annual renegotiation or rebid

### 5. Offboarding
- Contractual notice period
- Data extraction and transfer
- Account closure and credential revocation
- Lessons learned documentation
