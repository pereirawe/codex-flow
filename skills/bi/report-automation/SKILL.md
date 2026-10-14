---
name: cf-report-automation
description: Automated reporting and alerting — scheduled report generation, anomaly
  detection, executive summaries, automated insight delivery.
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

# Report Automation Skill

Build systems that deliver insights on schedule.

## Report Types

| Type | Cadence | Audience | Content |
|------|---------|----------|---------|
| Daily snapshot | Daily | Ops team | Key metrics vs target, anomalies |
| Weekly digest | Weekly | Management | Trends, wins, risks, actions |
| Monthly review | Monthly | Leadership | Full performance, variance, forecast |
| Quarterly board | Quarterly | Board | Strategic narrative, financials, outlook |

## Automated Alert Design
- **Threshold-based**: metric falls outside acceptable range
- **Statistical**: z-score > 3 deviation from trailing mean
- **Trend-based**: N consecutive periods of decline/growth
- **Composite**: combination of signals (traffic drop + conversion drop)

## Summary Generation
- Section 1: Executive headline (1 sentence: "Revenue grew X% driven by Y")
- Section 2: Key metrics table (actual, target, variance, trend)
- Section 3: Anomalies and alerts (what changed, impact, investigations)
- Section 4: Actions (decisions needed, owners, deadlines)

## Pipeline
- Query → Transform → Render → Distribute
- Output formats: PDF, HTML email, Slack message, dashboard link
- Error handling: retry logic, fallback data, notification on failure

## Related Skills
- `analytics-engineering` — data pipeline
- `data-analysis` — insight generation
- `dashboard-design` — visual components
