#!/usr/bin/env bash
# consulta-cnpj.sh — extrai dados cadastrais de empresa pelo CNPJ.
#
# Usage (from project root):
#   bash ~/.codex/flow/scripts/commercial/consulta-cnpj.sh <CNPJ> [--json]
#
# Sources: ReceitaWS → BrasilAPI. See skills/business-ops/consulta-cnpj/SKILL.md.

set -euo pipefail

CNPJ_RAW="${1:-}"
MODE="${2:-md}"

DIGITS="$(echo "$CNPJ_RAW" | tr -cd '0-9')"
if [[ "${#DIGITS}" != 14 ]]; then
  echo "Usage: $0 <14-digit CNPJ> [--json]" >&2
  exit 2
fi

fetch() {
  local url="$1" i out
  for i in 1 2 3; do
    out="$(curl -s --max-time 25 -H 'User-Agent: codex-flow-commercial/1.0' "$url" 2>/dev/null)"
    if [[ -n "$out" ]] && echo "$out" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null; then
      echo "$out"
      return 0
    fi
    sleep 5
  done
  return 1
}

JSON=""
if JSON="$(fetch "https://www.receitaws.com.br/v1/cnpj/${DIGITS}")" \
  && echo "$JSON" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if str(d.get('status','')).strip()=='OK' else 1)" 2>/dev/null; then
  SRC="receitaws"
elif JSON="$(fetch "https://brasilapi.com.br/api/cnpj/v1/${DIGITS}")" \
  && echo "$JSON" | python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('cnpj') else 1)" 2>/dev/null; then
  SRC="brasilapi"
else
  echo "error: CNPJ $DIGITS not found or sources unavailable (receitaws, brasilapi)" >&2
  exit 1
fi

if [[ "$MODE" == "--json" ]]; then
  echo "$JSON" | python3 -m json.tool
  exit 0
fi

JSON="$JSON" SRC="$SRC" python3 <<'EOF'
import json, os, sys

d = json.loads(os.environ["JSON"])
src = os.environ.get("SRC", "?")

def g(*keys):
    for k in keys:
        v = d.get(k)
        if v:
            return v
    return ""

cnpj = g("cnpj")
cnpj_f = f"{cnpj[0:2]}.{cnpj[2:5]}.{cnpj[5:8]}/{cnpj[8:12]}-{cnpj[12:14]}" if len(cnpj) == 14 else cnpj

if src == "brasilapi":
    end = f"{g('logradouro')}, {g('numero')} {g('complemento')}".strip().strip(",")
    city = f"{g('municipio')}/{g('uf')} — CEP {g('cep')}"
    addr = f"{end}, {city}".strip(", ")
    socios = [f"{s.get('nome','')} ({s.get('qualificacao_socio','')})".strip() for s in d.get("qsa") or []]
    situ, abert = g("situacao_cadastral"), g("data_inicio_atividade")
    nat, porte = g("natureza_juridica"), g("porte")
    email, tel = g("email"), g("telefone")
    simples = d.get("opcao_pelo_simples")
    simples_s = "Sim" if simples else ("Não" if simples is False else "")
    cap = g("capital_social")
else:
    end = f"{g('logradouro')}, {g('numero')} {g('complemento')}".strip().strip(",")
    city = f"{g('municipio')}/{g('uf')} — CEP {g('cep')}"
    addr = f"{end}, {g('bairro')}, {city}".strip(", ")
    socios = [f"{s.get('nome','')} ({s.get('qual','')})".strip() for s in d.get("qsa") or []]
    situ, abert = g("situacao"), g("abertura")
    nat, porte = g("natureza_juridica"), g("porte")
    email, tel = g("email"), g("telefone")
    s = d.get("simples") or {}
    simples_s = "Sim" if s.get("optante") else ("Não" if s else "")
    cap = g("capital_social")

nome, fant = g("nome", "razao_social"), g("fantasia", "nome_fantasia")

print(f"# {nome} ({fant}) — {cnpj_f}")
print(f"\n> Fonte: {src} · extraído para qualificação contratual. E-mail/tel da API costumam ser do contador — confirmar os operacionais.")
print(f"\n- Razão social: {nome}")
print(f"- Fantasia: {fant}")
print(f"- CNPJ: {cnpj_f} · Tipo: {g('tipo', 'matriz_filial') or '—'} · Situação: {situ or '—'} (desde {g('data_situacao') or abert or '—'})")
print(f"- Abertura: {abert or '—'} · Porte: {porte or '—'} · Natureza: {nat or '—'}")
print(f"- Endereço: {addr or '—'}")
print(f"- E-mail (API): {email or '—'} · Telefone (API): {tel or '—'}")
print(f"- Capital social: {cap or '—'} · Simples: {simples_s or '—'}")
print(f"- Sócios: {'; '.join(socios) if socios else '—'}")
print(f"\n## Linha de qualificação (contrato)")
print(f"\n{nome}, pessoa jurídica de direito privado, inscrita no CNPJ sob o nº {cnpj_f}, com sede em {addr or '[ENDEREÇO]'}, neste ato representada por [NOME], [NACIONALIDADE], [ESTADO CIVIL], CPF nº [CPF]")
print(f"\n## Confirmar com o cliente")
print("\n- [ ] CPF, nacionalidade e estado civil do representante")
print("- [ ] E-mail/telefone operacionais (ponto focal técnico e financeiro)")
print("- [ ] Dados para NF (e-mail de envio) e meio de pagamento")
EOF
