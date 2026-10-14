---
name: flow-audit-ui
description: Orchestrate the audit/refactor pipeline for existing codebases (ui-auditor
  → ui-refactor-planner, optionally → build pipeline)
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

## $flow-audit-ui


Audit an **existing** codebase and plan its UI refactor through two passes
that consume and produce structured JSON, with an optional third pass that
chains into the greenfield build pipeline (`$flow-build-ui`) to implement the
refactor.

### Usage

```
$flow-audit-ui [project-path] [session-id]
```

| Argument | Description |
|----------|-------------|
| `<project-path>` | Project to audit (default: current working directory) |
| `<session-id>` | Existing session id (`YYYY-MM-DDTHH-MM-SS`) — resumes the pipeline from the first missing stage |

### Examples

```
$flow-audit-ui
$flow-audit-ui /home/user/dev/my-app
$flow-audit-ui /home/user/dev/my-app 2026-08-17T14-30-00
```

### Pipeline passes

| Pass | Agent | Input | Output |
|------|-------|-------|--------|
| 1 | `design/ui-auditor` | Project path | `<dir>/audit_report.json` |
| 2 | `design/ui-refactor-planner` | `<dir>/audit_report.json` (+ design spec) | `<dir>/refactor_plan.json` |
| 3 (optional) | `design/ui-architect` → `design/ui-implementer` → `design/ui-critic` | `design/ui-architect`: `<dir>/design_spec.json` (when available) + `<dir>/refactor_plan.json` → `<dir>/component_tree.json`; `design/ui-implementer`: `<dir>/design_spec.json` + `<dir>/component_tree.json` + `<dir>/refactor_plan.json` + project root → production code; `design/ui-critic`: code + `<dir>/design_spec.json` + `<dir>/component_tree.json` → `<dir>/quality_report.json` | Production code + `<dir>/quality_report.json` |

`<dir>` = `.codex/design-outputs/<session-id>/`.

1. **Pass 1 — `design/ui-auditor`**: detects the stack via bash (`REACT_VITE`,
   `NEXTJS_APP`, `VUE_VITE`, `PHP_BLADE`, `PHP_HTML`, `HTML_VANILLA`, etc.),
   scores dimensions 1–5, cites `file:line` for every issue, and records
   preserved patterns. Never writes or edits code.
2. **Pass 2 — `design/ui-refactor-planner`**: consumes
   `<dir>/audit_report.json` and, when available, the design spec
   (`.codex/design-outputs/<session-id>/design_spec.json` from a prior
   `$flow-build-ui` run) — produces `<dir>/refactor_plan.json`: a phased plan
   (Group A blockers, Group B inline, Group C opportunities). Never plans a
   big bang and never deletes before replacing.
3. **Optional Pass 3**: if the user also wants the refactored UI implemented,
   the command continues into the build pipeline, reusing the same session id
   and output files: `design/ui-architect` receives
   `<dir>/design_spec.json` (when available from a prior `$flow-build-ui` run)
   AND `<dir>/refactor_plan.json`, producing `<dir>/component_tree.json`;
   `design/ui-implementer` receives `<dir>/design_spec.json`,
   `<dir>/component_tree.json` AND `<dir>/refactor_plan.json` plus the project
   root, and writes production code; `design/ui-critic` receives the
   implemented code plus `<dir>/design_spec.json` and
   `<dir>/component_tree.json`, producing `<dir>/quality_report.json`
   (`APPROVED` or `ISSUES_FOUND`; iterate, max 3 rounds). If still
   `ISSUES_FOUND` after 3 rounds, stop, log the failure, send a Telegram
   notification, and deliver with the remaining findings listed in the
   summary.

### Session and output conventions

A session id (UTC timestamp `YYYY-MM-DDTHH-MM-SS`) and an output directory
`.codex/design-outputs/<session-id>/` are created at command start. All
stage outputs land in that directory. On resumption the existing session id
and its output directory are REUSED as-is — a new session id/directory is
created only on the first run, never on a resume run. See
`standards/design-pipeline.md` for the full output conventions and session
protocol.

### Failure handling

On ANY stage failure the command logs the failure, sends a Telegram
notification (via the `telegram-notifier` skill /
`scripts/telegram-notify.sh`), and **STOPS** — it does not continue to the
next stage.

### Resumption

Re-running the command with the same session id REUSES the same session id
and its output directory — never creating a new one — and skips stages whose
output files already exist, continuing from the first missing stage.

### Model

No model is hardcoded for any stage — subagents use the user's default model
(see issue #82).

### Response language

The command responds in the user's input language (locale rule, issue #73).

