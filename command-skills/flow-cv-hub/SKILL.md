---
name: flow-cv-hub
description: Build candidate resume hub (hub.json + README.md) from CV PDF + LinkedIn
  export
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

## $flow-cv-hub <candidate-directory>


Builds a candidate's data hub from the CV in PDF (required), the official
LinkedIn export (optional) and complementary files (optional). The hub
(`hub.json` + `README.md`) is the source of truth for generating tailored
resumes via `$flow-cv-tailor`.

### Official LinkedIn flow (only accepted way)

1. The user visits: <https://www.linkedin.com/mypreferences/d/download-my-data>
2. Chooses the option **"Baixe um arquivo de dados maior..."** (LinkedIn sends
   a link by email when the file is ready — takes a few days).
3. Unzips the `.zip` and tells the command the directory.

**NEVER** scrape linkedin.com (anonymous or logged in) — LinkedIn blocks it
and it violates the terms. Only the official export is accepted.

### Usage

```
$flow-cv-hub ~/career/maria-silva
```

- If the directory does not exist, create the structure:
  `hub.json`, `README.md`, `entradas/` (cv.pdf, linkedin/, extras/),
  `resumes/`.
- Ask the user where the following are: the CV PDF, the LinkedIn export
  directory (if any) and the extras (if any).

### Flow

1. **Collect sources** — the user provides the file paths; copy them into
   `entradas/`.
2. **Invoke the agent** `career/cv-extractor` via `task:` with the candidate
   directory and the source paths.
3. **Extract and consolidate** — the agent runs `pdftotext -layout` on the
   PDF, structures the LinkedIn export, consolidates everything into
   `hub.json` (canonical schema) and generates `README.md`.
4. **Validate** — `python3 $SCRIPTS_DIR/cv/validate.py hub.json`; fix until exit 0.
5. **Report** — `hub.json` path, whether validation passed, and a summary of
   the populated sections. Tell the user the next step is `$flow-cv-tailor`.

### Rules

- Minimum input: CV in PDF. LinkedIn and extras are optional.
- Nothing is invented — missing data stays missing; inferences are marked
  `[INFERIDO]`.
- Sensitive data (CPF, document, full address) does not enter the hub.
- The flow runs 100% locally, without network.

