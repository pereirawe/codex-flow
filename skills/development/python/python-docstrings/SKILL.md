---
name: cf-python-docstrings
description: Python module, class, function, and method docstrings. Use when writing
  or refining public Python documentation using PEP 257, PEP 8 docstring guidance,
  and the Google Python Style Guide.
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

# Python Docstrings

Use this skill when Python work is mainly about docstrings and caller-facing
documentation.

## Sources of truth

1. PEP 257
2. PEP 8 docstring guidance
3. Google Python Style Guide

## Checkpoints

- Public modules, classes, functions, and methods are documented when the
  project documents public APIs.
- Docstrings use triple double quotes.
- One-line docstrings are a single summary line ending with punctuation.
- Multi-line docstrings have a summary line, a blank line, and then details.
- Public function docstrings describe behavior, arguments, return values, side
  effects, raised exceptions, and restrictions when relevant.
- Class docstrings explain behavior and notable public surface area.
- Script/module docstrings can serve as usage guidance when appropriate.
- Docstrings do not repeat signatures mechanically.

## Guidance

- Prefer command-style summaries such as `Return ...`.
- Keep the summary line tight enough for indexing tools and readers.
- Document contracts and caveats the caller must know, not obvious mechanics.
