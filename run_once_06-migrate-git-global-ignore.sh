#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

if ! command -v git >/dev/null 2>&1; then
  log "Git is not installed; skipping global ignore migration."
  exit 0
fi

configured_excludes_file="$(git config --global --get-all core.excludesFile || true)"

case "$configured_excludes_file" in
"")
  log "Git already uses its default global ignore path."
  exit 0
  ;;
"$HOME/.gitignore" | "~/.gitignore")
  ;;
*)
  log "Preserving custom Git global ignore path: $configured_excludes_file"
  exit 0
  ;;
esac

git config --global --unset-all core.excludesFile
log "Migrated Git global ignores to ~/.config/git/ignore."
