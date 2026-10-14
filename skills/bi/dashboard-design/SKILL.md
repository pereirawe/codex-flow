---
name: cf-dashboard-design
description: Dashboard and data visualization design — KPI selection, chart type selection,
  dashboard layout, UX, data storytelling, BI tool best practices.
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

# Dashboard Design Skill

Design dashboards that drive decisions.

## KPI Selection Framework

### Executive Dashboards
- North Star metric (revenue, active users, NPS)
- 3-5 health metrics (growth, retention, efficiency, satisfaction)
- Trend direction (green/red) with 3-month trajectory
- No more than 7 KPIs per view

### Operational Dashboards
- Granular metrics by team/product/channel
- Daily/weekly cadence with targets
- Drill-down capability to root cause
- Actionable: every metric should have a decision attached

### Diagnostic Dashboards
- Correlation matrix for early signal detection
- Funnel breakdown with step-by-step conversion
- Cohort behavior patterns
- Anomaly flags with statistical significance

## Chart Selection
| Data Relationship | Chart Type |
|-------------------|------------|
| Trend over time | Line chart |
| Part of whole | Stacked bar or donut |
| Comparison across categories | Bar chart (sorted) |
| Distribution | Histogram, box plot |
| Relationship | Scatter plot |
| Geographic | Map |
| Funnel | Funnel chart |
| Ranking | Horizontal bar |

## Dashboard UX Rules
- Most important KPI top-left (reading pattern)
- Consistent date range selector on every page
- Filters at the top, drill-through on click
- Color: categorical (distinct) or sequential (gradient)
- Avoid 3D, pie charts with >5 slices, dual axis when avoidable
- Title every chart, label axes, source footnote

## Related Skills
- `data-analysis` — insight generation
- `report-automation` — scheduled delivery
- `marketing-analytics` — marketing-specific dashboards
