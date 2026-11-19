# Standard: proposta comercial

Skill: `cf-proposal-writer` · Command: `$flow-proposal <slug>`.

## Pricing

Read `.codex/brand/pricing.md` and `brand.profile.json` — **never** hardcode
rates in global Flow files. Use `{{hourly_rate_formatted}}` in templates.

## Templates (A / B / C)

| Padrão | File | Use |
|--------|------|-----|
| A | `templates/commercial/proposta/proposta.md` | Custom software |
| B | `templates/commercial/proposta/proposta-cto-externo.md` | CTO externo / retainer |
| C | `templates/commercial/proposta/proposta-diagnostico.md` | Discovery / diagnóstico |

## Toolchain

```bash
python3 ~/.codex/flow/scripts/commercial/proposal.py validate docs/specs/<slug>/proposal-data.json
python3 ~/.codex/flow/scripts/commercial/proposal.py build …
python3 ~/.codex/flow/scripts/commercial/render_docx.py …
node ~/.codex/flow/scripts/commercial/render_diagrams.cjs …
bash ~/.codex/flow/scripts/shared/convert-md.sh …
```

JSON manifest schema: same as `proposal.py` (`schema_version: 1`).

## Output

Prefer `docs/specs/<slug>/proposal.md` for Flow projects; commercial hub:
`docs/clientes/<slug>/proposta/proposta-<slug>.md`.
