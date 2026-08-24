#!/usr/bin/env bash
# Local dev/test stack — no Cloudflare login, no CI.
#   site   : http://127.0.0.1:8123/?worker=http://127.0.0.1:8788
#   worker : http://127.0.0.1:8788  (proxies to UPSTREAM_BASE with GATEWAY_KEY)
#
# GATEWAY_KEY comes from worker/.dev.vars (gitignored) or the environment.
# Override the upstream for offline testing, e.g.:
#   UPSTREAM_BASE=http://127.0.0.1:9999 GATEWAY_KEY=test scripts/dev.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT_SITE="${PORT_SITE:-8123}"
PORT_WORKER="${PORT_WORKER:-8788}"

PORT="$PORT_WORKER" node "$ROOT/scripts/worker-local.mjs" &
WPID=$!
(
  cd "$ROOT/site"
  python3 -m http.server "$PORT_SITE" --bind 127.0.0.1
) &
SPID=$!

trap 'kill "$WPID" "$SPID" 2>/dev/null' EXIT

echo "site  : http://127.0.0.1:${PORT_SITE}/?worker=http://127.0.0.1:${PORT_WORKER}"
echo "worker: http://127.0.0.1:${PORT_WORKER}   (Ctrl-C to stop)"
wait
