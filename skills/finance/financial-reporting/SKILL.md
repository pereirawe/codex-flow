---
name: cf-financial-reporting
description: Financial reporting and board materials — income statements, balance
  sheets, cash flow, board decks, management reports, variance commentary.
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

# Financial Reporting Skill

Prepare accurate, insightful financial reports.

## Report Types

### Monthly Management Report
- Executive summary (1 page)
- P&L vs budget: revenue, COGS, OpEx, EBITDA, net income
- Cash flow: operating, investing, financing
- KPIs: ARR, NRR, churn, CAC, headcount
- Variance commentary: over/under with explanations
- Forecast vs actuals

### Quarterly Board Deck (10-15 slides)
1. Financial summary: revenue, margin, cash, burn
2. Revenue deep dive: growth rate, mix, cohorts
3. Unit economics: LTV/CAC, payback, gross margin
4. P&L: actual vs plan vs prior year
5. Balance sheet & cash: runway, cap table
6. KPIs: NRR, churn, logo retention, efficiency
7. Outlook: forecast, risks, opportunities
8. Ask: board approvals needed

### Annual Report
- Audited financial statements
- MD&A (Management Discussion & Analysis)
- Segment reporting
- Risk factors
- Forward-looking guidance

## Best Practices
- Consistency: same format every period for comparability
- Clarity: plain language commentary, avoid accounting jargon
- Context: always show prior period and budget for comparison
- Materiality: flag items above 5% of net income
- Review: second set of eyes on every report

## Related Skills
- `financial-modeling` — projection inputs
- `budgeting` — variance analysis
- `revenue-analytics` — revenue detail
- `cfo-advisory` — strategic narrative
