#!/bin/bash
# Installs Claude Code personal config to ~/.claude/
# Run once on a new machine: bash install.sh

set -e

DEST="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v jq &>/dev/null; then
  echo "jq not found — install it first (e.g. sudo apt install jq or brew install jq)"
  exit 1
fi

mkdir -p "$DEST"

cp "$SCRIPT_DIR/statusline-command.sh" "$DEST/statusline-command.sh"
chmod +x "$DEST/statusline-command.sh"

if [ -f "$DEST/settings.json" ]; then
  echo "settings.json already exists — merging statusLine key only"
  tmp=$(mktemp)
  jq --slurpfile new <(jq '{statusLine,theme}' "$SCRIPT_DIR/settings.json") \
    '. * $new[0]' "$DEST/settings.json" > "$tmp" && mv "$tmp" "$DEST/settings.json"
else
  cp "$SCRIPT_DIR/settings.json" "$DEST/settings.json"
fi

echo "Done. Restart Claude Code to apply."
