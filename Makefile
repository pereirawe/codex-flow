SHELL := /bin/bash
ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
.PHONY: install init bootstrap validate test-scripts promote close-issue sync-issues update backup
install:
	@bash $(ROOT)install.sh
init bootstrap:
	@bash $(ROOT)scripts/init.sh "$(target)" "$(locale)"
validate:
	@python3 $(ROOT)scripts/validate.py
test-scripts:
	@bash $(ROOT)scripts/tests/run_all.sh
promote:
	@bash $(ROOT)scripts/promote.sh $(id)
close-issue:
	@bash $(ROOT)scripts/close_issue.sh $(id)
sync-issues:
	@bash $(ROOT)scripts/sync_github_issues.sh
update:
	@bash $(ROOT)scripts/update.sh
backup:
	@bash $(ROOT)scripts/backup.sh "$(dir)" "$(name)"
