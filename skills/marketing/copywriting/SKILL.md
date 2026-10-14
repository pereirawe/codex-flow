---
name: cf-copywriting
description: Marketing copywriting and copy-editing across all channels — homepage,
  landing pages, emails, ads, social posts, and SEO content. Includes brand voice
  development, persuasion frameworks, and editorial quality gates.
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

# Copywriting Skill

Write, rewrite, and improve marketing copy that converts.

## Workflow

### 1. Brief Collection
- Product/offer being promoted
- Target audience and ICP
- Channel and format
- Tone and brand voice guidelines
- Key message hierarchy (primary claim → supporting proof → CTA)
- Conversion goal

### 2. Copy Frameworks

**AIDA** (Awareness → Interest → Desire → Action):
- **Awareness**: Headline that stops scrolling — specific customer problem or bold claim
- **Interest**: Expand the problem, show you understand the context
- **Desire**: Solution, proof (social proof, stats, case studies), differentiation
- **Action**: Clear CTA with low friction and specific next step

**PAS** (Problem → Agitate → Solve):
- **Problem**: Name the exact pain point
- **Agitate**: Make it hurt — what does the problem cost them?
- **Solve**: Present your solution as the relief

**4Ps** (Promise → Picture → Proof → Push):
- **Promise**: What will happen?
- **Picture**: Help them visualize the outcome
- **Proof**: Evidence it works
- **Push**: Motivate action

### 3. Channel-Specific Rules

**Homepage hero**: Headline ≤ 12 words. Subheadline expands. CTA is specific (not "Learn More").
**Landing page**: One goal per page. Remove navigation if possible. Match ad promise exactly.
**Email subject line**: 30-50 chars. Personalize or create curiosity. No spam triggers.
**Social post**: Hook in first line. Short paragraphs. One clear takeaway.
**Ad copy**: Front-load the value. Use power words. Match headline to landing page.

### 4. Editing Pass (Copy-Editing Mode)
1. **Clarity**: Is the main message obvious in 3 seconds?
2. **Concision**: Can every sentence be shorter?
3. **Persuasion**: Does it use at least one framework?
4. **Specificity**: Replace "high quality" with specific claims
5. **Voice**: Does it sound like a person or a brand guide?
6. **CTA**: Is it clear what to do next?

## Related Skills
- `conversion-optimization` — pair copy with CRO audits
- `marketing-psychology` — apply cognitive biases to copy
- `email-marketing` — lifecycle-specific copy
