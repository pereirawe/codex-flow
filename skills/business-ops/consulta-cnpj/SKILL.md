---
name: cf-consulta-cnpj
description: Look up Brazilian company registry data by CNPJ for contract qualification,
  client onboarding, and commercial discovery. Use when the user asks for CNPJ lookup,
  cadastro de empresa, qualificação contratual, or "consulta cnpj".
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

# Consulta CNPJ

Extract cadastral data for contract qualification and client folders.

## Usage

```bash
bash ~/.codex/flow/scripts/commercial/consulta-cnpj.sh <CNPJ>
bash ~/.codex/flow/scripts/commercial/consulta-cnpj.sh <CNPJ> --json
```

Accepts masked or raw CNPJ. Exit 2 on bad input; exit 1 if sources fail.

## Sources

1. ReceitaWS (~3 req/min)
2. BrasilAPI (fallback)

If both fail, ask the client for documents — never invent CPF, representative,
or operational contacts.

## Limits

API data may show accountant email/phone. Mark operational fields
`[CONFIRMAR]` until the client validates.
