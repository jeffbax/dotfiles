#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

if ! command -v rtk >/dev/null 2>&1; then
  log "RTK is not installed; skipping OpenCode RTK plugin setup."
  exit 0
fi

if ! command -v opencode >/dev/null 2>&1; then
  log "OpenCode is not installed; skipping OpenCode RTK plugin setup."
  exit 0
fi

log "Installing or updating OpenCode RTK plugin..."
rtk init --global --opencode
