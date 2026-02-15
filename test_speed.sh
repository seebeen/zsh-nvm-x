#!/usr/bin/env bash
set -euo pipefail

RAW_OUTPUT="$(
POWERLEVEL9K_INSTANT_PROMPT=off zsh -ilc '
  s=$(date +%s%3N)
  node -v >/dev/null 2>&1
  m=$(date +%s%3N)
  node -v >/dev/null 2>&1
  e=$(date +%s%3N)
  echo "first=$((m-s))ms second=$((e-m))ms"
'
)"

printf '%s\n' "$RAW_OUTPUT" \
  | sed -E $'s/\x1B\\[[0-9;?]*[ -\\/]*[@-~]//g' \
  | grep -m1 'first='
