#!/usr/bin/env bash
# peter-claude installer
# Symlinks owned files into ~/.claude/ and clones external skills.
#
# Usage:
#   ./install.sh           # install / update
#   ./install.sh --dry-run # show what would happen without changing anything
#
# Idempotent: safe to re-run. Re-running pulls latest from external skill repos.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
CACHE_DIR="$CLAUDE_DIR/.peter-claude-cache"
DRY_RUN=0

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

log()  { printf '\033[1;34m[peter-claude]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[peter-claude]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31m[peter-claude]\033[0m %s\n' "$*" >&2; }

run() {
  if (( DRY_RUN )); then
    printf '  [dry] %s\n' "$*"
  else
    "$@"
  fi
}

# -------------------------------------------------------------------
# Pre-flight
# -------------------------------------------------------------------

command -v git >/dev/null 2>&1 || { err "git not found"; exit 1; }

if [[ ! -d "$CLAUDE_DIR" ]]; then
  log "creating $CLAUDE_DIR"
  run mkdir -p "$CLAUDE_DIR"
fi
run mkdir -p "$CLAUDE_DIR/skills" "$CACHE_DIR"

# -------------------------------------------------------------------
# Backup existing real files (not symlinks) before overwriting
# -------------------------------------------------------------------

backup_if_real() {
  local target=$1
  if [[ -e "$target" && ! -L "$target" ]]; then
    local bak="${target}.bak.$(date +%Y%m%d-%H%M%S)"
    warn "backing up existing $target -> $bak"
    run mv "$target" "$bak"
  elif [[ -L "$target" ]]; then
    # Existing symlink: remove so we can re-link
    run rm -f "$target"
  fi
}

# -------------------------------------------------------------------
# Symlink owned files
# -------------------------------------------------------------------

log "linking owned files"

backup_if_real "$CLAUDE_DIR/CLAUDE.md"
run ln -s "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

backup_if_real "$CLAUDE_DIR/docs"
run ln -s "$REPO_DIR/docs" "$CLAUDE_DIR/docs"

# Symlink each owned skill
shopt -s nullglob
for skill_dir in "$REPO_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  target="$CLAUDE_DIR/skills/$skill_name"
  backup_if_real "$target"
  log "  skill (owned): $skill_name"
  run ln -s "${skill_dir%/}" "$target"
done
shopt -u nullglob

# -------------------------------------------------------------------
# External skills: clone (or pull) then symlink subdir
# -------------------------------------------------------------------

# install_external <name> <git-url> <subdir-inside-repo>
#   <name>    becomes ~/.claude/skills/<name>
#   <git-url> public git URL (Public repo only; no private/internal URLs)
#   <subdir>  path inside the cloned repo that contains SKILL.md
install_external() {
  local name=$1
  local url=$2
  local subdir=$3
  local cache="$CACHE_DIR/$name"
  local source="$cache/$subdir"
  local target="$CLAUDE_DIR/skills/$name"

  log "  skill (external): $name <- $url ($subdir)"

  if [[ -d "$cache/.git" ]]; then
    run git -C "$cache" pull --quiet --ff-only
  else
    run rm -rf "$cache"
    run git clone --quiet --depth 1 "$url" "$cache"
  fi

  if (( ! DRY_RUN )) && [[ ! -d "$source" ]]; then
    err "expected subdir not found: $source"
    return 1
  fi

  backup_if_real "$target"
  run ln -s "$source" "$target"
}

log "installing external skills"

# ===================================================================
# EDIT BELOW to add / remove external skills.
# Format: install_external <name> <git-url> <subdir-inside-repo>
# ===================================================================

install_external grill-me  https://github.com/mattpocock/skills      skills/productivity/grill-me
install_external caveman   https://github.com/JuliusBrussee/caveman  skills/caveman

# ===================================================================

# -------------------------------------------------------------------
# Done
# -------------------------------------------------------------------

if (( DRY_RUN )); then
  log "dry-run complete — no changes made"
else
  log "done. verify with: ls -la $CLAUDE_DIR/{CLAUDE.md,docs,skills}"
fi
