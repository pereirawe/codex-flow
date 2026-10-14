# Codex Flow scripts

Run global scripts by absolute path with the project as CWD. config.sh resolves
the checkout root and .codex/known_issues.md; inside this configuration repo it
uses the root tracker. An uninitialized Git project is rejected instead of
silently writing project issues globally.

Native integration: flowctl.py, init.sh, codex-run.sh, setup-aibot-watcher.sh,
restore-vendors.py and validate.py. Existing issue lifecycle and specialist
scripts are preserved; consult their relevant skills for usage/dependencies.
No active script requires an OpenCode web server or configuration JSON.
Notifications require explicit workflow/user authorization and local credentials.

Jira synchronization: sync-jira.sh uses local config/env and is disabled when absent.
