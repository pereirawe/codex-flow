## Known Issues

Single source of truth for tracked work in this project.

### Format

```markdown
### <id>. <title>

- Status: backlog | ready | open | in-progress | in-review | in-qa | in-publish | resolved
- Opened: <YYYY-MM-DD> | -
- Ready: <YYYY-MM-DD> | -
- Started: <YYYY-MM-DD> | -
- In review: <YYYY-MM-DD> | -
- In QA: <YYYY-MM-DD> | -
- In publish: <YYYY-MM-DD> | -
- Type: bug | feat | doc | chore
- Severity: critical | high | medium | low
- Report: <user-name> | <model-name>
- Base branch: <default-branch> | <branch-name>
- Reviewers: <number> (<profile1>, <profile2>)
- Remote: - | #<remote-id>
- Jira: - | <KEY-N>
- PR: - | #<pr-number>
- Location: <file-path>:<line-numbers>
- Description: <brief>
- Impact: <what or who is affected>
- Business rules: <specific business logic, constraints, and domain rules>
- Acceptance criteria: <what must be true for the issue to be complete>
- Tests: <scenario → outcome lines, defined during discovery>
- Suggested fix: <approach or next step>
```

`Business rules:` is required for `feat` type issues.
`Tests:` is MANDATORY for every new issue, captured during discovery as
`scenario → outcome` lines. For `doc`/`chore` types the literal `- Tests: -`
is permitted (no test surface). For `feat`/`bug` types at least one
`scenario → outcome` line is REQUIRED and the value may NEVER be `-`. Severity
floor: `critical`/`high` → ≥3 lines, `medium` → ≥2, `low` → ≥1; if `Severity`
is missing, the medium floor (≥2) applies. Enforcement is verified by QA
pre-development review (Phase 5) and senior reviewers — NOT enforced by
scripts. Missing or insufficient `Tests:` = `incomplete-spec` (discovery gap),
not a bug.
`Base branch:` is set during discovery (usually `main`/`master`).
`Reviewers:` stores count and profiles (set during discovery, e.g. `1 (backend)`).
`Remote:` is populated automatically during promotion, after local discovery.
`Jira:` is optional (default `-`) — the Jira Cloud card key (e.g. `DEV-123`)
mirrored from this issue when the Jira sync is enabled (issue #48), separate
from `Remote:`. Populated by `scripts/sync-jira.sh` (hooks in
create_issue.sh/promote.sh/close_issue.sh or the `ocf:sync-jira` command);
non-blocking, local `Status:` always wins.
`Opened:`/`Ready:`/`Started:`/`In review:`/`In QA:`/`In publish:` lifecycle
timestamps are stamped by the pipeline scripts (create_issue.sh on remote
creation success; promote.sh on backlog→ready and ready→in-progress;
transition.sh on in-progress→in-review→in-qa→in-publish; close_issue.sh stamps
`Resolved:` and computes `Durations:` into the archive — per-stage components
backlog/waiting/dev/review/qa/publish/total). Set-if-absent, idempotent, new
issues only. See `standards/issues.md` for the full contract.


### 1. Migrate global OpenCode workflows and project context to Codex
- Status: in-progress
- Type: feat
- Severity: high
- Priority: high

- Report: Codex
- Base branch: main
- Reviewers: 2 (security, devops)
- Remote: -
- Jira: -
- PR: -
- Location: -
- Description: Preserve the global workflow library and local project extensions while using native Codex skills and agents.
- Impact: 
- Business rules: Global definitions stay global; project context and overrides stay local. Preserve issue IDs and history. Keep credentials and exported chats private.
- Acceptance criteria: Native manifests validate. Installation preserves existing Codex settings. Project migration preserves trackers and extensions. Public package excludes private data.
- Tests: Repeat installation -> existing model/auth/settings remain intact.
Migrate and move a project -> issues and local skill links remain readable.
Untrusted multiline comment -> cannot authorize its author.
- Suggested fix: -

### 5. Promoção registra in-progress antes de conseguir a branch
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #4
- Jira: -
- PR: -
- Location: scripts/promote.sh:159
- Description: Base branch: - é o padrão canônico, mas só vazio é tratado como ausente. O status muda em :182 antes de checkout/create em :218. Falha deixa a issue em andamento sem a branch esperada.
- Impact: CF-AUDIT-04: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Normalizar vazio e -, detectar/persistir base e alterar status apenas depois de checkout/criação bem-sucedidos.
- Tests: Cenário auditado: Reprodução com base - → criação de branch falha após status alterado. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 6. Entrega omite commit/push e pode revisar diff vazio
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #5
- Jira: -
- PR: -
- Location: scripts/review-preflight.sh:131
- Description: develop/develop-full não explicitam commit e push. Preflight examina somente base...HEAD, ignora staged/unstaged e :215 permite aprovação trivial sem paths. create-pr.sh não faz commit/push.
- Impact: CF-AUDIT-05: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Definir commit/push no fluxo; recusar workspace dirty ou incluir seu diff e vincular revisão/publicação ao mesmo HEAD.
- Tests: Cenário auditado: Inspeção cruzada de ambos comandos, developer, review-preflight e create-pr. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 7. Gate de publicação não comprova todos os reviewers nem QA
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #6
- Jira: -
- PR: -
- Location: scripts/committer-check.sh:109
- Description: O script valida cache/status e relatório security quando solicitado, mas não evidências dos demais perfis nem QA; relatórios não são vinculados ao HEAD/fingerprint. Regras de negócio ausentes apenas geram WARN em :101.
- Impact: CF-AUDIT-06: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Registrar evidência estruturada por issue, HEAD e perfil; exigir todos os perfis e o contrato de QA, incluindo regras de negócio obrigatórias.
- Tests: Cenário auditado: Inspeção de todos gates e comparação com workflow.md:299 e committer.md:98. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 8. Merge sem referência de PR é tratado como continuidade normal
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #7
- Jira: -
- PR: -
- Location: scripts/merge-and-close.sh:80
- Description: Sem PR, o script imprime skipping merge, retorna à base e executa close_issue.sh.
- Impact: CF-AUDIT-07: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Falhar imediatamente se PR faltar; comprovar merge antes de fechar ou arquivar.
- Tests: Cenário auditado: Inspeção direta do caminho :80-89. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 9. PR perde campos multilinha da issue
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #8
- Jira: -
- PR: -
- Location: scripts/create-pr.sh:32
- Description: Description, Business rules, Acceptance criteria e Tests são extraídos só da linha - Field:. Linhas seguintes são descartadas.
- Impact: CF-AUDIT-08: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Reutilizar extração de campos multilinha e testar o corpo completo entregue ao provider simulado.
- Tests: Cenário auditado: Inspeção e comparação com o parser de bloco existente no preflight. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 10. 113 skills externas têm descrição apenas > ou >-
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #9
- Jira: -
- PR: -
- Location: scripts/flowctl.py:34
- Description: metadata() lê só a linha YAML; vendor_register propaga o marcador de folded scalar como descrição. O texto real fica invisível à seleção automática.
- Impact: CF-AUDIT-09: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Interpretar YAML multilinha corretamente, regenerar adapters e testar folded/literal scalars sem modificar clones upstream.
- Tests: Cenário auditado: Inventário instalado: 113 de 138 adapters afetados; exemplo motion-design/SKILL.md:3-8. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 11. Conversor PDF pode sobrescrever e apagar HTML existente
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #10
- Jira: -
- PR: -
- Location: scripts/shared/html-to-pdf.sh:137
- Description: Fallback LibreOffice copia a entrada para outdir/stem.html e depois remove esse caminho, mesmo que fosse um arquivo existente do usuário.
- Impact: CF-AUDIT-10: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Renderizar em diretório temporário exclusivo e publicar somente o PDF de modo atômico.
- Tests: Cenário auditado: LibreOffice simulado → PDF criado, exit 0, HTML anterior apagado. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 12. Backup anuncia sucesso quando rsync falha
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #11
- Jira: -
- PR: -
- Location: scripts/backup.sh:73
- Description: Qualquer falha de rsync é engolida; imprime Backup completed e atualiza latest.
- Impact: CF-AUDIT-11: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Propagar erro, validar a cópia e atualizar latest somente após sucesso; distinguir backup incompleto.
- Tests: Cenário auditado: Mock rsync retorna 23 → exit 0 e latest aponta para backup vazio. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 13. Watcher e CI classificam develop-full concluído como falha
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #12
- Jira: -
- PR: -
- Location: scripts/run-ci-workflow.sh:299
- Description: Só in-publish com PR no tracker ativo é aceito. develop-full termina em merge/arquivo, removendo a entrada ativa. watcher.sh:435 repete o contrato antigo.
- Impact: CF-AUDIT-12: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Ler também registro arquivado e estado do PR ou consumir resultado estruturado de develop-full.
- Tests: Cenário auditado: Inspeção cruzada dos dois motores e merge/archive. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 14. Falha real de execução sai com código zero no CI
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #13
- Jira: -
- PR: -
- Location: scripts/run-ci-workflow.sh:292
- Description: Quando run_develop falha, registra cannot-develop e executa exit 0. Actions vê sucesso apesar da falha de entrega.
- Impact: CF-AUDIT-13: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Retornar nonzero em falhas de execução, mantendo zero apenas para eventos ignorados por gates.
- Tests: Cenário auditado: Caminho de erro :292-296 confirmado estaticamente. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 15. CI exclui suites com contratos OpenCode ainda não adaptados
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #14
- Jira: -
- PR: -
- Location: scripts/tests/test_git_cred_cache.sh:237
- Description: Testes de cache Git, CV e carousel ainda exigem opencode.json removido. CI executa --core e não detecta essas falhas.
- Impact: CF-AUDIT-14: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Adaptar assertions a contratos Codex e incluir cobertura offline das ferramentas especializadas no CI; declarar skips por ambiente.
- Tests: Cenário auditado: git-cache: 106 passaram/5 falharam; carousel-gen: 59/8; CV: 551/17. Parte das falhas de rendering é limitação de sandbox, separada das referências ausentes confirmadas. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 16. Instruções herdadas contradizem tratamento de recusas e gates
- Status: backlog
- Type: bug
- Severity: medium
- Priority: medium

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #15
- Jira: -
- PR: -
- Location: agents/development/committer.md:61
- Description: discovery:77, developer:66, committer:61 e publish-requester:60 mandam esconder permission denials. committer:109 ainda manda não bloquear MR em gates falhos, exceto security. Os TOMLs repetem o texto.
- Impact: CF-AUDIT-15: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Remover instruções conflitantes nas duas representações; definir um contrato único de falha e visibilidade.
- Tests: Cenário auditado: Inspeção de quatro pares MD/TOML e comparação com contrato prefixado de stop/report. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 17. Número do PR não é salvo quando o campo não existe
- Status: backlog
- Type: bug
- Severity: low
- Priority: low

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #16
- Jira: -
- PR: -
- Location: scripts/create-pr.sh:88
- Description: Só substitui - PR:, sem inserir o campo em issues legadas; anuncia sucesso sem persistir referência.
- Impact: CF-AUDIT-16: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Fazer upsert e verificar a referência persistida antes de anunciar sucesso.
- Tests: Cenário auditado: Inspeção do awk :88-94. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 18. Fallback de base pode retornar origin/main
- Status: backlog
- Type: bug
- Severity: low
- Priority: low

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #17
- Jira: -
- PR: -
- Location: scripts/merge-and-close.sh:63
- Description: git rev-parse --abbrev-ref origin/HEAD devolve origin/main; checkout pode ficar detached e pull origin origin/main busca uma branch inexistente.
- Impact: CF-AUDIT-17: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Remover prefixo remoto, preservar branch com slash e validar a branch local antes de checkout/pull.
- Tests: Cenário auditado: Inspeção da resolução e dos comandos subsequentes. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 19. Check-pr mistura ID local e remoto na busca de branch
- Status: backlog
- Type: bug
- Severity: low
- Priority: low

- Flow: lean
- Report: William Pereira
- Base branch: main
- Reviewers: 3 (security, runtime, qa)
- Remote: #18
- Jira: -
- PR: -
- Location: command-skills/flow-check-pr/SKILL.md:44
- Description: Fallback procura issue-<remote-id>-*, mas promote usa o ID local. Busca por Issue: #<local-id> também não encontra um trailer ausente no body gerado.
- Impact: CF-AUDIT-18: integridade e funcionamento da configuração global Codex Flow.
- Business rules: -
- Acceptance criteria: Usar o ID local da branch e incluir vínculo explícito entre IDs local/remoto no corpo e no tracker.
- Tests: Cenário auditado: Inspeção de check-pr, promote e create-pr. → comportamento seguro esperado após a correção.
Falha de dependência ou pré-condição → código não zero e nenhum estado/arquivo indevidamente alterado.
Caminho válido e execução repetida → resultado esperado sem regressão nem duplicação.
- Suggested fix: -

### 20. Configurar permissões de desenvolvimento com opt-in e regras Git reutilizáveis
- Status: in-review
- Opened: 2026-10-14
- In review: 2026-10-14T21:29
- Type: chore
- Severity: low
- Priority: medium

- Report: William Pereira
- Base branch: main
- Reviewers: 2 (security, runtime)
- Remote: #20
- Jira: -
- PR: #21
- Location: scripts/; docs/runtime.md; templates/
- Description: Comandos Git rotineiros e operações de rede repetem solicitações de autorização. Disponibilizar configuração explícita de desenvolvimento com approval_policy on-request, sandbox workspace-write e network_access true; aplicar apenas por opt-in autorizado, preservando configurações pessoais existentes.
- Impact: Reduzir interrupções no desenvolvimento sem conceder acesso completo à máquina nem expor configurações privadas no repositório público.
- Business rules: Configuração privada, backups e credenciais não entram no Git. Não alterar autenticação, modelo ou plugins. Instalação comum não aplica permissões automaticamente. Permissões efetivas da sessão podem prevalecer sobre a configuração persistida. Não permitir git genérico, shell genérico, Python, curl ou push force genérico.
- Acceptance criteria: 1. TOML resultante é válido e preserva settings existentes não relacionados.
2. Regras reutilizáveis cobrem status, diff, log, show, rev-parse, ls-files, add, commit, switch -c, fetch e pull --ff-only, com sintaxe validada pelo Codex. Push, checkout, reset e clean não recebem regras amplas; rede habilitada e aprovações de comando são controles distintos.
3. Alteração depende de opt-in documentado e cria backup privado local antes de escrever.
4. Template e documentação públicos explicam workspace-write, rede habilitada, on-request e prevalência das permissões da sessão ativa.
5. Configuração pessoal, backups e segredos permanecem fora do versionamento; instalação normal mantém o comportamento atual.
- Tests: 1. Aplicar em TOML de exemplo com modelo, autenticação e plugins: validar TOML e preservação de campos.
2. Validar regras com Codex: operações Git previstas aceitas e comandos genéricos ou force não autorizados pelas novas regras.
3. Verificar opt-in, backup, idempotência e ausência de arquivos privados no Git.
- Suggested fix: -
