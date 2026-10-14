---
name: cf-sales-psychology
description: Sales psychology and buyer behavior — cognitive biases in B2B buying,
  rapport frameworks, objection psychology, decision dynamics, emotional arc management.
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

# Sales Psychology Skill

Understand buyer psychology to close more deals.

## Buyer Decision Biases

| Bias | Application in Sales |
|------|---------------------|
| Loss aversion | "What are you losing by not solving this?" > "What will you gain?" |
| Status quo bias | Disrupt by reframing inaction as a decision, not a default |
| Social proof | "Companies like yours choose X because Y" |
| Authority | Industry expertise, credentials, thought leadership |
| Reciprocity | Give value first — insight, resource, introduction |
| Commitment/consistency | Get small commitments early; they build toward larger ones |
| Anchoring | Set the reference point high before presenting options |
| Decoy effect | Present three options where the middle is your target |
| Scarcity | Limited availability or time-bound offer |
| Liking | Similarity, genuine compliments, shared connections |

## Rapport-Building Framework

1. **Mirror**: Match communication style (pace, formality, detail level)
2. **Validate**: Show understanding of their specific situation
3. **Reciprocate**: Share relevant insight or experience
4. **Connect**: Find common ground (industry, role, challenge)
5. **Lead**: Guide conversation toward productive outcomes

## Objection Psychology
- **Price objection** often means value not yet established — revisit ROI
- **Timing objection** often means urgency not felt — reframe cost of delay
- **Competition objection** often means differentiation unclear — sharpen positioning
- **Need-to-think objection** often means fear of wrong decision — provide safety

## Emotional Arc of a B2B Sale
1. **Status quo comfort** — "We're fine"
2. **Pain recognition** — "Actually, this does cost us"
3. **Hope** — "Maybe there's a better way"
4. **Fear** — "What if we pick wrong?"
5. **Validation** — "Others like us made this work"
6. **Commitment** — "Let's move forward"

## Related Skills
- `marketing-psychology` — broader consumer psychology
- `sales-pipeline` — deal stage for psychological context
- `sales-enablement` — objection scripting
