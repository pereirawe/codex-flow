# Project brand override

Global Flow skills and scripts stay **neutral**. Company name, logo, locale,
and default hourly rate live in the **project**, not in `~/.codex/flow`.

## Layout

```text
.codex/brand/
  brand.profile.json    # issuer identity, locale, optional hourly_rate
  pricing.md            # hourly_rate, currency (overrides when profile omits rate)
  logo.png              # or path in brand.profile.json → logo_path
  positioning.md        # optional editorial guardrails
  tokens.md             # optional colors/typography for PDF/HTML
  contract.masters/     # optional local contract templates
```

Copy examples from `~/.codex/flow/standards/brand/`.

## Precedence

1. Project files under `.codex/brand/` and `docs/specs/<slug>/proposal-data.json`
2. Project `docs/assets/logo.*`
3. Flow fallbacks (`~/.codex/flow/assets/logo.*`) — dev only

Local skills, agents, and `.codex/AGENTS.md` still override global `cf-*`
definitions when names collide.

## Scripts that read brand

| Script | Use |
|--------|-----|
| `scripts/lib-brand.py` | Placeholders `{{company}}`, `{{logo_path}}`, `{{hourly_rate}}` |
| `scripts/spec-init.sh` | Copies logo into `docs/specs/<slug>/assets/` |
| `scripts/commercial/novo-cliente.sh` | Scaffolds `docs/clientes/<slug>/` with substituted templates |
| `scripts/commercial/proposal.py` | Uses `proposal-data.json` per spec (issuer logo path) |
| `scripts/progress-report.sh` | Project assets for PDF (see `cf-progress-report`) |

## Quick start

```bash
mkdir -p .codex/brand
cp ~/.codex/flow/standards/brand/brand.profile.json.example .codex/brand/brand.profile.json
cp ~/.codex/flow/standards/brand/pricing.md.example .codex/brand/pricing.md
cp /path/to/logo.png .codex/brand/logo.png

bash ~/.codex/flow/scripts/commercial/novo-cliente.sh my-client
bash ~/.codex/flow/scripts/spec-init.sh my-client
```

Inspect resolved placeholders:

```bash
python3 ~/.codex/flow/scripts/lib-brand.py placeholders
```
