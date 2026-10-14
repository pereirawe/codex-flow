---
name: flow-commit
description: Atomic semantic commit with standards/commits.md
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

## $flow-commit


Create a structured atomic commit using conventional commits format, with
trailers that sync `known_issues.md` and remote issue trackers.

### Convention

Follow `standards/commits.md` — atomic + semantic + tracked.

```
<type>(<scope>): <imperative description>

<body (optional)>

Issue: #<id>
Status: <in-progress | resolved>
```

### Mandatory rules

- **One logical change per commit** — split if you need "and" in the description
- **Always include `Issue: #<id>`** — every commit must reference a tracked issue
- **Use `Status: in-progress`** for work-in-progress commits
- **Use `Status: resolved` or `Closes #<id>`** when the commit completes the issue

### Types

| Type | When |
|------|------|
| `feat` | New feature or logic |
| `fix` | Bug fix |
| `refactor` | Restructuring, no behavior change |
| `test` | Test changes |
| `docs` | Documentation |
| `chore` | Config, deps, tooling |

### Examples

```
feat(api): add analytics endpoint

Issue: #6
Status: in-progress
```

```
fix: validate URL scheme before fetch

Issue: #3
Closes #3
```

```
refactor: extract service layer from handler

Issue: #7
Status: resolved
```

### Usage

```
$flow-commit
```

The assistant will:
1. Ask for the commit type, scope (optional), description, and issue ID
2. Detect the project's `known_issues.md` and current status
3. Construct the commit following `standards/commits.md`
4. Run `git commit` with the structured message
5. Update `known_issues.md` status based on trailers

