#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# link.sh - symlink dotfiles into $HOME so they stay in sync with the repo.
#
# Source of truth : ~/dotfiles
#
# Existing files are backed up with a timestamp before being replaced, so the
# script is safe to re-run (it is idempotent).
# -----------------------------------------------------------------------------

DOTFILES="$HOME/dotfiles"

# ------------------------------------------------------------------
# Symlink map: "target_in_HOME:source_relative_to_DOTFILES"
# ------------------------------------------------------------------
LINKS=(
  # zsh modules (the .zshrc entry point sources the rest via $HOME/<file>)
  ".zshrc:zsh/.zshrc"
  ".plugins:zsh/.plugins"
  ".exports:zsh/.exports"
  ".aliases:zsh/.aliases"
  ".functions:zsh/.functions"
)

# ------------------------------------------------------------------
# Global AGENTS.md -> each AI coding agent's global config location
# (source of truth: ~/dotfiles/agents/AGENTS.md)
# ------------------------------------------------------------------
AGENTS_SOURCE="$DOTFILES/agents/AGENTS.md"
AGENTS_TARGETS=(
  "$HOME/.claude/CLAUDE.md"       # Claude Code  (user-level memory)
  "$HOME/.codex/AGENTS.md"        # Codex        (global AGENTS.md)
  "$HOME/.agents/AGENTS.md"       # Cline        (cross-tool global AGENTS.md)
  "$HOME/.config/devin/AGENTS.md" # Devin CLI    (XDG global AGENTS.md)
)

# Create a symlink at $target pointing to $source, backing up anything there.
link_target() {
  local target="$1"
  local source="$2"
  local dir
  dir="$(dirname "$target")"
  mkdir -p "$dir"

  # Already pointing at the source - nothing to do.
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    printf "  ok already linked %s\n" "$target"
    return 0
  fi

  # Back up an existing regular file or a symlink pointing elsewhere.
  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf "  * backed up       %s -> %s\n" "$target" "$backup"
  fi

  ln -s "$source" "$target"
  printf "  ok linked         %s -> %s\n" "$target" "$source"
}

main() {
  if [ ! -d "$DOTFILES" ]; then
    echo "error: dotfiles directory not found: $DOTFILES" >&2
    exit 1
  fi

  echo "Linking dotfiles into $HOME..."
  echo "  source: $DOTFILES"
  echo

  # zsh modules + .zshrc
  echo "  zsh:"
  for entry in "${LINKS[@]}"; do
    target_name="${entry%%:*}"
    rel="${entry##*:}"
    source="$DOTFILES/$rel"
    if [ ! -f "$source" ]; then
      printf "  ! missing source  %s\n" "$source"
      continue
    fi
    link_target "$HOME/$target_name" "$source"
  done
  echo

  # global AGENTS.md
  if [ -f "$AGENTS_SOURCE" ]; then
    echo "  global AGENTS.md:"
    for target in "${AGENTS_TARGETS[@]}"; do
      link_target "$target" "$AGENTS_SOURCE"
    done
  else
    echo "  ! skipping global AGENTS.md (source not found: $AGENTS_SOURCE)"
  fi
  echo

  echo "Done. Edit files under $DOTFILES to update everywhere at once."
}

main "$@"

