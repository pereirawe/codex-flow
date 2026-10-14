---
name: flow-review-branch
description: Full PR/MR-style code review
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

## $flow-review-branch


Full PR/MR-style review of the current branch.

The working directory (`$PWD`) determines the target project. All paths are
relative to the project root, **not** to the global opencode config.

### Output naming convention

Review output is written to a branch-specific file, not a generic tracker:

```
<project>/.codex/<model>_<branch>_issues.md
```

- `<model>` — AI model name that generated the review (e.g. `claude-4`, `deepseek-v4`)
- `<branch>` — current git branch name (e.g. `feat-add-auth`)
- This keeps each review isolated, traceable by model, and branch-scoped

Example: `.codex/claude-4_feat-add-auth_issues.md`

### Flow

1. **Load locale-loader skill first** to get locale-appropriate standards
   (code-review.md, issues.md) — respect `.codex/locale` in the project
2. **Read `- Reviewers:`** from the issue entry in `known_issues.md` — if
   the field is missing or empty, default to 1 — do **not** ask the user
3. Pass the resolved locale context to all Senior Reviewer agents
4. Analyze `git diff` and run the review with that many reviewers
5. Write review output to the branch-specific file

### Responsibilities

- Read `- Reviewers:` from the issue entry — default to 1 if missing or empty — do **not** ask the user
- Analyze `git diff`
- Use the specified number of Senior Engineer reviewers
- Only review code changes, not docs or other files (unless docs are updated in the same commit)
- Only review code changes that are part of the current branch (not changes from other branches)
- Identify only Critical and Major issues (not Minor or Trivial)
- Validate: tests exist, docs updated (if applicable)
- Sync issues to `<project>/.codex/<model>_<branch>_issues.md`
- Follow the issue entry format from `standards/issues.md`
- Do not resolve issues, only create new ones
- Do not delete or modify existing issues in the issue tracker
- Do not create duplicate issues for the same code change
- If a remote PR/MR exists for this branch, post review comments via `gh` or `glab`
- Create a 'Recommended priority' section with a clear recommendation (Critical or Major) based on severity and potential impact

