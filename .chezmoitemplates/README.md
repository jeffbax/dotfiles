# Template List Notes

Put Fisher plugin names in these files, one per line:

- `fish_plugins.common`
- `fish_plugins.personal`
- `fish_plugins.work`

Generated plugin files should not be copied into chezmoi.

Put Codex plugin names in `codex_plugins.common`, one per line.

Put external agent skills in `agent_skills.common` or the matching profile
file, one `<source> <skill-name>` pair per line. Chezmoi installs those skills
with `npx skills` for Codex and OpenCode.

Chezmoi owns `~/.config/fish/config.fish`. Avoid running tool setup commands
that mutate that file. Instead, put tool initialization in the appropriate
bucket under `dot_config/fish/chezmoi/`.

Package and plugin-generated completions should usually stay managed by their
installer. Only put hand-written completions or functions in chezmoi.
