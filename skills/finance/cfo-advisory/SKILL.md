---
name: cf-cfo-advisory
description: Strategic CFO advisory — fundraising strategy, cap table management,
  board preparation, strategic finance, M&A support, investor relations.
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

# CFO Advisory Skill

Strategic financial leadership for company-building decisions.

## Fundraising Strategy

### Pre-Ready Checklist
- [ ] 12+ months of financial projections
- [ ] Unit economics model (LTV/CAC, payback, gross margin)
- [ ] Competitive landscape overview
- [ ] Use of funds plan with clear milestones
- [ ] Cap table and pro-forma ownership
- [ ] Data room: financials, metrics, legal, team, product

### Pitch Deck Financials (3 slides)
1. **Business model**: How you make money with unit economics
2. **Growth metrics**: Revenue, users, retention with cohorts
3. **Financial projections**: 3-5 year P&L with milestones

### Term Sheet Navigation
| Term | Implication | Watch For |
|------|-------------|-----------|
| Valuation | Ownership dilution | Pre vs post money |
| Liquidation preference | Exit proceeds distribution | Participating vs non-participating |
| Anti-dilution | Down round protection | Weighted average vs full ratchet |
| Board seats | Control structure | Founder majority |
| Vesting | Founder retention | 4-year / 1-year cliff standard |
| Information rights | Investor oversight | Reasonable vs onerous |

## Cap Table Management
- Current ownership: founders, employees, investors
- Option pool size and remaining
- Pro-forma for next round
- 409A valuation and common stock pricing
- Liquidation waterfall model

## Board Preparation
- Pre-read materials sent 5 business days before
- Board deck: strategic narrative → financials → KPIs → risks → ask
- CEO + CFO alignment before every board meeting
- Anticipate tough questions: cash runway, competitive threats, miss reasons

## M&A Support
- Acquisition criteria and strategic fit
- Financial due diligence checklist
- Synergy modeling (revenue, cost, cross-sell)
- Integration planning and timeline
- Valuation and structure (cash, stock, earn-out)

## Related Skills
- `financial-modeling` — projections and valuation
- `financial-reporting` — board materials
- `revenue-analytics` — growth story
- `cost-analytics` — efficiency narrative
