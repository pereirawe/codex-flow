---
name: flow-resolve
description: Resolve a Codex Flow catalog agent, skill, or command name to its canonical file path on disk.
---

# Flow resolve

Use when an instruction names a legacy role, skill, or command and you need the
single source file without loading whole catalogs.

```bash
python3 ~/.codex/flow/scripts/flow-resolve.py agent development/discovery
python3 ~/.codex/flow/scripts/flow-resolve.py skill flow-steward
python3 ~/.codex/flow/scripts/flow-resolve.py command develop
```

Matches `legacy_name`, `name`, and command aliases. Prints one absolute path;
non-zero exit when unknown or missing on disk.
