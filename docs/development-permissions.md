# Opt-in development permissions

The ordinary installer preserves permission settings. These examples are for a
user who explicitly authorizes fewer interruptions during development.

1. Back up `~/.codex/config.toml` privately, outside Git.
2. Merge the keys in `config/permissions/development.toml` into that file.
   Preserve unrelated keys, tables, model settings, plugins and authentication.
   If `[sandbox_workspace_write]` already exists, update its `network_access`
   key instead of creating a duplicate table.
3. Copy `config/permissions/development.rules` to
   `~/.codex/rules/codex-flow-development.rules`. Preserve other rule files.
4. Start a new chat in the intended project and check the effective permissions.
   A running chat or app-level policy can override config defaults.

The resulting defaults keep `workspace-write` isolation and `on-request`
approvals while allowing outbound network access from sandboxed commands.
Network access includes tools and scripts the agent executes, so enable it
only where that scope is acceptable. SSH authentication alone never grants
sandbox network permission.

Git rules allow the listed command prefixes with their trailing arguments.
They are reusable command approvals, not semantic argument validation: for
example, `git commit` also matches `git commit --amend`. They do not authorize
arbitrary Git operations, shells, Python, curl, force-push, reset or clean.
Other existing user rules may independently grant additional permissions.
Rules do not override managed policy or make protected paths writable.

Open each project directly instead of working from a projectless chat and
accessing unrelated directories. Do not add the whole home directory or
private credential directories as writable roots merely to avoid prompts.
`.git`, `.codex` and `.agents` can require separate approval even inside a
writable project. Use session-scoped grants when offered and appropriate.

Do not set `approval_policy = "never"` merely to suppress prompts: requests
outside the sandbox can fail rather than becoming permitted. Full machine
access is not needed for this setup. Some prompts can remain due to app,
managed or session policy; this configuration does not bypass those controls.

Rollback: restore the private config backup and remove only
`~/.codex/rules/codex-flow-development.rules`. Restart the chat to reassess.

Official references:
- https://learn.chatgpt.com/docs/config-file/config-reference
- https://learn.chatgpt.com/docs/sandboxing
