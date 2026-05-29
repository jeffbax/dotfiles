set -gx LEFTHOOK 0

# Cloudflare WARP requires Node to trust the system CA store.
if not set -qU NODE_USE_SYSTEM_CA
    set -Ux NODE_USE_SYSTEM_CA 1
else if test "$NODE_USE_SYSTEM_CA" != 1
    set -Ux NODE_USE_SYSTEM_CA 1
end

if test -x /opt/homebrew/opt/postgresql@17/bin/psql
    fish_add_path --global --move --prepend /opt/homebrew/opt/postgresql@17/bin
end
