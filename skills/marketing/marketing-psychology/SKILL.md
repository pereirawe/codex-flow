---
name: cf-marketing-psychology
description: Behavioral science applied to marketing — cognitive biases, mental models,
  Cialdini principles, Kahneman frameworks, and persuasion engineering.
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

# Marketing Psychology Skill

Apply cognitive biases and behavioral science to improve conversion.

## Core Frameworks

### Cialdini's 7 Principles
- **Reciprocity**: Give value first (content, tool, sample) → triggers obligation
- **Scarcity**: Limited time/quantity → loss aversion
- **Authority**: Expert credentials, media logos, certifications → trust shortcut
- **Consistency**: Small yes → larger commitment (foot-in-the-door)
- **Liking**: Similarity, compliments, shared values → rapport
- **Social Proof**: Testimonials, reviews, usage stats, "join 10K+ customers"
- **Unity**: "Us" language, shared identity → in-group bias

### Kahneman's System 1 & 2
- **System 1** (fast, automatic): Headlines, images, gut reactions
- **System 2** (slow, deliberate): Comparisons, calculations, research
- Marketing must win in System 1 before engaging System 2

### Cognitive Biases for Marketing

| Bias | Application |
|------|-------------|
| Anchoring | Show highest price first, set reference point |
| Loss aversion | "Don't miss out" vs "Save money" |
| Paradox of choice | Limit options → increase conversion |
| Confirmation bias | Show proof that confirms customer's belief |
| Endowment effect | Free trial → ownership → higher willingness to pay |
| Social validation | "Others like you bought this" |
| Framing effect | "90% success" vs "10% failure" |
| Decoy effect | Add a strategically worse option to make target look better |

## Application Workflow

1. **Identify decision moment**: Where in the funnel is the user deciding?
2. **Detect friction**: What biases are working against conversion?
3. **Select lever**: Which bias or principle can reduce friction?
4. **Rewrite**: Apply the bias to copy, layout, or offer
5. **Test**: A/B validate the psychological lever

## Related Skills
- `copywriting` — apply psychology to copy
- `conversion-optimization` — behavioral CRO
- `pricing` — anchoring and decoy in pricing
