#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

OUTPUT="$(
  zsh -fc '
    set -e
    export NVM_DIR="'$ROOT_DIR'/.tmp/nvm-smoke"
    mkdir -p "$NVM_DIR"

    source "'$ROOT_DIR'/lib/zsh-nvm-x-state.zsh"
    source "'$ROOT_DIR'/lib/zsh-nvm-x-core.zsh"
    source "'$ROOT_DIR'/lib/zsh-nvm-x-lazy.zsh"

    _zsh_nvm_x_global_binaries() { printf "node\\n"; }
    _zsh_nvm_x_load() {
      node() { echo "node-ran:$*"; }
    }

    _zsh_nvm_x_lazy_load
    node --version
  '
)"

grep -q "node-ran:--version" <<<"$OUTPUT"
echo "lazy_load_smoke:ok"
