---
name: flow-bump-version
description: Calculate and apply version bump, update changelog, commit, tag, and
  publish to main
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

## $flow-bump-version

---

description: Calculate and apply version bump, update changelog, commit, tag, and publish to main
---

Calculate the next version based on recent commits, update `VERSION`, `CHANGELOG.md`,
and `README.md`, then commit, tag, and publish to `main`.

### Flow

1. **Read current version** from `VERSION` file and find the last git tag
2. **Analyze commits** since the last tag — classify as major/minor/patch
3. **Suggest new version** — show the user the analysis and ask for confirmation
4. **Update files** — `VERSION`, `README.md`, `CHANGELOG.md`
5. **Commit and tag** — `chore: bump version to X.Y.Z` + `git tag vX.Y.Z`
6. **Publish** — push to origin; if not on `main`, create a PR

### Bump Classification

| Commit type | Bump |
|-------------|------|
| `feat!:` or `BREAKING CHANGE:` | Major (X+1.0.0) |
| `feat:` | Minor (x.Y+1.0) |
| `fix:`, `chore:`, `docs:`, `refactor:`, `test:` | Patch (x.y.Z+1) |

The highest classification found determines the bump.

### Usage

```
$flow-bump-version
```

