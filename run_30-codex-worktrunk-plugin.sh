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

has_worktrunk_marketplace() {
  codex plugin marketplace list 2>/dev/null | awk '
    NR > 1 && $1 == "worktrunk" { found = 1 }
    END { exit found ? 0 : 1 }
  '
}

if has_worktrunk_marketplace; then
  log "Worktrunk Codex marketplace is already configured."
  exit 0
fi

log "Adding Worktrunk Codex marketplace..."
codex plugin marketplace add max-sixty/worktrunk

if has_worktrunk_marketplace; then
  log "Worktrunk Codex marketplace configured."
else
  log "Worktrunk Codex marketplace was not found after install."
  exit 1
fi
