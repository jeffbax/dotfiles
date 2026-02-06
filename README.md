# dotfiles

Personal macOS configuration using fish shell and Homebrew.

## Features

- **Fish Shell**: Modern shell with helpful features and syntax highlighting
- **Homebrew**: Package management through a Brewfile
- **Easy Setup**: Automated installation script

## Quick Start

Clone this repository to `~/.dotfiles`:

```bash
git clone https://github.com/jeffbax/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

The setup script will:
1. Install Homebrew (if needed)
2. Install all packages from the Brewfile
3. Configure fish shell as your default
4. Link configuration files

## Structure

```
.
├── fish/
│   ├── config.fish       # Main fish configuration
│   ├── conf.d/           # Additional config files
│   └── functions/        # Custom fish functions
├── Brewfile              # Homebrew packages and apps
└── setup.sh              # Installation script
```

## Customization

Edit the following files to personalize:

- `Brewfile` - Add or remove packages and applications
- `fish/config.fish` - Modify shell settings and aliases
- `fish/functions/` - Add custom shell functions

## Manual Setup

If you prefer manual setup:

1. Install packages: `brew bundle --file=Brewfile`
2. Link fish config: `ln -s ~/.dotfiles/fish/config.fish ~/.config/fish/config.fish`
3. Set fish as default: `chsh -s $(which fish)`
