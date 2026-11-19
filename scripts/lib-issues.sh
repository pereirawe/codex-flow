#!/usr/bin/env bash
# lib-issues.sh — hybrid + monolith issue tracker helpers.
# Source after config.sh. Does not change globals except via helpers below.
#
# Modes:
#   hybrid   — .codex/issues/index.md exists (bodies in issues/<id>.md)
#   monolith — classic known_issues.md sections

issues_mode() {
  if [[ -f "${PROJECT_ISSUES_DIR}/issues/index.md" ]]; then
    echo hybrid
  else
    echo monolith
  fi
}

# Zero-pad id to 3+ digits for filenames (012.md); keeps numeric sort stable.
issue_pad() {
  local id="$1"
  printf '%03d' "$id" 2>/dev/null || printf '%s' "$id"
}

# Print absolute path to the canonical issue body (active or resolved).
# Exit 1 if missing.
issue_path() {
  local id="$1" pad mode
  pad="$(issue_pad "$id")"
  mode="$(issues_mode)"
  if [[ "$mode" == hybrid ]]; then
    if [[ -f "$PROJECT_ISSUES_DIR/issues/${pad}.md" ]]; then
      echo "$PROJECT_ISSUES_DIR/issues/${pad}.md"
      return 0
    fi
    if [[ -f "$PROJECT_ISSUES_DIR/issues/resolved/${pad}.md" ]]; then
      echo "$PROJECT_ISSUES_DIR/issues/resolved/${pad}.md"
      return 0
    fi
    # Unpadded fallback
    if [[ -f "$PROJECT_ISSUES_DIR/issues/${id}.md" ]]; then
      echo "$PROJECT_ISSUES_DIR/issues/${id}.md"
      return 0
    fi
    if [[ -f "$PROJECT_ISSUES_DIR/issues/resolved/${id}.md" ]]; then
      echo "$PROJECT_ISSUES_DIR/issues/resolved/${id}.md"
      return 0
    fi
    return 1
  fi
  # Monolith: the section lives inside known_issues / resolved
  if awk -v id="$id" '$0 ~ "^### " id "\\." {found=1} END {exit !found}' \
      "$PROJECT_ISSUES_FILE" 2>/dev/null; then
    echo "$PROJECT_ISSUES_FILE"
    return 0
  fi
  if [[ -f "$RESOLVED_FILE" ]] && awk -v id="$id" '$0 ~ "^### " id "\\." {found=1} END {exit !found}' \
      "$RESOLVED_FILE" 2>/dev/null; then
    echo "$RESOLVED_FILE"
    return 0
  fi
  return 1
}

# Print the ### N. … section for an id (stdout).
issue_section() {
  local id="$1" path mode
  mode="$(issues_mode)"
  if [[ "$mode" == hybrid ]]; then
    path="$(issue_path "$id")" || return 1
    cat "$path"
    return 0
  fi
  path="$(issue_path "$id")" || return 1
  awk -v id="$id" '
    $0 ~ "^### " id "\\." {found=1}
    found {
      if ($0 ~ /^### [0-9]+\./ && $0 !~ "^### " id "\\.") exit
      print
    }
  ' "$path"
}

# Replace or create hybrid body file from stdin; then touch index via caller.
issue_write_body() {
  local id="$1" pad dest
  pad="$(issue_pad "$id")"
  mkdir -p "$PROJECT_ISSUES_DIR/issues"
  dest="$PROJECT_ISSUES_DIR/issues/${pad}.md"
  cat >"$dest"
  echo "$dest"
}

# Extract a single-line field value from a section on stdin.
issue_field() {
  local name="$1"
  awk -v f="$name" '
    $0 ~ "^- " f ":" {sub("^- " f ": ?",""); print; exit}
  '
}

# Max issue id across active + resolved (hybrid or monolith).
issues_max_id() {
  local mode max=0
  mode="$(issues_mode)"
  if [[ "$mode" == hybrid ]]; then
    max=$(
      {
        ls "$PROJECT_ISSUES_DIR/issues/"*.md 2>/dev/null || true
        ls "$PROJECT_ISSUES_DIR/issues/resolved/"*.md 2>/dev/null || true
      } | xargs -n1 basename 2>/dev/null | sed 's/\.md$//' | sed 's/^0*//' | awk '
        /^[0-9]+$/ { if ($1+0 > m) m=$1+0 }
        END { print m+0 }
      '
    )
    # Also scan index + monolith leftovers
    local m2
    m2=$(awk '/^### [0-9]+\./ {n=$2+0; if(n>max)max=n} END {print max+0}' \
      "$PROJECT_ISSUES_FILE" <(cat "$RESOLVED_FILE" 2>/dev/null || true) \
      "$PROJECT_ISSUES_DIR/issues/index.md" 2>/dev/null || echo 0)
    if [[ "${m2:-0}" -gt "${max:-0}" ]]; then max=$m2; fi
    echo "${max:-0}"
    return 0
  fi
  awk '/^### [0-9]+\./ {n=$2+0; if(n>max)max=n} END {print max+0}' \
    "$PROJECT_ISSUES_FILE" <(cat "$RESOLVED_FILE" 2>/dev/null || true)
}
