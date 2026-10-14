---
name: flow-runtime
description: Manage Codex Flow runtime, CLI automation, local issue watcher and migration compatibility; replaces OpenCode web service commands.
---

Read ~/.codex/flow/docs/runtime.md. Use the Codex app/CLI for interactive work;
`scripts/codex-run.sh <project> <workflow> [args...]` for non-interactive work.
OpenCode start-web/restart-web/stop-web/reset-web/setup-web are retired. Do not
invent a Codex web service or delete native Codex sessions. To manage the issue
watcher use setup-aibot-watcher.sh --install/--uninstall/--status. Install only
when the user explicitly requests activation, with AIBOT_TRIGGER_AUTHORS and
repo allowlist configured. Report permission and auth requirements truthfully.
