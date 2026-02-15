#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

OUTPUT="$(
  zsh -fc '
    set -e
    export ZSH_NVM_NO_LOAD=true
    export NVM_DIR="'$ROOT_DIR'/.tmp/nvm-startup"
    source "'$ROOT_DIR'/zsh-nvm-x.plugin.zsh"
    echo "startup-ok"
  '
)"

grep -q "startup-ok" <<<"$OUTPUT"
echo "startup_smoke:ok"
