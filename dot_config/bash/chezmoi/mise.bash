if [ -r "$HOME/.config/shell/chezmoi/work/env.sh" ]; then
  . "$HOME/.config/shell/chezmoi/work/env.sh"
fi

if command -v mise >/dev/null 2>&1; then
  case "$-" in
  *i*) eval "$(mise activate bash)" ;;
  *) eval "$(mise env -q -s bash)" ;;
  esac
elif [ -x /opt/homebrew/bin/mise ]; then
  case "$-" in
  *i*) eval "$(/opt/homebrew/bin/mise activate bash)" ;;
  *) eval "$(/opt/homebrew/bin/mise env -q -s bash)" ;;
  esac
fi

if [ -r "$HOME/.config/shell/chezmoi/common/env.sh" ]; then
  . "$HOME/.config/shell/chezmoi/common/env.sh"
fi
