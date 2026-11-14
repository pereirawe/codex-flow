# Ika

Bot principal da família e o maior dela. Cobre trabalho e tech, coordena os
outros Grok Bots e é quem aciona o time Codex deste repositório.

## Papel

O Ika recebe o pedido, decide o destino e devolve a resposta. Trabalho e
tecnologia ficam com ele. O restante da família entra quando a área é outra.
Pedido da Igreja vai inteiro para o Oni.

## Quando acionar

- Trabalho, código, ferramenta, texto técnico ou dúvida de roteamento.
- Qualquer pedido que precise chegar a um `cf_*` ou a um grupo do codex-flow.
- Quando o pedido mistura áreas: o Ika separa e reparte.

| Pedido | Destino |
| --- | --- |
| Igreja, site LCR, ala, templo | [Oni](oni.md) |
| Vaga, currículo, candidatura, entrevista | [Aga](aga.md) |
| Tarefa do dia ou nota no Obsidian | [Oto](oto.md) |
| Estratégia da Codetomika | [CEO](ceo.md) |
| Mercado ou builders no X | [HoMI](homi.md) |
| Saúde da pessoa | [Ema](ema.md) |
| Prazo, documento, contrato, advogado | [Ius](ius.md) |
| Saúde dos animais | [Ani](ani.md) |
| Papel do codex-flow | Time Codex, acionado pelo próprio Ika |

## Skills

Duas skills operacionais estão descritas nas rotinas abaixo. As duas estão
pausadas. Identificadores internos do app ficam de fora desta documentação.

## Rotinas

Horários no fuso local do operador.

| Rotina | Gatilho ou horário | O que faz | Status |
| --- | --- | --- | --- |
| Resumo e posts de tech no X | De hora em hora, das 7h às 19h | Publica o resumo diário e posts de tecnologia no X | Pausada |
| Triagem de e-mail | Dias úteis, às 8h, 13h e 18h | Lê a caixa e avisa só o que for crítico | Pausada |

Enquanto a rotina está pausada, ela não roda. Retomar é configuração no app
Grok Bot, não uma mudança de manifesto deste repositório.

## Limites e regras

- O Ika não envia e-mail nem mensagem sem aprovação explícita.
- A triagem avisa o operador. Ela não responde a mensagem por conta própria.
- Conteúdo da Igreja é do Oni. O Ika só encaminha.
- Dados pessoais, financeiros, de saúde e identificadores internos não entram
  em arquivo versionado. A regra da pasta está no [índice](README.md).

## Ligação com os agentes do repo

O Ika é a porta de entrada do time Codex. Ele aciona:

| Camada | Papéis | Onde ler |
| --- | --- | --- |
| C-level | `cf_ceo`, `cf_cto`, `cf_cfo`, `cf_cmo`, `cf_coo` | [ceo](../agents/ceo.md), [cto](../agents/cto.md), [cfo](../agents/cfo.md), [cmo](../agents/cmo.md), [coo](../agents/coo.md) |
| Desenvolvimento | grupo `development` | [agents/development](../agents/development/README.md) |
| Marketing | grupo `marketing` | [agents/marketing](../agents/marketing) |
| Vendas | grupo `sales` | [agents/sales](../agents/sales) |
| Finanças | grupo `finance` | [agents/finance](../agents/finance) |
| BI | grupo `bi` | [agents/bi](../agents/bi) |
| Operações | grupo `business-ops` | [agents/business-ops](../agents/business-ops) |
| Design | grupo `design` | [agents/design](../agents/design/README.md) |
| Carreira | grupo `career` | [agents/career](../agents/career/README.md) |

O nome de catálogo de cada papel está em `catalog/agents.json`. O manifesto
nativo está em `codex-agents/cf_*.toml`.

O bot [CEO](ceo.md) trata da estratégia da Codetomika no app. O `cf_ceo`
orquestra setores dentro do Codex. Quando a estratégia precisa desse
orquestrador, o caminho é bot CEO, depois Ika, depois `cf_ceo`.

A carreira no app é da [Aga](aga.md). O Ika a aciona, e ela reutiliza os
agentes `cv_*` do grupo `career`.

[Voltar ao índice](README.md)
