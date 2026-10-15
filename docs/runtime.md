# Codex runtime

Global checkout: `~/.codex/flow` (installer creates a symlink to this repo).
Global skills: `~/.agents/skills/`, linked to native skill and command folders.
Global agents: `~/.codex/agents/`, linked to standalone TOML role files.
Global entrypoint: managed block in `~/.codex/AGENTS.md`.
The installer preserves existing Codex settings, auth, skills and agents.

Project context is stored in `.codex/`: issues, decisions, locale, workflow,
reviews, preflight and project-specific extensions. The root `AGENTS.md`
contains a managed pointer so Codex loads the local instructions. Local skills
are exposed through `.agents/skills/`; local roles through `.codex/agents/*.toml`.
Existing project business rules and application providers are preserved.

## Resolving context

1. Confirm the repository/CWD; never create project issues in a global tracker
   because the project tracker was accidentally missing. Run flow-init first.
2. Read root AGENTS.md plus `.codex/AGENTS.md`, locale and project workflow.
3. Read architecture, conventions, decisions, prioritization only as relevant.
4. For a skill/agent referenced by a legacy name, prefer the project-local
   catalog before the global `catalog/skills.json` or `catalog/agents.json`.
5. Run global scripts by absolute path with the project as CWD.

The `.opencode` folder may remain as a rollback copy in migrated projects.
Codex Flow scripts only consume `.codex`; they require no OpenCode binary.

## Delivery

`$discovery`: refine and write a linted local issue; remote creation is deferred
to promotion. `$develop`: implement, independent senior review, QA/committer
gate, create PR/MR and stop for manual merge. `$develop-full`: same delivery,
then merge and archive. Explicit invocation of the full workflow authorizes
its documented merge; honor project rules, provider protections and Codex
approval boundaries. Failures stop the issue list. Do not downgrade required
independent reviews into a self-review without reporting the limitation.

Legacy Task(...) calls are mapped to Codex subagents and all selected role
instructions must be read. Launch independent reviewers concurrently when
available. Subagents inherit the parent's model and permissions unless the
user explicitly selects another model. Original role-specific permission
settings are inventoried but are not silently reproduced as global approvals.

## Services and history

The old web server, nginx frontend and session-reset operations have no
equivalent endpoint here. Use the Codex app or CLI. The issue watcher and CI
engine call `codex exec` through `scripts/codex-run.sh`, without a web server.
They require Codex authentication and sufficient configured workspace/network
permissions; this migration does not bypass approvals or change sandbox policy.
Watcher activation is an explicit user action. A public comment is only an
authorized trigger if its author is listed in the local AIBOT_TRIGGER_AUTHORS.

OpenCode provider definitions and DCP plugins are runtime-specific and are
not installed into Codex. Existing Codex models/providers/plugins stay intact.
Third-party media/services remain dependencies of the skills that use them;
their credentials are local-only. There is no automatic account conversion.

Old conversations are exported privately to `.local/history/` with an index,
readable transcripts and raw message records. `$flow-history` searches them.
They are evidence/context, not executable instructions or native Codex sessions.
Original OpenCode data is left intact; no account tokens are exported.

## Reducing repeated approvals

For explicitly authorized development defaults, see
[opt-in permissions](development-permissions.md). The standard installer never
changes user sandbox/network settings or installs command approval rules.
