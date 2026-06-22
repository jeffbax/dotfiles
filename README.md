# Dotfiles

This repository is managed with [chezmoi](https://www.chezmoi.io/). The local
chezmoi source directory is expected to be:

```sh
~/.local/share/chezmoi
```

## Bootstrap

Use `install.sh` on a fresh machine before chezmoi is available:

```sh
sh install.sh
```

The script installs Homebrew and chezmoi, then prints the next commands. It does
not run `chezmoi init` or `chezmoi apply`.

After cloning or initializing this repo:

```sh
chezmoi init <repo-url>
chezmoi apply
```

## Profiles

Machine-specific behavior is selected with `brewProfile`:

- `common`: baseline setup
- `personal`: common plus personal tools
- `work`: common plus work tools

Common setup always applies. A machine should normally use only one optional
profile.

## Managed Areas

Homebrew packages are split by profile and OS. Bootstrap always installs the
common packages first, then the selected profile, using `brew bundle
--no-upgrade`. Cask app bundles default to `~/Applications` through Homebrew's
user environment file and Brewfile `cask_args`, with explicit `/Applications`
exceptions for apps that expect system-wide placement. Casks that use
privileged package installers may still require admin credentials.

Shell startup files keep Homebrew login setup separate from interactive tool
activation. Fish owns its profile buckets, Fisher plugin lists, and a small set
of reusable functions/completions; zsh and bash own minimal startup files that
source shared toolchain helpers. Zsh also loads a one-shot mise environment for
non-interactive IDE run configs. Generated Fisher plugin output is intentionally
not checked in.

Editor behavior is managed at two levels: portable text rules live in
`.editorconfig`, while macOS-only application defaults are written with small
idempotent scripts.

Agent tooling is shared through `~/.agents/skills`, with Codex and OpenCode
pointing at that shared skill bucket. Tool integrations are installed with
idempotent scripts that check for the relevant binary and no-op with a clear
skip message when absent.

This repo also configures a repo-local Git hook path. The pre-commit hook scans
staged content with `gitleaks` and runs the language formatters we rely on for
fish and shell files.

## Not Managed

These are deliberately outside chezmoi ownership:

- Secrets, private keys, resolved tokens, and secret-bearing env files
- Local Codex config, auth, trust, cache, session, and database state
- Generated plugin output and other reproducible tool-generated files
- Whole macOS preference plists
- Project-specific configuration that belongs in each project

Use 1Password, `op run`, or command-scoped wrappers for secrets rather than
committing them to this repository.
