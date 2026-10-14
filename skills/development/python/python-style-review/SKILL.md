---
name: cf-python-style-review
description: Python naming, imports, exceptions, comprehensions, decorators, properties,
  and readability tradeoffs. Use when reviewing or refining idiomatic Python style,
  especially around PEP 8, PEP 20, and the Google Python Style Guide.
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

# Python Style Review

Use this skill when Python work is mainly about idiomatic style and language
choices, not type-system design or docstring contracts.

## Sources of truth

1. PEP 20
2. PEP 8
3. Google Python Style Guide

## Review priorities

- readability over cleverness
- explicit behavior over hidden magic
- project consistency over isolated local preference
- simple control flow over dense expressions

## Checkpoints

- Names follow established Python conventions.
- Imports are explicit, grouped clearly, and avoid wildcard imports.
- Comprehensions stay readable; expand to loops when density hurts clarity.
- Mutable default arguments are not used.
- `None` checks use `is` / `is not`.
- `assert` is not used for required runtime validation.
- `try` blocks are narrow and catches are specific.
- Properties are only used when attribute-like access is genuinely appropriate.
- Decorators are justified and do not hide surprising behavior.
- Comments explain non-obvious intent rather than restating code.

## Guidance

- Prefer the simplest code that is easy to explain.
- If a style rule conflicts with surrounding coherent code, prefer local
  consistency unless the existing pattern is clearly harmful.
- Prefer plain loops over nested comprehensions when the loop is easier to
  scan.
- Prefer module-level functions over `@staticmethod` unless an external API
  forces the method shape.
