---
name: flow-build-ui
description: Orchestrate the 4-pass greenfield design pipeline (art-director → ui-architect
  → ui-implementer → ui-critic) with deterministic output files
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

## $flow-build-ui


Turn a design brief into production UI through the **Adorable pipeline**: four
passes that each consume and produce structured JSON, chained end-to-end with
no ambiguous text between agents. The pipeline is greenfield-only — for
existing codebases use `$flow-audit-ui`.

### Usage

```
$flow-build-ui <brief|file-path|session-id>
```

The argument is a design brief — either inline text or a path to a file
containing the brief. When the argument matches a session id (UTC timestamp
format `YYYY-MM-DDTHH-MM-SS`, e.g. `2026-08-17T14-30-00`), the command treats
it as a **resumption session id** instead of a new brief.

| Argument | Description |
|----------|-------------|
| `<brief>` | Design brief as inline text (required if not resuming) |
| `<file-path>` | Path to a file containing the design brief (required if not resuming) |
| `<session-id>` | Existing session id (`YYYY-MM-DDTHH-MM-SS`) — resumes the pipeline from the first missing stage |

If no argument is provided, the command asks the user for a brief.

### Examples

```
$flow-build-ui "A landing page for a boutique coffee roaster, warm and editorial"
$flow-build-ui briefs/coffee-roaster.md
$flow-build-ui 2026-08-17T14-30-00
```

### Pipeline passes

| Pass | Agent | Input | Output |
|------|-------|-------|--------|
| 1 | `design/art-director` | Design brief | `<dir>/design_spec.json` |
| 2 | `design/ui-architect` | `<dir>/design_spec.json` | `<dir>/component_tree.json` |
| 3 | `design/ui-implementer` | `<dir>/design_spec.json` + `<dir>/component_tree.json` + project root | Production code |
| 4 | `design/ui-critic` | Implemented code + `<dir>/design_spec.json` + `<dir>/component_tree.json` | `<dir>/quality_report.json` |

`<dir>` = `.codex/design-outputs/<session-id>/`.

1. **Pass 1 — `design/art-director`**: produces the design spec JSON
   (`brief_analysis`, `rejected_defaults`, `directions_considered`,
   `selected_direction`, `design_spec`). Never writes code.
2. **Pass 2 — `design/ui-architect`**: produces the component tree JSON
   (`layout_regions`, `component_tree`, `components`, `interaction_map`,
   `build_order`). Never writes code.
3. **Pass 3 — `design/ui-implementer`**: writes production code in the project
   following the build order; it never skips defined states.
4. **Pass 4 — `design/ui-critic`**: quality gate — returns `APPROVED` or
   `ISSUES_FOUND` with component-specific findings. If `ISSUES_FOUND` with
   blocking items, the feedback is fed back to the `design/ui-implementer`
   (iterate, max 3 rounds). If still `ISSUES_FOUND` after 3 rounds, the
   command stops, logs the failure, sends a Telegram notification, and
   delivers with the remaining findings listed in the summary.

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

Re-running the command with the same session id
(e.g. `$flow-build-ui <session-id>`) REUSES the same session id and its output
directory — never creating a new one — and skips stages whose output files
already exist, continuing from the first missing stage.

### Model

No model is hardcoded for any stage — subagents use the user's default model
(see issue #82).

### Response language

The command responds in the user's input language (locale rule, issue #73).

