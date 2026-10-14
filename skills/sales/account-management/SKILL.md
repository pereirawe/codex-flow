---
name: cf-account-management
description: Account management and customer success — expansion, retention, QBRs,
  health scoring, upsell, cross-sell, churn prevention.
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

# Account Management Skill

Grow existing accounts and reduce churn.

## Customer Health Scoring

| Category | Weight | Metrics |
|----------|--------|---------|
| Product usage | 30% | Login frequency, feature adoption, API calls |
| Support engagement | 20% | Ticket volume, severity, satisfaction |
| Business outcome | 25% | Goal achievement (metric improvement) |
| Relationship | 15% | QBR attendance, sponsor engagement, NPS |
| Risk signals | 10% | Churn mentions, budget cuts, competitor activity |

Score: 0-100. Green (70+), Yellow (40-69), Red (<40).

## QBR Structure (Quarterly Business Review)
1. **Executive summary** — achievements this quarter
2. **Value realized** — metrics improved, goals met, ROI delivered
3. **Usage deep dive** — adoption trends, feature adoption, power users
4. **Challenges** — friction points, open issues, product gaps
5. **Roadmap alignment** — upcoming features relevant to them
6. **Growth plan** — expansion opportunities, use case expansion
7. **Action items** — who does what by when

## Expansion Playbook

| Signal | Action |
|--------|--------|
| Usage approaching limits | Proactively discuss upgrade |
| New champion identified | Schedule discovery for new use case |
| Department expansion | Offer divisional rollout |
| Product launch | Campaign to existing customers |
| Contract renewal approaching | Start renewal 90 days early |

## Churn Prevention
- Health score drops below 40 → automated alert
- No login in 30 days → engagement campaign
- Ticket spike indicating frustration → CS outreach
- Champion leaves → executive sponsor outreach
- Competitor mentions → competitive review + retention offer

## Related Skills
- `sales-pipeline` — renewal forecasting
- `sales-enablement` — expansion collateral
- `customer-research` — churn insights
