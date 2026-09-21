#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

if ! command -v codex >/dev/null 2>&1; then
  log "Codex is not installed; skipping Codex marketplace setup."
  exit 0
fi

marketplace_exists() {
  codex plugin marketplace list 2>/dev/null | awk -v marketplace="$1" '
    NR > 1 && $1 == marketplace { found = 1 }
    END { exit found ? 0 : 1 }
  '
}

ensure_marketplace() {
  name=$1
  source=$2

  if marketplace_exists "$name"; then
    log "$name Codex marketplace is already configured."
    return
  fi

  log "Adding $name Codex marketplace..."
  codex plugin marketplace add "$source"
}

if command -v wt >/dev/null 2>&1; then
  ensure_marketplace worktrunk max-sixty/worktrunk
else
  log "Worktrunk is not installed; skipping Worktrunk Codex marketplace setup."
fi

ensure_marketplace ponytail DietrichGebert/ponytail
