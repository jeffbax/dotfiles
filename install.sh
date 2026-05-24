#!/bin/sh
set -eu

# Standalone fresh-machine bootstrap.
# This script intentionally does not run chezmoi init/apply.

log() {
  printf '%s\n' "$*"
}

detect_os() {
  case "$(uname -s)" in
  Darwin)
    printf '%s\n' darwin
    ;;
  Linux)
    printf '%s\n' linux
    ;;
  *)
    printf '%s\n' unsupported
    ;;
  esac
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew is already installed."
    return 0
  fi

  case "$(detect_os)" in
  darwin | linux)
    ;;
  *)
    log "Unsupported OS for Homebrew install: $(uname -s)"
    exit 1
    ;;
  esac

  if ! command -v curl >/dev/null 2>&1; then
    log "curl is required to install Homebrew."
    exit 1
  fi

  if [ ! -x /bin/bash ]; then
    log "/bin/bash is required to install Homebrew."
    exit 1
  fi

  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

load_homebrew_env() {
  for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [ -x "$prefix/bin/brew" ]; then
      eval "$(SHELL=/bin/sh "$prefix/bin/brew" shellenv)"
      return 0
    fi
  done

  command -v brew >/dev/null 2>&1
}

install_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    log "chezmoi is already installed."
    return 0
  fi

  log "Installing chezmoi..."
  brew install chezmoi
}

print_next_steps() {
  cat <<'EOF'

Bootstrap prerequisites are installed.

Next steps after the dotfiles repo is available:

  chezmoi init <repo-url>
  chezmoi apply

When prompted for the Homebrew profile, choose one of:

  common
  personal
  work
EOF
}

install_homebrew
load_homebrew_env

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew is not available after setup."
  exit 1
fi

install_chezmoi
print_next_steps
