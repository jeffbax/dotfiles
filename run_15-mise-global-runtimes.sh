#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

if ! command -v mise >/dev/null 2>&1; then
  log "mise is not installed; skipping global runtime setup."
  exit 0
fi

has_global_tool() {
  tool="$1"

  mise ls --global --no-header "$tool" 2>/dev/null | awk -v tool="$tool" '
    $1 == tool { found = 1 }
    END { exit found ? 0 : 1 }
  '
}

ensure_global_tool() {
  tool="$1"

  if has_global_tool "$tool"; then
    log "mise global $tool is already configured."
    return 0
  fi

  log "Pinning latest stable $tool with mise..."
  mise use --global --pin "$tool@latest"
}

ensure_global_tool ruby
ensure_global_tool node
