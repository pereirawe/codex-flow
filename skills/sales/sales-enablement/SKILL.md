---
name: cf-sales-enablement
description: Sales enablement content and tools — pitch decks, battle cards, objection
  handling, demo scripts, case studies, ROI calculators, competitive positioning.
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

# Sales Enablement Skill

Equip your sales team to win more deals with structured enablement.

## Battle Card Template

| Section | Content |
|---------|---------|
| Competitor | Name, category, funding, market position |
| Their pitch | Core message and positioning |
| Our advantage | Specific differentiators with evidence |
| Their weakness | Verified gaps in their product/service |
| Response scripts | "They say X, we respond with Y" (3-5 objections) |
| Win/loss intel | Common scenarios where we beat/lose to them |

## Objection Handling — LAER Model
- **Listen**: Understand the full concern without interrupting
- **Acknowledge**: Validate their perspective — "That's a fair concern"
- **Explore**: Dig deeper — "Can you tell me more about what's behind that?"
- **Respond**: Address specifically with evidence, not deflection

## Common Objection Scripts

### "We're happy with our current solution"
1. Acknowledge: "Glad to hear it's working for you"
2. Explore: "What would need to change for you to consider alternatives?"
3. Reframe: "Several clients said the same before they discovered [specific benefit]"
4. Evidence: Share relevant case study or testimonial

### "Too expensive"
1. Isolate: "If we could show a clear ROI within [timeframe], would price still be a blocker?"
2. Quantify: Break down cost vs value delivered
3. Compare: Cost of inaction vs investment
4. Flexible: Alternative packaging or phasing

### "Not a priority right now"
1. Acknowledge: "I understand you have competing priorities"
2. Impact: "What's the cost of waiting on this specific problem?"
3. Trigger: "What would change that priority?"
4. Timeline: "When would be a better time to revisit?"

## Demo Script Structure
1. **Confirm**: Restate their pain from discovery — show you listened
2. **Story**: Walk through their workflow, not your feature list
3. **Value**: Every feature → specific benefit → quantified outcome
4. **Proof**: Show similar customer results
5. **Objection prep**: Preempt top 2 concerns during demo
6. **Close**: "Based on what you've seen, does this solve [main pain]?"
