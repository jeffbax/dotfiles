if [ -r "$HOME/.config/shell/chezmoi/work/env.sh" ]; then
  . "$HOME/.config/shell/chezmoi/work/env.sh"
fi

if command -v mise >/dev/null 2>&1; then
  case "$-" in
  *i*) eval "$(mise activate zsh)" ;;
  *) eval "$(mise env -q -s zsh)" ;;
  esac
elif [ -x /opt/homebrew/bin/mise ]; then
  case "$-" in
  *i*) eval "$(/opt/homebrew/bin/mise activate zsh)" ;;
  *) eval "$(/opt/homebrew/bin/mise env -q -s zsh)" ;;
  esac
fi
