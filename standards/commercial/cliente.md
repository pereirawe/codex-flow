# Standard: cliente (commercial hub)

## Novo cliente

```bash
bash ~/.codex/flow/scripts/commercial/novo-cliente.sh <slug>
```

Creates `docs/clientes/<slug>/{discovery,tech-spec,proposta,contrato,acompanhamento}/`
from `templates/commercial/`, and runs `scripts/spec-init.sh` for
`docs/specs/<slug>/`.

## Slug

Lowercase, hyphenated (e.g. `dia-educacao-2026`).

## Brand

Read `.codex/brand/` before drafting (see `docs/brand.md`). Templates use
`{{company}}`, `{{issuer}}`, `{{logo_path}}`, `{{hourly_rate_formatted}}`.
