# CEO

Estratégia de negócio da Codetomika, no app Grok Bot.

Este bot é o assistente de estratégia da Codetomika no app Grok Bot. O agente
Codex `cf_ceo` é outro papel: vive em [agents/ceo.md](../agents/ceo.md),
orquestra setores dentro do Codex e entra em cena quando o [Ika](ika.md)
aciona o time do repositório.

## Papel

O CEO acompanha a direção da Codetomika: prioridade, posicionamento e a
próxima decisão de negócio. A execução nos papéis deste repositório fica com
o time Codex, disparada pelo Ika.

## Quando acionar

- Decisão de rumo, oferta ou prioridade da Codetomika.
- Pedido que precise de uma leitura de negócio antes de virar trabalho no
  codex-flow.

Mercado e observação de builders no X ficam com o [HoMI](homi.md). Contrato e
prazo ficam com o [Ius](ius.md). Vaga de emprego fica com a [Aga](aga.md).

## Skills

A documentar. A capacidade conhecida é a leitura de estratégia da
Codetomika. Não há skill nomeada deste bot versionada no codex-flow.

## Rotinas

| Rotina | Gatilho ou horário | O que faz | Status |
| --- | --- | --- | --- |
| — | — | — | A documentar |

## Limites e regras

- Números financeiros, salário, contrato assinado e dado de cliente ficam
  fora deste repositório. Aqui só entra o papel.
- O bot prepara a decisão. Quem decide é o operador.

## Ligação com os agentes do repo

O caminho de execução é CEO (este bot), depois Ika, depois o time Codex. O
Ika aciona `cf_ceo` quando a estratégia precisa do orquestrador, e os grupos
`marketing`, `sales`, `finance`, `bi`, `business-ops`, `development` e
`design` quando a decisão já tem dono setorial. `cf_cfo`, `cf_cmo`, `cf_cto`
e `cf_coo` entram pelo mesmo caminho, cada um na sua frente.

A lista de papéis está em [ika.md](ika.md).

[Voltar ao índice](README.md)
