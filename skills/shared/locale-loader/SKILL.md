---
compatibility: Codex with local shell tools
name: cf-locale-loader
description: Use when you need to access or reference standards documents (code-review,
  branching, commits, issues, PR template) or when deciding the response/output language
  for user-facing content. Loads locale-appropriate versions from standards/{locale}/
  based on the locale file in .codex/locale or ~/.codex/flow/locale, and resolves
  the canonical response-language rule (input language → project locale → global locale
  → English).
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

## What I do

- Read the locale from `.codex/locale` (project) first; fall back to `~/.codex/flow/locale` (global)
- Load standards from `standards/{locale}/` instead of `standards/` when a localized version exists
- Fall back to English (`standards/`) when the locale is not set, not available, or the specific file doesn't exist in the locale directory
- Support `pt` (Português) and `es` (Español) out of the box

## Resolution Order (STRICT)

1. **If** the project has `.codex/locale` → use that locale, **ignore global**
2. **Else** if `~/.codex/flow/locale` exists → use global locale
3. **Else** → default to English (`standards/`)
4. For a given locale, check `standards/{locale}/<file>` first
5. Fall back to `standards/<file>` (English) if the localized file doesn't exist

## Response-Language Rule (canonical)

Every agent MUST respond and produce user-facing outputs in the language the
user communicates in. Resolution order:

1. **Input language** — the language the user is writing/talking in (the
   session/input language always wins)
2. **Project locale** — `.codex/locale` in the project directory
3. **Global locale** — `~/.codex/flow/locale` (global fallback)
4. **English** — when neither is applicable

This applies to chat responses, generated reports, Telegram notifications,
and remote issue comments. Exception: the aibot posts its standardized PT-BR
messages (`standards/aibot-messages.md`, issue #39) as a domain contract, and
career-sector tailored resumes follow the job offer's language (cv-tailor
rule).

## Rules

- **The agent MUST read `.codex/locale` first when deciding the response language**
- If the project's `.codex/locale` exists, the agent MUST use it and IGNORE the global config
- The user's input language overrides the locale resolution entirely — locale is the fallback, not the override
- Always prefer the localized version when available
- Never modify the English originals in `standards/`
- When creating new standards documents, always provide translations in `standards/pt/` and `standards/es/`
- The `standards/README.md` in each locale documents what's available
