---
name: cf-revenue-analytics
description: Revenue analysis and SaaS metrics — MRR/ARR decomposition, revenue recognition
  (ASC 606), cohort retention, churn analysis, LTV, NRR, expansion revenue.
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

# Revenue Analytics Skill

Analyze revenue streams and growth drivers with SaaS-specific metrics.

## MRR/ARR Deep Dive

### MRR Components
| Component | Definition | Health Signal |
|-----------|------------|---------------|
| New MRR | Revenue from new customers | Growing QoQ |
| Expansion MRR | Upsells, cross-sells, upgrades | NRR > 100% |
| Contraction MRR | Downgrades, reduced seats | < 10% of starting MRR |
| Churn MRR | Lost revenue from cancellations | Decreasing trend |
| **Net New MRR** | New + Expansion - Contraction - Churn | > 0 |

### Cohort Retention Heatmap
Rows = signup month, Columns = months since signup
Value = % of cohort still active
Pattern: strong cohorts maintain > 80% retention by month 6

### NRR Calculation
`NRR = (Starting MRR + Expansion - Churn - Contraction) / Starting MRR`

| NRR | Meaning |
|-----|---------|
| >120% | Exceptional — high expansion, low churn |
| 100-120% | Healthy — expansion offsets churn |
| 90-100% | Warning — churn slightly exceeding expansion |
| <90% | Critical — negative net retention |

## Revenue Recognition (ASC 606)
- **Performance obligation**: What was promised?
- **Transaction price**: What was agreed?
- **Allocation**: Split across obligations if multiple
- **Recognition timing**: Over time (subscription) vs point in time (services)

## LTV Modeling
- **Simple LTV**: ARPU / monthly churn rate
- **Cohort LTV**: Track actual revenue per cohort over 12-24 months
- **Discounted LTV**: Apply 10-15% discount rate
- **LTV/CAC ratio by channel**: Compare efficiency of acquisition channels
