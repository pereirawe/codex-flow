#!/usr/bin/env bash
# novo-cliente.sh — scaffold commercial hub + spec workspace for a client slug.
#
# Usage (from project root):
#   bash ~/.codex/flow/scripts/commercial/novo-cliente.sh <slug>
#
# Creates docs/clientes/<slug>/ (discovery, tech-spec, proposta, contrato,
# acompanhamento) from neutral Flow templates, runs spec-init for docs/specs/,
# and substitutes {{placeholders}} from .codex/brand/ when present.

set -euo pipefail

SLUG="${1:-}"
if [[ -z "$SLUG" ]]; then
  echo "Usage: $0 <slug>" >&2
  exit 2
fi

FLOW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
cd "$ROOT"

bash "$FLOW/scripts/spec-init.sh" "$SLUG" >/dev/null

SLUG_CLEAN="$(echo "$SLUG" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')"
BASE="docs/clientes/${SLUG_CLEAN}"
mkdir -p "$BASE/discovery" "$BASE/tech-spec" "$BASE/proposta" "$BASE/contrato" "$BASE/acompanhamento/assets"

copy_template() {
  local src="$1" dest="$2"
  python3 "$FLOW/scripts/lib-brand.py" apply --root "$ROOT" < "$src" > "$dest"
}

printf '# %s\n' "$SLUG_CLEAN" > "$BASE/README.md"
for d in discovery tech-spec proposta contrato acompanhamento; do
  printf '# %s — %s\n' "$d" "$SLUG_CLEAN" > "$BASE/$d/README.md"
done

TPL="$FLOW/templates/commercial"
copy_template "$TPL/discovery/discovery.md" "$BASE/discovery/discovery.md"
copy_template "$TPL/tech-spec/tech-spec.md" "$BASE/tech-spec/tech-spec.md"
copy_template "$TPL/proposta/proposta.md" "$BASE/proposta/proposta-${SLUG_CLEAN}.md"
copy_template "$TPL/acompanhamento/progress-report.md" "$BASE/acompanhamento/$(date +%Y-%m-%d)-progress-report.md"

LOGO="$(python3 "$FLOW/scripts/lib-brand.py" --root "$ROOT" logo-path 2>/dev/null || true)"
if [[ -n "$LOGO" && -f "$ROOT/$LOGO" ]]; then
  ext="${LOGO##*.}"
  cp "$ROOT/$LOGO" "$BASE/acompanhamento/assets/logo.${ext}"
  mkdir -p "$BASE/proposta/assets"
  cp "$ROOT/$LOGO" "$BASE/proposta/assets/logo.${ext}"
fi

echo "client hub: $BASE"
echo "spec workspace: docs/specs/${SLUG_CLEAN}"
echo "brand: ${LOGO:-(none — add .codex/brand/brand.profile.json + logo)}"
