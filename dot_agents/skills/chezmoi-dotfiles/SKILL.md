---
name: chezmoi-dotfiles
description: Use when managing these chezmoi dotfiles, including profile-aware Homebrew, fish configuration, macOS defaults, Codex/OpenCode skills, secrets, and tool initialization conventions.
---

# Chezmoi Dotfiles

## Ground Rules

- The chezmoi source directory is `~/.local/share/chezmoi`.
- Use chezmoi conventions and keep the repo portable where reasonable.
- Keep `README.md` succinct and big-picture: platform/profile assumptions, managed areas, and major unmanaged boundaries. Do not turn it into an implementation inventory.
- Update `README.md` only when changing durable conventions, profiles, bootstrap behavior, managed areas, or deliberately unmanaged boundaries.
- Before applying changes, prefer `chezmoi apply --dry-run --verbose`.
- Keep lists grouped and alphabetized when order is not meaningful; use numeric filename prefixes when order matters.
- Keep root repo docs, bootstrap inputs, and other source-only support files ignored unless they are intentionally installed into `$HOME`.

## Profiles And Packages

- `brewProfile` is the shared selector: `common`, `personal`, or `work`.
- `common` always applies; only one optional profile should normally apply.
- Keep package declarations split as `Brewfile.<profile>` and `Brewfile.<profile>.<os>`.
- Always use `brew bundle --no-upgrade`.
- Put OS-specific packages in OS-specific Brewfiles.
- Prefer version-aligned formulae over hardcoded shell paths; add PATH handling only for intentionally keg-only tools.

## Fish And Formatting

- `dot_config/fish/config.fish.tmpl` owns the top-level fish config and sources profile buckets.
- Put reusable fish snippets under `dot_config/fish/chezmoi/common`; put profile-specific snippets in matching profile buckets.
- Keep durable environment behavior aligned across fish, zsh, and bash. When adding or changing shared toolchain environment such as mise activation, Node certificate settings, or PostgreSQL PATH handling, update the fish snippets and the shared POSIX shell helpers together unless a shell-specific reason is documented.
- Keep fish environment setup idempotent and guarded with `type -q`, `command -sq`, `test -d`, or `test -x`.
- Use Fisher plugin lists as source of truth. Do not commit Fisher-generated plugin files, functions, completions, or themes.
- Format fish files with `fish_indent`; format plain shell files with `shfmt -i 2`.
- Keep final newline and trailing whitespace behavior at the editor layer via `.editorconfig`, not hook complexity.

## Tool Initialization

- For generated deterministic config, run the initializer manually and check in the resulting source files only when the output should be owned by chezmoi.
- Do not repeatedly run initializers that mutate files chezmoi owns.
- Use `run_once_` or `run_onchange_` for external state such as package installation, defaults writes, hook setup, or plugin-manager reconciliation.
- Prefer checking for a tool binary before initializing it instead of hard-gating setup scripts by `brewProfile`; profiles decide installation, while initializers no-op with clear skip messages when tools are absent.
- When a rendered file or sourced shell snippet is profile-specific, gate it by `brewProfile`.

## Agent Tooling

- Shared skills live in `~/.agents/skills`; agent-specific skill locations should symlink into that shared bucket.
- Do not modify or replace `~/.codex/skills/.system`.
- Do not manage `~/.codex/config.toml`; it contains local trust, MCP, plugin, and machine state.
- Keep shared skills generic enough for Codex and OpenCode unless nested metadata is intentionally agent-specific.
- Use idempotent scripts for agent plugin marketplace/install state. Do not check in generated plugin output.

## macOS Defaults

- Prefer small idempotent `defaults write` or plist helper scripts over managing whole preference plists.
- Put common macOS defaults in `run_onchange_20-macos-defaults.sh.tmpl`.
- Leave uncertain or security-sensitive preferences unmanaged until the desired value is explicit.

## Secrets

- Never commit private keys, resolved tokens, or secret-bearing env files.
- Use `gitleaks` through the repo-local pre-commit hook for staged secret scanning.
- Prefer 1Password SSH agent for SSH keys.
- Prefer `op run` wrappers or 1Password references for command-scoped secrets.
- Use `.envrc` for secrets only when broad directory-scoped exposure is intentional.
