if type -q mise
    mise activate fish | source
end

if not contains -- "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
end
