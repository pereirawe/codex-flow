---
name: cf-commercial-forecasting
description: Commercial forecasting and revenue modeling — pipeline conversion models,
  booking forecasts, scenario planning, board-ready commercial outlook.
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

# Commercial Forecasting Skill

Build data-driven commercial forecasts that drive decisions.

## Forecast Models

### Pipeline Conversion Model
`Forecast = Pipeline × Stage-Weighted Probability × Win Rate × ASP`

### Historical Trend Model
`Forecast = Trailing 3-month average × Seasonal adjustment × Growth rate`

### Scenario Planning

| Scenario | Assumptions | Impact |
|----------|-------------|--------|
| Base case | Current velocity, win rates, seasonality | Most likely |
| Upside | +15% conversion, +2 large deals closing | Optimistic |
| Downside | -10% conversion, 1 deal slips quarter | Conservative |
| Stretch | Target number | What we're aiming for |

### Key Inputs
- Pipeline by stage ($ and count)
- Historical win rate per stage per segment
- Average sales cycle length
- ASP trends (new vs expansion)
- Seasonality patterns
- Rep ramp curves

## Board-Ready Outlook
| Section | Content |
|---------|---------|
| Commercial overview | Revenue trajectory, bookings, pipeline health |
| Forecast by segment | New business vs expansion vs renewal |
| Key assumptions | What's baked in, what's stretch |
| Risks & opportunities | Specific deals, competitive threats, upsides |
| Actions | What we're doing to hit the number |

## Related Skills
- `sales-pipeline` — pipeline data
- `financial-modeling` — revenue model integration
- `deal-desk` — deal structure impact
