---
name: cf-process-mapper
description: Business process mapping and optimization — workflow design, SOP creation,
  RACI matrices, swimlane diagrams, process documentation, continuous improvement.
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

# Process Mapper Skill

Design and document clear, optimized business processes.

## Process Mapping Framework

### Swimlane Diagram Components
- **Lanes**: One per role/team/department
- **Steps**: Actions with clear ownership
- **Decisions**: Conditional branches (yes/no, pass/fail)
- **Handoffs**: Transitions between lanes
- **Systems**: Tools used at each step

### RACI Matrix

| Task | Person A | Person B | Person C | Person D |
|------|----------|----------|----------|----------|
| Task 1 | R | A | C | I |
| Task 2 | A | R | I | C |

R = Responsible (doer), A = Accountable (approver), C = Consulted (input), I = Informed (notified)

### Process Levels
- Level 1: Value stream (end-to-end, cross-department)
- Level 2: Process (within one department)
- Level 3: Sub-process (specific workflow)
- Level 4: Procedure (step-by-step instructions)

## SOP Template
1. Purpose and scope
2. Roles and responsibilities
3. Prerequisites and inputs
4. Step-by-step procedure with time estimates
5. Decision points and criteria
6. Outputs and success criteria
7. Exceptions and escalation path
8. References and related documents

## Continuous Improvement
- Measure: cycle time, error rate, cost per process instance
- Analyze: bottleneck identification, value-added vs non-value-added
- Improve: eliminate, simplify, automate, delegate
- Control: monitor KPIs, periodic process reviews
