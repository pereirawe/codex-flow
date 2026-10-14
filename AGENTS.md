# Codex Flow

This repository contains the user's global Codex workflows. Project-specific
business rules belong in each project's AGENTS.md and `.codex/` context.
Read docs/runtime.md before modifying runtime or installation behavior.
Use catalog/commands.json to resolve commands and catalog/agents.json for roles.
Do not version vendor clones, credentials, exported conversations or local state.
Validate changes with `python3 scripts/validate.py` and relevant script tests.
Use semantic commits with an Issue trailer. Keep independent review evidence.
