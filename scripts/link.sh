#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# link.sh - symlink the shared global AGENTS.md into every AI coding agent's
#           global config location so they all read the same instructions.
#
# Source of truth : ~/dotfiles/agents/AGENTS.md
# Linked targets  :
#   Claude Code   ->  ~/.claude/CLAUDE.md
#   OpenAI Codex  ->  ~/.codex/AGENTS.md
#   Cline         ->  ~/.agents/AGENTS.md
#   Devin CLI     ->  ~/.config/devin/AGENTS.md
#
# Existing files are backed up with a timestamp before being replaced, so the
# script is safe to re-run (it is idempotent).
# -----------------------------------------------------------------------------

DOTFILES="$HOME/dotfiles"
SOURCE="$DOTFILES/agents/AGENTS.md"

# Global instruction file each agent reads at startup.
TARGETS=(
  "$HOME/.claude/CLAUDE.md"       # Claude Code  (user-level memory)
  "$HOME/.codex/AGENTS.md"        # Codex        (global AGENTS.md)
  "$HOME/.agents/AGENTS.md"       # Cline        (cross-tool global AGENTS.md)
  "$HOME/.config/devin/AGENTS.md" # Devin CLI    (XDG global AGENTS.md)
)

# Create a symlink at $1 pointing to $SOURCE, backing up anything already there.
link_target() {
  local target="$1"
  local dir
  dir="$(dirname "$target")"
  mkdir -p "$dir"

  # Already pointing at the source - nothing to do.
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$SOURCE" ]; then
    printf "  ok already linked %s\n" "$target"
    return 0
  fi

  # Back up an existing regular file or a symlink pointing elsewhere.
  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf "  * backed up       %s -> %s\n" "$target" "$backup"
  fi

  ln -s "$SOURCE" "$target"
  printf "  ok linked         %s -> %s\n" "$target" "$SOURCE"
}

main() {
  if [ ! -f "$SOURCE" ]; then
    echo "error: source file not found: $SOURCE" >&2
    echo "       create it first, then re-run this script." >&2
    exit 1
  fi

  echo "Linking global AGENTS.md to all agents..."
  echo "  source: $SOURCE"
  echo
  for target in "${TARGETS[@]}"; do
    link_target "$target"
  done
  echo
  echo "Done. Edit $SOURCE to update every agent at once."
}

main "$@"
