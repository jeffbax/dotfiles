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

function __codex_with_mcp_overrides
    set -l launch_function $argv[1]
    set -e argv[1]

    set -l codex_args
    while set -q argv[1]
        set -l arg $argv[1]
        set -e argv[1]

        if test "$arg" = --
            set -a codex_args -- $argv
            break
        end

        if test "$arg" != --mcp
            set -a codex_args "$arg"
            continue
        end

        set -l found_mcp false
        while set -q argv[1]
            set -l mcp_value $argv[1]
            if contains -- "$mcp_value" --mcp --
                break
            end
            if string match --quiet --regex '^-' -- "$mcp_value"
                break
            end
            set -e argv[1]

            # Restrict names to TOML bare keys so they cannot alter another config path.
            if not string match --quiet --regex '^[A-Za-z0-9_-]+(,[A-Za-z0-9_-]+)*$' -- "$mcp_value"
                echo "codex: invalid MCP list: $mcp_value" >&2
                return 2
            end

            for mcp in (string split , -- "$mcp_value")
                set -a codex_args -c "mcp_servers.$mcp.enabled=true"
            end
            set found_mcp true
        end

        if test "$found_mcp" = false
            echo 'codex: --mcp requires at least one MCP name' >&2
            return 2
        end
    end

    $launch_function $codex_args
end

function __codex_launch
    __codex_with_github_token codex $argv
end

function __codex_1p_launch
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

function codex --wraps=codex --description 'Launch Codex with GitHub MCP authentication'
    __codex_with_mcp_overrides __codex_launch $argv
end

function codex-1p --wraps=codex --description 'Launch Codex with GitHub and 1Password credentials'
    __codex_with_mcp_overrides __codex_1p_launch $argv
end
