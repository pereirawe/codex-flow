---
name: cf-ab-testing
description: A/B testing and experimentation — experiment design, sample size calculation,
  statistical analysis, growth experimentation programs.
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

# A/B Testing Skill

Design and analyze experiments with statistical rigor.

## Experiment Design

### 1. Hypothesis Formation
Template: `If we [change] for [audience segment], then [metric] will [increase/decrease by X%] because [expected behavioral mechanism].`

### 2. Variable Selection
- **One variable per test** (A/B/n): cleaner attribution
- **Multivariate**: multiple variables, requires more traffic
- **Holdout**: control group unaffected by the experiment
- **Switchback**: time-based randomization for marketplace/network effects

### 3. Sample Size Calculation
- Baseline conversion rate
- Minimum detectable effect (MDE): typically 5-20% relative
- Statistical power: 80% standard
- Significance level (α): 0.05 standard
- Use: `power.prop.test()` or online calculator

### 4. Randomization
- User-level: consistent experience per user
- Session-level: appropriate for session-based metrics
- Ensure no contamination between variants

## Analysis Rules

### Statistical Rigor
- **Do not peek**: Peeking inflates false positive rate. Use sequential testing if early stopping is needed.
- **Minimum runtime**: 1-2 full business cycles (7-14 days minimum)
- **Segment analysis**: Check if effect varies by segment (secondary analysis, not primary)
- **Novelty effect**: New experiences often get short-term boost — wait for stabilization

### Decision Framework
| Result | Action |
|--------|--------|
| Statistically significant positive | Implement, document learnings |
| Statistically significant negative | Revert, document hypothesis failure |
| Inconclusive (flat) | Increase sample size or runtime. If still flat, move on. |
| Conflicting segments | Dig deeper before implementing |

## Growth Experimentation Program
- Experiment backlog: ranked by ICE score (Impact × Confidence × Ease)
- Cadence: 1-2 concurrent experiments per traffic source
- Weekly experiment review: results, learnings, next actions
- Experiment library: document all tests with results for future reference

## Related Skills
- `conversion-optimization` — hypothesis generation
- `marketing-analytics` — metric definition
- `marketing-psychology` — behavioral levers
