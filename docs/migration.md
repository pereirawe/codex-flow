# Migration report

Prepared on 2026-10-14 from pereirawe/opencode-flow.

- 100 own skills converted to native manifests.
- 116 agent role definitions converted to standalone Codex TOML files.
- 37 command skill entrypoints, including discovery, develop and develop-full.
- 19 upstream Git clones preserved locally; 139 upstream skills inventoried.
- 413 old sessions and 17,508 messages exported privately into .local/history.
- Global library and project context are separate. Project skills/commands use relative adapters and links.
- Target projects: codetomika-landing-page, dia-da-educacao-2026, revanca, isynve.

## Verification

Native manifest/catalog/script syntax validation passed. Eight isolated migration tests passed, including repeat installation, repeat project initialization, relocation, preservation of Codex settings and issue records. Three automation authorization/argument tests passed. Seven core shell test groups passed (issue lint, timestamps, Jira sync, remote detection, language, committer gate and test runner). Independent security and architecture reviews approved the corrected package.

Extended specialist tests retain old runtime assertions and require local media/browser dependencies. They are not part of the core migration acceptance suite; a real browser/model/API end-to-end run was not completed. No production merges, notifications or deployments were performed.

## Runtime differences

OpenCode's web server, nginx frontend, session-reset helpers and DCP plugin are retired. The app/CLI and codex exec replace interaction/headless execution. Existing Codex auth/models/providers stay intact. Original role scope restrictions are retained as behavioral instructions and source metadata; they are not separate Codex permission sandboxes. Original files remain available for rollback. Historical trackers remain under docs/legacy and conversations are evidence, not native sessions.

## Installation and publication status

Published at https://github.com/pereirawe/codex-flow on 2026-10-14 using the existing pereirawe SSH configuration.
The global library is installed at ~/.codex/flow, with 100 own skills plus 37 command entrypoints and 138 discoverable external skills under ~/.codex/skills, and 116 native agents under ~/.codex/agents. Existing Codex model settings and authentication were preserved. The compatibility skills directory was selected because the managed sandbox cannot create ~/.agents; the installer retains this selected location for updates and vendor registration.

Project context was migrated in the real destinations: codetomika-landing-page, dia-da-educacao-2026, revanca and isynve. Issue IDs and project-specific extensions are preserved, and original .opencode directories remain as rollback copies. Configuration changes in the project checkouts remain local for review; no application source code, deployment or production database was changed. The watcher was not activated.
