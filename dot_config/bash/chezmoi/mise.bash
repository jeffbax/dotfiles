if [ -r "$HOME/.config/shell/chezmoi/work/env.sh" ]; then
  . "$HOME/.config/shell/chezmoi/work/env.sh"
fi

mise_path="$(command -v mise 2>/dev/null || true)"
if [ -z "$mise_path" ] && [ -x /opt/homebrew/bin/mise ]; then
  mise_path=/opt/homebrew/bin/mise
fi

if [ -n "$mise_path" ]; then
  case "$-" in
  *i*) eval "$("$mise_path" activate bash)" ;;
  *) eval "$("$mise_path" env -q -s bash)" ;;
  esac
fi
unset mise_path

if [ -r "$HOME/.config/shell/chezmoi/common/env.sh" ]; then
  . "$HOME/.config/shell/chezmoi/common/env.sh"
fi
