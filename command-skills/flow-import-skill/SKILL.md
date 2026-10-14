---
name: flow-import-skill
description: Import external skills as git clones via skill-vendor.sh
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

## $flow-import-skill <git-url|owner/repo>


Import an external skill (or a repo containing several skills) using the
**vendor clone strategy** — the upstream repo is cloned into
`~/.codex/flow/vendor/` and loaded in-place via `skills.paths`, so it can
be updated with `git pull` and never diverges from upstream. Skills are never
copied into `skills/`.

### Flow

1. Ask the user for the source: a git URL (`https://github.com/owner/repo`)
   or `owner/repo` shorthand.
2. If the repo contains multiple skills and the user only wants specific ones,
   ask which folders to check out as sparse paths (e.g.
   `skills/taste-skill skills/redesign-skill skills/minimalist-skill`).
3. Run `scripts/skill-vendor.sh add <url> [--sparse <paths...>]`, which:
   - clones the repo into `~/.codex/flow/vendor/<name>`,
   - discovers every `SKILL.md` frontmatter `name` inside the clone,
   - registers each discovered skill as `allow` in `permission.skill`
     (atomic write to `opencode.json`).
4. Report the installed path and discovered skill names.
5. Remind the user to restart opencode for the skills to appear.

### Maintenance

```bash
scripts/skill-vendor.sh add <git-url|owner/repo> [--sparse <paths...>]
scripts/skill-vendor.sh update <name>   # git pull — no re-import
scripts/skill-vendor.sh list
scripts/skill-vendor.sh remove <name>   # also unregisters its skills
```

### Usage

```
$flow-import-skill meodai/skill.color-expert
$flow-import-skill Leonxlnx/taste-skill --sparse skills/taste-skill skills/redesign-skill skills/minimalist-skill
```

