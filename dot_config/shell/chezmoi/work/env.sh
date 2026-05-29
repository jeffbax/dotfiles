# Cloudflare WARP requires Node to trust the system CA store.
if [ "${NODE_USE_SYSTEM_CA:-}" != 1 ]; then
  export NODE_USE_SYSTEM_CA=1
fi

postgres_bin="/opt/homebrew/opt/postgresql@17/bin"
if [ -x "$postgres_bin/pg_dump" ]; then
  case ":$PATH:" in
  *":$postgres_bin:"*) ;;
  *)
    PATH="$postgres_bin:$PATH"
    export PATH
    ;;
  esac
fi
unset postgres_bin
