#!/usr/bin/env bash
# Rebuild fx-term.wasm from the fork (which carries the gateway-routing patch)
# and copy it into this site repo. Requires nix + zig 0.16.0+.
#
#   scripts/sync-wasm.sh [fork-path] [site-repo-path]
set -euo pipefail

FORK="${1:-$HOME/dev/oh-my-fx}"
SITE="${2:-$(cd "$(dirname "$0")/.." && pwd)}"

cd "$FORK"
nix shell nixpkgs#zig --command zig build -Dwasm-surface=term -Doptimize=ReleaseSmall
cp zig-out/bin/fx-term.wasm "$SITE/site/fx-term.wasm"
echo "synced: $SITE/site/fx-term.wasm ($(stat -c%s "$SITE/site/fx-term.wasm") bytes)"
