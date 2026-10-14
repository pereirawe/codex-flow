# Locale System

Locale is stored as a **plain text file**, not in `opencode.json`, to avoid
`ConfigInvalidError` (the schema rejects unknown top-level keys).

## File locations

| Scope  | Path                       | Default content |
|--------|----------------------------|-----------------|
| Global | `~/.codex/flow/locale`  | `pt`            |
| Project| `.codex/locale`           | `en`            |

Project locale overrides global locale.

## Resolution order

1. `.codex/locale` in the project directory
2. `~/.codex/flow/locale` (global fallback)
3. If neither exists, defaults to `en` (English)

## Supported values

- `pt` — Português
- `es` — Español
- `en` — English

Localized standards are loaded from `standards/{locale}/` (e.g., `standards/pt/`).
When a localized file does not exist, the English version in `standards/` is used.

## Setup for new projects

The `$flow-$flow-init` command asks the user which locale to use and writes it to
`.codex/locale`. Alternatively, create or edit the file manually:

```bash
echo "pt" > .codex/locale
```
