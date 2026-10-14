---
name: cf-conversion-optimization
description: Conversion Rate Optimization — landing page audits, funnel analysis,
  friction identification, experiment design, and scientific testing methodology.
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

# Conversion Optimization Skill

Use a scientific approach to improve conversion rates.

## CRO Audit Framework

### 1. Qualitative Analysis
- **Clarity score**: Can a visitor understand the offer in 5 seconds?
- **Friction points**: Long forms, unclear value prop, distracting nav, slow load
- **Trust signals**: Testimonials, logos, guarantees, security badges
- **Anchoring**: Is the main CTA visually dominant?
- **Intent match**: Does the page content match the traffic source?

### 2. Quantitative Analysis
- Page-level: bounce rate, time on page, scroll depth, CTA click rate
- Funnel: drop-off at each step, form field abandonment
- Segment: mobile vs desktop, new vs returning, traffic source

### 3. Hypothesis Generation
Template: `If we [change] on [page/element], then [metric] will [direction] because [rationale].`

### 4. Experiment Design
- One variable at a time (or multivariate with sufficient traffic)
- Statistical significance target: 95% confidence
- Minimum sample size calculation
- Run duration: minimum 1 full business cycle (7-14 days)
- Guardrail metrics: monitor for negative impact on revenue

### 5. Prioritization (PXL Model)
| Factor | Weight |
|--------|--------|
| Potential impact | 40% |
| Confidence in hypothesis | 30% |
| Implementation ease | 30% |

## Common CRO Levers
- Headline clarity and specificity
- CTA color, copy, placement
- Form field count and layout
- Social proof placement and format
- Page load speed
- Mobile responsiveness
- Trust badges and guarantees
- Scarcity and urgency signals

## Related Skills
- `ab-testing` — experiment implementation
- `copywriting` — CRO-informed copy rewrites
- `marketing-psychology` — behavioral levers
- `marketing-analytics` — measurement setup
