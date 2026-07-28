#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

if ! command -v codex >/dev/null 2>&1; then
  log "Codex is not installed; skipping Worktrunk Codex marketplace setup."
  exit 0
fi

if ! command -v wt >/dev/null 2>&1; then
  log "Worktrunk is not installed; skipping Worktrunk Codex marketplace setup."
  exit 0
fi

if codex plugin marketplace list 2>/dev/null | awk '
    NR > 1 && $1 == "worktrunk" { found = 1 }
    END { exit found ? 0 : 1 }
'; then
  log "Worktrunk Codex marketplace is already configured."
  exit 0
fi

log "Adding Worktrunk Codex marketplace..."
codex plugin marketplace add max-sixty/worktrunk
