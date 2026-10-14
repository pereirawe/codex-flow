#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="${CODEX_VERSION:-}"; registry="${REGISTRY:-ghcr.io/pereirawe/codex-flow}"; push=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) version="${2:?version required}"; shift 2 ;;
    --registry) registry="${2:?registry required}"; shift 2 ;;
    --push) push=true; shift ;;
    --help|-h) echo 'Usage: build-codex-image.sh --version <published-codex-version> [--registry <image>] [--push]'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
[[ -n "$version" ]] || { echo 'Specify a published @openai/codex version with --version or CODEX_VERSION.' >&2; exit 2; }
release="$(cat "$ROOT/VERSION")"
docker build --build-arg "CODEX_VERSION=$version" --tag "$registry:v$release" --tag "$registry:latest" "$ROOT"
if $push; then docker push "$registry:v$release"; docker push "$registry:latest"; fi
