---
name: cf-rfp-responder
description: RFP and proposal response management — compliance matrices, win themes,
  response structure, competitive positioning, bid/no-bid decisions.
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

# RFP Responder Skill

Win more RFPs with structured, compelling responses.

## Bid/No-Bid Decision

| Criterion | Weight | Score (1-5) |
|-----------|--------|-------------|
| ICP fit | 25% | |
| Win probability | 20% | |
| Deal size | 20% | |
| Strategic value | 15% | |
| Resource required | 10% | |
| Competitive position | 10% | |

Score > 3.5: Bid. Score 2.5-3.5: Bid with conditions. Score < 2.5: No-bid.

## Response Structure

### Compliance Matrix
| RFP Requirement | Our Response | Location | Compliant? |
|----------------|-------------|----------|------------|
| Section 3.1 — Security | SOC 2 Type II, ISO 27001 cert | Appendix A | Yes |

### Win Themes (3-5)
1. **Differentiator**: What only we can claim (with evidence)
2. **Value**: Quantified ROI or TCO advantage
3. **Trust**: Relevant case studies, existing relationships
4. **Innovation**: Forward-looking capability advantage
5. **Service**: Implementation and support quality

### Response Sections
1. Executive summary (win themes + differentiators)
2. Technical response (compliance matrix + detail)
3. Commercial response (pricing + terms)
4. Implementation approach
5. Case studies and references
6. Appendix (certifications, team bios, financials)

## Related Skills
- `proposals` — proposal writing
- `sales-enablement` — competitive positioning
- `pricing-strategist` — pricing strategy
