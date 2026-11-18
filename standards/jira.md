# Jira Cloud (Codex Flow)

Shared conventions for Jira across every project that uses this flow.
Read this when configuring sync, creating spaces/boards, or using the Atlassian MCP.

## Layers

| Layer | Path / tool | Role |
|-------|-------------|------|
| Interactive agent | Atlassian Rovo MCP (`plugin-atlassian-atlassian`) | Search, create/edit issues, comments, boards |
| Pipeline sync | `scripts/sync-jira.sh` + `$flow-sync-jira` | Mirror `known_issues.md` → cards/transitions |
| Skill | `cf-jira` (`skills/shared/jira/`) | Portfolio map, setup, MCP + sync usage |
| Product registry | `config/jira/registry.json` | Keys, names, local repo folders |
| Site defaults | `config/jira/defaults.json` | `baseUrl` + `email` (local; copy from `.example`) |
| Per project | `.codex/jira.json` | Must set `projectKey`; may override defaults |

Token is **never** stored in JSON. Use env only: `JIRA_API_TOKEN`.

## Config resolution (`jira_config_load`)

Per field, highest wins:

1. Environment (`JIRA_BASE_URL`, `JIRA_PROJECT_KEY`, `JIRA_EMAIL`, `JIRA_AUTH_MODE`, `JIRA_STATUS_MAP`)
2. Project `.codex/jira.json` (or `JIRA_CONFIG_FILE`)
3. Global `config/jira/defaults.json` (`baseUrl`, `email`, optional `statusMap` / `authMode` only — never a portfolio-wide `projectKey`)

Sync is enabled only when `baseUrl`, `projectKey`, `email`, and `JIRA_API_TOKEN` are all set.

### Project file shape

```json
{
  "baseUrl": "https://your-domain.atlassian.net",
  "email": "you@example.com",
  "projectKey": "DEV",
  "statusMap": {
    "backlog": "To Do",
    "ready": "To Do",
    "in-progress": "In Progress",
    "in-review": "In Review",
    "in-qa": "QA/Testing",
    "in-publish": "Ready for Release",
    "resolved": "Done"
  }
}
```

Bootstrap with `scripts/jira-init.sh` (looks up the CWD repo in `config/jira/registry.json`).

Keep `jira.json` out of git (add to `.codex/.gitignore`).

## Status map defaults

| Local `Status:` | Jira status name |
|-----------------|------------------|
| backlog, ready | To Do |
| in-progress | In Progress |
| in-review | In Review |
| in-qa | QA/Testing |
| in-publish | Ready for Release |
| resolved | Done |

Override via `statusMap` in project or defaults JSON, or `JIRA_STATUS_MAP` (JSON string).

## MCP (Atlassian Rovo)

- Endpoint: `https://mcp.atlassian.com/v2/mcp` (Cursor plugin **Atlassian**)
- Prefer MCP for interactive backlog work; keep `sync-jira.sh` for pipeline mirroring
- Creating Jira **spaces** needs admin-enabled `manage_jira` (`createJiraProject` / scope `manage:jira:agent-interface`)
- Admin path: Atlassian Administration → Rovo → Rovo MCP server → Permissions

Team-managed Kanban template (REST):  
`com.pyxis.greenhopper.jira:gh-simplified-agility-kanban`

## Conventions

- One Jira space (project key) per product; marketing/leads stay on their own key when separate from engineering
- Local `Status:` always wins over Jira; sync is non-blocking
- `Jira:` on issues is optional and independent of `Remote:` (GitHub/GitLab)
- Do not log or commit `JIRA_API_TOKEN`

## Related

- Skill: `cf-jira`
- Command: `$flow-sync-jira`
- Scripts: `sync-jira.sh`, `jira-init.sh`
- Registry: `config/jira/registry.json`
- Broader MCP notes: `standards/mcp-registry.md`
