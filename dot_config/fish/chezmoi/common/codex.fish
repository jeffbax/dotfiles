function __codex_1p_env_file
    if test -f .env.op
        path resolve .env.op
        return
    end

    if not type -q git
        return 1
    end

    set -l worktree_root (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$worktree_root"; and test -f "$worktree_root/.env.op"
        path resolve "$worktree_root/.env.op"
        return
    end

    set -l common_git_dir (command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    if test -n "$common_git_dir"
        set -l primary_root (path dirname "$common_git_dir")
        if test -f "$primary_root/.env.op"
            path resolve "$primary_root/.env.op"
            return
        end
    end

    return 1
end

function __codex_with_github_token
    if not type -q gh
        echo "codex: GitHub CLI (gh) is required" >&2
        return 127
    end

    if not gh auth token --hostname github.com | read --local --export GITHUB_PAT_TOKEN
        echo "codex: unable to read the active GitHub token; run 'gh auth login --hostname github.com'" >&2
        return 1
    end

    command $argv
end

function codex --wraps=codex --description 'Launch Codex with GitHub MCP authentication'
    __codex_with_github_token codex $argv
end

function codex-1p --wraps=codex --description 'Launch Codex with GitHub and 1Password credentials'
    if not type -q op
        echo "codex-1p: 1Password CLI (op) is required" >&2
        return 127
    end

    set -l env_file (__codex_1p_env_file)
    if test $status -ne 0
        echo "codex-1p: unable to find .env.op in the current directory, worktree, or primary repository" >&2
        return 1
    end

    __codex_with_github_token op run --env-file="$env_file" -- codex $argv
end
