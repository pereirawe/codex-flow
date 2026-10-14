---
name: cf-cost-analytics
description: Cost structure analysis and optimization — cost categorization, efficiency
  metrics, burn rate analysis, unit cost, margin analysis.
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

# Cost Analytics Skill

Understand and optimize your cost structure.

## Cost Structure Analysis

### Fixed vs Variable
- **Fixed**: Rent, salaries, base infrastructure
- **Variable**: Cloud usage, ad spend, commission
- **Semi-variable**: Support (base + per-ticket)

### Cost by Department

| Department | Typical Cost Drivers | Efficiency Metric |
|-----------|---------------------|-------------------|
| Engineering | Cloud, SaaS, headcount | Cost per developer, infra cost per user |
| Sales & Marketing | Ads, events, tools, commissions | CAC, cost per lead, cost per pipeline dollar |
| G&A | Legal, accounting, insurance, office | Cost per employee |
| R&D | Research tools, prototyping | Cost per experiment |

### Cost Allocation
- Direct: costs tied to one department (salaries)
- Shared: costs split by usage (cloud, office)
- Overhead: corporate costs allocated by formula (headcount, revenue)

## Efficiency Metrics

| Metric | Formula | Target |
|--------|---------|--------|
| Burn multiple | Net burn / net new ARR | <1.5x |
| Gross margin | (Revenue - COGS) / Revenue | >70% (SaaS) |
| CAC ratio | (Sales + marketing) / new ACV | <1x |
| Infrastructure efficiency | Cloud cost / MAU | Decreasing trend |
| Labor efficiency | Revenue / FTE | Increasing trend |

## Optimization Opportunities
- Cloud: right-size instances, reserved instances, spot instances
- SaaS: audit unused licenses, consolidate tools
- Headcount: contractor vs FTE analysis, offshore options
- Ad spend: ROAS by channel, cut underperformers
- G&A: negotiate vendor contracts, automate manual processes

## Related Skills
- `budgeting` — budget alignment
- `financial-modeling` — model assumptions
- `revenue-analytics` — margin analysis
