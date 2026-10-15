#!/usr/bin/env bash
# Verify provider merge state before any issue closure side effect.
flow_require_merged() {
  local pr="$1" state remote
  [[ "$pr" =~ ^[0-9]+$ ]] || { echo "A numeric PR/MR reference is required" >&2; return 1; }
  remote=$(git config --get remote.origin.url) || return 1
  case "$remote" in
    *github.com*) state=$(gh pr view "$pr" --json state --jq '.state') || return 1; [[ "$state" == MERGED ]] ;;
    *gitlab*) state=$(glab mr view "$pr" --output json | python3 -c 'import json,sys; print(json.load(sys.stdin).get("state", ""))') || return 1; [[ "$state" == merged || "$state" == MERGED ]] ;;
    *) echo "Unsupported remote host" >&2; return 1 ;;
  esac || { echo "PR/MR #$pr is not proven merged (state: $state)" >&2; return 1; }
}
