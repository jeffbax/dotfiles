# Jeff's Fish Shell Configuration
# Personal settings for macOS development environment

# Disable the greeting message
set fish_greeting

# Set preferred editor
set -gx EDITOR vim

# Add custom bin directory to PATH if it exists
if test -d $HOME/bin
    set -gx PATH $HOME/bin $PATH
end

# Homebrew configuration
if test -d /opt/homebrew/bin
    set -gx PATH /opt/homebrew/bin $PATH
end

# Color scheme preferences
set -g fish_color_command blue
set -g fish_color_error red
set -g fish_color_param cyan
