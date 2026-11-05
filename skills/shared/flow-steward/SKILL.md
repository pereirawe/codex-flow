---
name: flow-steward
description: Reviews discovery, develop, and develop-full after they finish or stop, and applies one small durable fix so the same flow error does not recur.
---

# Flow steward

Run in the parent agent after `discovery`, `develop`, or `develop-full` reaches an outcome, including a stop. Do not spawn a subagent. Do not notify.

## Steps

1. `bash ~/.codex/flow/scripts/flow-steward.sh lessons --flow <flow>`
2. If this run's class already has a `fix` or `blocked` line, apply that fix only when the skill file still lacks it. Do not invent a second fix. Then `record` and stop.
3. A new edit is allowed only when this run hit a repeatable flow defect: wrong path, skipped gate, double notification, ambiguous step, or an instruction that made the agent re-read catalogs, agents, or unrelated skills. The edit must make the next run shorter or stop that failure.
4. Edit only `~/.codex/flow/command-skills/<flow>/SKILL.md`. One edit. At most 8 added lines, or a deletion. Do not restyle the file. Do not edit `opencode.json`, vendor skills, or other flows.
5. Record:

```bash
bash ~/.codex/flow/scripts/flow-steward.sh record \
  --flow <flow> --step <step> --result ok|fail|fix|blocked \
  --class <short-class> --note "<what changed or why nothing changed>"
```

Use `ok` when nothing in the flow should change. Use `fix` after a patch. Use `blocked` when the same class already has two fixes. Use `fail` for a product or environment error that is not a flow defect.

## Do not

- Load whole agent or skill catalogs (one path: `flow-resolve.py`).
- Send Telegram or OpenWA from this skill.
- Lengthen a flow to "be safer" without removing a repeated failure.
