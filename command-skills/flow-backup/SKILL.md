---
name: flow-backup
description: Create intelligent timestamped backup excluding junk
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

## $flow-backup


Create a clean backup of a project directory, excluding common development
junk (node_modules, .venv, __pycache__, etc.) and preserving `.env` files.

Automatically prevents infinite recursion (won't copy existing backups into
the new backup).

### Usage

```
$flow-backup <source_dir> [backup_name] [--zip]
```

| Argument | Description |
|----------|-------------|
| `source_dir` | Directory to back up (required) |
| `backup_name` | Base name (default: `dev_backup`) |
| `--zip` | Also create a `.zip` archive |

### Examples

```
$flow-backup /home/user/dev
$flow-backup /home/user/dev my_backup
$flow-backup /home/user/dev my_backup --zip
```

### What is excluded

| Pattern | Reason |
|---------|--------|
| `bk/` | User-defined backup copys |
| `node_modules/` | npm packages |
| `.venv/` | Python virtual env |
| `__pycache__/` | Python bytecode cache |
| `.pytest_cache/` | Pytest cache |
| `my_pycache/` | Custom Python cache |
| `vendor/` | Composer packages |
| `bootstrap/cache/` | Laravel cache |
| `<backup_name>_*` | Previous backups (prevents recursion) |

### Behavior

- Creates `<source_dir>/<backup_name>_<timestamp>/`
- Updates `<source_dir>/<backup_name>_latest` symlink
- Optionally creates `<source_dir>/<backup_name>_<timestamp>.zip`
- `.env` files are always preserved (only directories above are excluded)

### Programmatic use

```bash
$SCRIPTS_DIR/backup.sh /home/user/dev --zip
```

