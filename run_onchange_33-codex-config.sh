#!/bin/sh
set -eu

config_dir="${CODEX_HOME:-$HOME/.codex}"
config_file="$config_dir/config.toml"
key="check_for_update_on_startup"
setting="$key = false"

log() {
  printf '%s\n' "$*"
}

if ! command -v codex >/dev/null 2>&1; then
  log "Codex is not installed; skipping Codex config setup."
  exit 0
fi

mkdir -p "$config_dir"

if [ ! -f "$config_file" ]; then
  umask 077
  printf '%s\n' "$setting" >"$config_file"
  log "Created $config_file with $setting"
  exit 0
fi

tmp_file="$(mktemp "${TMPDIR:-/tmp}/codex-config.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT HUP INT TERM

awk -v key="$key" -v setting="$setting" '
  BEGIN {
    in_top_level = 1
    wrote_setting = 0
  }

  in_top_level && !wrote_setting && /^[[:space:]]*\[/ {
    print setting
    wrote_setting = 1
    in_top_level = 0
  }

  in_top_level && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
    if (!wrote_setting) {
      print setting
      wrote_setting = 1
    }
    next
  }

  {
    print
  }

  in_top_level && /^[[:space:]]*\[/ {
    in_top_level = 0
  }

  END {
    if (!wrote_setting) {
      print setting
    }
  }
' "$config_file" >"$tmp_file"

if cmp -s "$config_file" "$tmp_file"; then
  log "$config_file already has $setting"
else
  cp "$tmp_file" "$config_file"
  log "Updated $config_file with $setting"
fi
