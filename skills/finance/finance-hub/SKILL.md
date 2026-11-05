---
name: cf-finance-hub
description: Route finance and metrics work to the right skill — models, board
  materials, variance, unit economics, and SaaS revenue. Clarifies boundaries vs
  skills/bi (data pipelines) and skills/commercial (deals, pricing, forecasts).
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

Legacy `Task(role)` means a Codex subagent using the role in the role catalog;
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

# Finance hub

## Typical outputs (pick the skill that matches the deliverable)

| Deliverable | Skill (`legacy_name`) | Output shape |
|-------------|----------------------|--------------|
| 3-statement / SaaS model, scenarios, DCF | `financial-modeling` | Spreadsheet-style model + assumptions table |
| Board deck, mgmt P&L, cash flow narrative | `financial-reporting` | Board pack sections, variance commentary |
| Budget vs actual, rolling forecast | `budgeting` | Budget lines, variance bridge, forecast revisions |
| Burn, unit cost, margin diagnostics | `cost-analytics` | Cost buckets, efficiency metrics |
| MRR/ARR, churn, cohort, NRR | `revenue-analytics` | SaaS metric tables, cohort views |
| Fundraise, cap table, investor narrative | `cfo-advisory` | Strategic memo + investor-facing storyline |

Start here when the user says "finance", "model", "board", "variance", or "unit economics" without naming a skill.

## vs `skills/bi/*` (data & reporting infrastructure)

| Question | Finance pack | BI pack |
|----------|--------------|---------|
| Build dbt models, warehouse layers, data quality tests? | No | `analytics-engineering`, `data-governance` |
| Design Looker/Metabase dashboards from existing tables? | No | `dashboard-design` |
| Exploratory analysis on a dataset (cohorts, funnels)? | Sometimes overlap | Prefer `data-analysis` when the ask is **SQL/dataset** driven |
| Executive **narrative** with modeled assumptions | **Finance** | BI supports charts; finance owns assumptions |

Rule: if the work starts in the **warehouse/schema**, use BI; if it starts in **assumptions and financial statements**, use finance.

## vs `skills/commercial/*` (deals & GTM economics)

| Question | Finance pack | Commercial pack |
|----------|--------------|-------------------|
| Pricing strategy, packaging, discount policy | Input to model | `pricing-strategist`, `deal-desk` |
| Pipeline-weighted revenue forecast for sales | Overlap | Prefer `commercial-forecasting` for **sales pipeline**; finance model for **P&L/cash** |
| Channel/partner economics | Overlap | `channel-economics` for GTM design; finance for consolidated statements |
| RFP / proposal pricing section | No | `rfp-responder`, `proposal-writer` |

Rule: **commercial** skills decide how to sell and price; **finance** skills decide whether the business works and how to report it.

## vs marketing / delivery ops

| Question | Use |
|----------|-----|
| Campaign ROI, ad spend dashboards | `marketing-analytics` |
| Client project hours vs proposal | `progress-report` |
| Internal LLM/issue cost | `ops-report`, `flow-issue-cost` |
