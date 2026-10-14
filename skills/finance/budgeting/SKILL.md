---
name: cf-budgeting
description: Budget planning and variance analysis — budget allocation, rolling forecasts,
  headcount planning, OPEX management, variance commentary.
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

# Budgeting Skill

Plan, track, and optimize budgets across the organization.

## Budget Planning Framework

### Top-Down vs Bottom-Up
- **Top-down**: Leadership sets targets → departments allocate
- **Bottom-up**: Departments estimate needs → finance consolidates
- **Hybrid**: Targets from top, detailed plans from bottom, negotiate gaps

### Budget Categories

| Category | % of Budget (SaaS) | Key Drivers |
|----------|-------------------|-------------|
| Headcount & payroll | 50-70% | FTE count, avg salary, hiring plan |
| Engineering (infra/tools) | 10-15% | Cloud, SaaS, hardware |
| Sales & marketing | 15-25% | Ad spend, events, commissions |
| G&A | 5-10% | Legal, accounting, office, insurance |
| R&D | 5-10% | Research, prototyping, IP |

### Rolling Forecast
- Update monthly, not annually
- 12-18 month forward window
- Re-forecast based on actuals + changing conditions
- Variance analysis: actual vs forecast by department

## Variance Analysis

| Variance Type | Sign | Action |
|--------------|------|--------|
| Revenue upside | Positive | Reinvest or save |
| Revenue shortfall | Negative | Cut discretionary spend |
| Cost overrun | Negative | Investigate, cut, or reallocate |
| Cost savings | Positive | Reallocate or save |

### Commentary Template
"X department was Y% over/under budget due to [reason]. The impact is [Z]. We recommend [action]."

## Related Skills
- `financial-modeling` — model inputs
- `cost-analytics` — cost structure
- `financial-reporting` — variance reporting
