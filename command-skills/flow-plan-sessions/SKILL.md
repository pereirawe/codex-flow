---
name: flow-plan-sessions
description: Plan delivery sessions with schedule + prompts + plans in .codex/sessions/
---

## Codex runtime contract

Read `~/.codex/flow/docs/runtime.md`. Resolve scripts from `~/.codex/flow/scripts/`.

## $flow-plan-sessions

One command: collect `ready` issues (or `--ids`), write schedule + session prompts
**and** session plans under `.codex/sessions/<date>/` (gitignored).

```bash
bash ~/.codex/flow/scripts/session-plan.sh \
  [--horizon day|week] [--ids 12,13] \
  [--launch] [--parallel N] [--worktree] \
  [--flow develop|develop-full]
```

On `index.md` merge conflicts after parallel work: `issues-reindex.sh`.
Prefer hybrid tracker (`issues-migrate.sh`) before mass parallel launches.

Delegates the rules in `cf-delivery-session-planner` (effort bands, path conflicts).
