---
name: discovery
description: Refine an idea or existing issue into a canonical, linted local issue.
  Use for discovery before delivery.
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

## $discovery [proposal | id]

Transform a raw idea or existing issue id into a tracked, typed, linted issue.
Discovery is the ONLY phase with user interaction — put business context in the
argument; do not prompt mid-flow.

### Arguments

```
$discovery "Add CSV export to reports screen"
$discovery 12
$discovery "Bug: login fails when token expires"
```

### Flow

1. **Resolve `known_issues.md`** (project `.codex/` first, global fallback).
2. **Classify** via script (do not invent the loop):

```bash
printf '%s' "<proposal or existing issue text>" \
  | bash ~/.codex/flow/scripts/discovery-route.sh --text -
```

Record `METRICS_START` and after routing:

```bash
bash ~/.codex/flow/scripts/metrics-record.sh \
  --issue 0 --flow discovery --step route --result ok
```

(Use the real id after append; for route-only use `--issue 0` or skip until id exists.)

3. **Follow the JSON**:
   - `agents: []` (`chore` or `feat-lean`): in **this** agent, fill fields from the
     proposal + `defaults`, including a short `- Work plan:` (3–8 steps with
     `→` outcomes from rules/Tests/Suggested fix), run `scripts/append-issue.sh`
     (supports `--work-plan`) then `scripts/issue-lint.sh --strict <id>`.
     **No** `Task(development/discovery)` and **no** PO/TL Tasks. If lint FAIL →
     escalate: re-run router is not enough; invoke the agents that `feat-full`
     would need (PO and/or TL) and fix — never leave a weak `ready`.
   - `agents` non-empty: invoke **only** those roles (in order), each via
     `Task(<role>)` with the proposal + router JSON. Prefer not wrapping in
     `Task(development/discovery)` when the list is already explicit. Then
     `append-issue.sh` + `issue-lint.sh --strict` (Work plan still required for
     ready feat/bug — warn if missing).
4. **Verify** lint PASS. On FAIL, report gaps; do not mark ready.
5. **Notify** once via `~/.codex/flow/scripts/flow-notify.sh` (Telegram).
6. **Metrics** after append (with real id):

```bash
bash ~/.codex/flow/scripts/metrics-record.sh \
  --issue <id> --flow discovery --step complete \
  --agents "<comma roles used>" --result ok|fail
```

7. **Steward**: read `~/.codex/flow/skills/shared/flow-steward/SKILL.md` for
   `discovery`.

### Quality bar (fail closed)

Same floors as `issue-lint` (feat rules; Tests by severity). `feat-lean` is
allowed only when the router reports empty `gate_failures`. Delivery reviewers
and `committer-check` are unchanged.

### Notes

- Remote is created at promotion (`$develop` / `$develop-full`).
- After discovery: `$develop-full <id>` or `$develop <id>`.
