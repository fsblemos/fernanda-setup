#!/bin/bash
# Claude Code status line — based on .bashrc PS1 (user@host:cwd)
# Enriched with model name and context usage.
#
# Read all of stdin once into a temp file so jq queries never see a truncated stream.
tmpfile=$(mktemp /tmp/claude-statusline.XXXXXX)
trap 'rm -f "$tmpfile"' EXIT
cat > "$tmpfile"

user=$(whoami)
host=$(hostname -s)

# All field paths verified against the Claude Code statusLine JSON schema.
cwd=$(jq -r '.workspace.current_dir // empty' "$tmpfile")
model=$(jq -r '.model.display_name // empty' "$tmpfile")
# used_percentage is a pre-calculated number (0-100) or null when no messages yet.
used=$(jq -r 'if .context_window.used_percentage != null then (.context_window.used_percentage | tostring) else empty end' "$tmpfile")

# Bold green for user@host, bold blue for cwd, reset after
printf "\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m" "$user" "$host" "$cwd"

# Model name — only when available
if [ -n "$model" ]; then
  printf "  [%s]" "$model"
fi

# Context usage — green <60%, orange 60-79%, red 80%+
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  if [ "$used_int" -ge 80 ]; then
    ctx_color="\033[01;31m"  # bold red
  elif [ "$used_int" -ge 60 ]; then
    ctx_color="\033[01;33m"  # bold orange/yellow
  else
    ctx_color="\033[01;32m"  # bold green
  fi
  printf "  ${ctx_color}ctx: %s%% used\033[00m" "$used_int"
fi
