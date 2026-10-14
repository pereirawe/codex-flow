---
name: cf-capacity-planner
description: Resource and capacity planning — demand forecasting, resource allocation,
  utilization modeling, headcount planning, skills gap analysis.
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

# Capacity Planner Skill

Plan and optimize resource capacity across the organization.

## Capacity Planning Framework

### Demand Forecasting
- Historical demand patterns (seasonal, growth trend)
- Pipeline-driven demand (sales forecast → implementation need)
- Strategic initiatives (new products, market expansion)
- Assumption documentation for each input

### Utilization Modeling
| Role Type | Target Utilization | Billable % | Bench % |
|-----------|-------------------|------------|---------|
| Engineering | 80% | 70% | 20% |
| Consulting | 85% | 80% | 15% |
| Support | 75% | 60% | 25% |

### Resource Allocation
- Right-skill: match skill level to task complexity
- Right-time: align with project timeline requirements
- Right-cost: optimize team mix (FTE vs contractor vs offshore)
- Utilization guardrails: avoid >90% (burnout risk) or <60% (cost inefficiency)

### Headcount Planning
1. Baseline: current headcount by role and location
2. Attrition: historical + planned departures
3. Demand calculation: forecasted workload × hours per unit
4. Gap analysis: demand - (current + in-pipeline hires)
5. Plan: hires, contractors, training, redistributions

## Related Skills
- `budgeting` — headcount cost
- `process-mapper` — workload measurement
- `financial-modeling` — scenario integration
