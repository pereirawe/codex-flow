## Codex Flow global configuration

Use `~/.codex/flow` for my global agents, skills, commands, scripts and standards.
Reply in the user's language. Preserve the selected project's business rules.
For implementation in a project using Codex Flow, load `.codex/AGENTS.md`,
the project workflow and relevant issue before editing. Prefer project-local
extensions over global definitions. Use discovery before untracked delivery;
develop stops at PR/MR creation; develop-full merges and archives after gates.
Use `~/.codex/flow/catalog/commands.json` to resolve old ocf:* commands, and
the agents/skills catalogs to resolve role/skill names. Read full instructions
only when relevant; do not inject the whole library into every conversation.
For historical context use flow-history and the private `.local/history/index.json`.
Read `~/.codex/flow/docs/runtime.md` for tool and permission adaptation.
