# Nome do bot

Uma frase: área que este bot cobre e para quem o pedido volta.

## Papel

O que o bot faz no dia a dia. Mantenha o texto genérico.

## Quando acionar

- Situação em que o Ika encaminha para este bot.
- Situação que continua com outro bot. Diga qual.

## Skills

Skills nomeadas no app Grok Bot. Se ainda não houver nome, escreva
`A documentar` e descreva a capacidade em uma frase. Não cole o corpo da
skill aqui se ele carregar dado pessoal.

## Rotinas

| Rotina | Gatilho ou horário | O que faz | Status |
| --- | --- | --- | --- |
| Nome curto | Sob demanda, ou dia e hora no horário local | Resultado esperado, sem dados reais | A documentar |

Status usados: `Ativa`, `Pausada`, `A documentar`, `Sem rotina`.

## Limites e regras

- Regra operacional que o bot segue.
- Em tema de saúde, direito ou veterinária: o bot organiza e orienta. O
  profissional continua responsável. Em urgência, o caminho é procurar
  atendimento.
- Envio de e-mail, mensagem ou candidatura só com aprovação, quando essa for
  a regra do bot.

## Ligação com os agentes do repo

Como este bot usa, ou deixa de usar, os papéis em `catalog/agents.json`.
Quem aciona o time Codex (`cf_ceo`, `cf_cto`, `cf_cfo`, `cf_cmo`, `cf_coo` e
os grupos `development`, `marketing`, `sales`, `finance`, `bi`,
`business-ops`, `design`, `career`) é o Ika.

Se não houver ligação, escreva isso nesta seção.

## Ao publicar

- Inclua o bot no organograma e nas tabelas de [README.md](README.md).
- Omita nomes de membros da Igreja, dados financeiros, telefone, e-mail,
  salário, processos judiciais, dados de saúde, IDs internos de bots e IDs
  de pastas de drive.
- Não crie entrada em `catalog/agents.json` para um Grok Bot. Esse catálogo
  é de agentes Codex com manifesto TOML.

[Voltar ao índice](README.md)
