# Global agent roles

Role instructions retain their sector organization here. catalog/agents.json
maps original identifiers to native Codex names and TOML files in codex-agents/.
The installer exposes these at ~/.codex/agents/. Roles inherit model/permissions.
Project roles and policies take precedence. If a surface cannot select a custom
native role, read its instructions and provide them to an available subagent.
Do not claim independent review when only self-review was possible.

## Família de Grok Bots

The roles on this page are Codex agents. The Grok Bot family is a separate
surface, documented in [grok-bots/](../grok-bots/README.md). Ika coordinates
those bots and invokes this team: `cf_ceo`, `cf_cto`, `cf_cfo`, `cf_cmo`,
`cf_coo`, and the groups development, marketing, sales, finance, bi,
business-ops, design and career. Aga reuses the career CV agents; the stage
map is in [grok-bots/aga.md](../grok-bots/aga.md).
