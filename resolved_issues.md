# Resolved Issues

Issues resolved from `known_issues.md`. See `standards/resolved-issue.md` for format.

### 4. IDs de issues arquivadas são reutilizados
- Resolved: 2026-10-14T21:07
- Durations: backlog=- waiting=- dev=- review=- qa=- publish=0h total=-
- Severity: high
- Type: bug
- Report: William Pereira
- Reviewers: 3
- Remote: #3
- Summary: O próximo ID usa o último ID ativo, sem calcular o máximo e sem consultar resolved_issues.md. Ordem diferente e concorrência também podem gerar duplicatas. — -

### 3. Discovery chama lint com argumentos incompatíveis
- Resolved: 2026-10-14T21:07
- Durations: backlog=- waiting=- dev=- review=- qa=- publish=0h total=-
- Severity: high
- Type: bug
- Report: William Pereira
- Reviewers: 3
- Remote: #2
- Summary: Os quatro loops prescrevem issue-lint.sh --strict <id>; scripts/issue-lint.sh:20 aceita apenas <id> --strict. A incompatibilidade também está nos agentes TOML. — -

### 2. Fechamento arquiva issue sem merge comprovado
- Resolved: 2026-10-14T21:07
- Durations: backlog=- waiting=- dev=- review=- qa=- publish=0h total=-
- Severity: high
- Type: bug
- Report: William Pereira
- Reviewers: 3
- Remote: #1
- Summary: PR OPEN/UNKNOWN apenas desliga o fechamento remoto; Jira terminal, arquivamento e remoção do tracker continuam. GitLab não verifica merge e ausência de PR não impede fechamento. — -

## Resolved Issues
Codex Flow configuration tracker. Historical records are in docs/legacy/.
