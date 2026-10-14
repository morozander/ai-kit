#!/bin/sh
# Validate a kit pack (or core) for consistency.
# Usage:
#   sh core/scripts/validate-pack.sh                        # validate all packs
#   sh core/scripts/validate-pack.sh --pack core            # validate one pack
set -e

KIT_ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
PACK=""
ERROR_FILE=$(mktemp)
WARN_FILE=$(mktemp)
trap 'rm -f "$ERROR_FILE" "$WARN_FILE"' EXIT

echo "0" > "$ERROR_FILE"
echo "0" > "$WARN_FILE"

usage() {
  echo "Usage: sh core/scripts/validate-pack.sh [--pack <name>]" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --pack) PACK=$2; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
done

error() {
  echo "ERROR: $1" >&2
  count=$(cat "$ERROR_FILE")
  echo $((count + 1)) > "$ERROR_FILE"
}

warn() {
  echo "WARN: $1" >&2
  count=$(cat "$WARN_FILE")
  echo $((count + 1)) > "$WARN_FILE"
}

info() {
  echo "INFO: $1"
}

# Extract list items from pack.yaml section
extract_list() {
  section="$1"
  file="$2"
  awk -v sec="$section" '
    /^[a-z_]+:/ { in_section = ($0 ~ "^"sec":") }
    in_section && /^  - / { gsub(/^  - /, ""); print }
  ' "$file"
}

# Check if a string looks like a file path (contains . or / but not spaces with multiple words)
is_file_path() {
  target="$1"
  # Skip if contains spaces and multiple words (likely text, not a path)
  case "$target" in
    *" "*" "*) return 1 ;;
  esac
  # Must contain . or / to be a path
  case "$target" in
    *.*|*/*) return 0 ;;
    *) return 1 ;;
  esac
}

check_link() {
  skill_dir="$1"
  target="$2"
  pack_name="$3"
  skill_name="$4"
  
  # Skip external, anchors, and .agents paths
  case "$target" in
    http://*|https://*) return 0 ;;
    \#*) return 0 ;;
    .agents/*) return 0 ;;
    "") return 0 ;;
  esac
  
  # Skip if not a file path
  if ! is_file_path "$target"; then
    return 0
  fi
  
  resolved="$skill_dir/$target"
  if [ ! -f "$resolved" ] && [ ! -d "$resolved" ]; then
    error "$pack_name: Broken link in $skill_name/SKILL.md: $target"
  fi
}

# Validate a single pack
validate_pack() {
  pack_path="$1"
  pack_name=$(basename "$pack_path")
  
  info "Validating pack: $pack_name"
  
  # Check pack.yaml exists
  if [ ! -f "$pack_path/pack.yaml" ]; then
    error "$pack_name: Missing pack.yaml"
    return
  fi
  
  # Validate skills
  if grep -q "^skills:" "$pack_path/pack.yaml"; then
    for skill in $(extract_list "skills" "$pack_path/pack.yaml"); do
      [ -z "$skill" ] && continue
      skill_dir="$pack_path/skills/$skill"
      if [ ! -d "$skill_dir" ]; then
        error "$pack_name: Skill '$skill' listed in pack.yaml but directory not found: skills/$skill/"
      elif [ ! -f "$skill_dir/SKILL.md" ]; then
        error "$pack_name: Skill '$skill' missing SKILL.md"
      fi
    done
    
    # Check for skills directories not in pack.yaml
    if [ -d "$pack_path/skills" ]; then
      for skill_dir in "$pack_path/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill=$(basename "$skill_dir")
        if ! extract_list "skills" "$pack_path/pack.yaml" | grep -qx "$skill"; then
          warn "$pack_name: Skill directory '$skill' exists but not listed in pack.yaml"
        fi
      done
    fi
  fi
  
  # Validate agents
  if grep -q "^agents:" "$pack_path/pack.yaml"; then
    for agent in $(extract_list "agents" "$pack_path/pack.yaml"); do
      [ -z "$agent" ] && continue
      agent_file="$pack_path/agents/$agent.md"
      if [ ! -f "$agent_file" ]; then
        error "$pack_name: Agent '$agent' listed in pack.yaml but file not found: agents/$agent.md"
      fi
    done
    
    # Check for agent files not in pack.yaml
    if [ -d "$pack_path/agents" ]; then
      for agent_file in "$pack_path/agents"/*.md; do
        [ -f "$agent_file" ] || continue
        agent=$(basename "$agent_file" .md)
        if ! extract_list "agents" "$pack_path/pack.yaml" | grep -qx "$agent"; then
          warn "$pack_name: Agent file '$agent.md' exists but not listed in pack.yaml"
        fi
      done
    fi
  fi
  
  # Validate commands
  if grep -q "^commands:" "$pack_path/pack.yaml" && ! grep -q "^commands: \[\]" "$pack_path/pack.yaml"; then
    for cmd in $(extract_list "commands" "$pack_path/pack.yaml"); do
      [ -z "$cmd" ] && continue
      cmd_file="$pack_path/commands/$cmd.md"
      if [ ! -f "$cmd_file" ]; then
        error "$pack_name: Command '$cmd' listed in pack.yaml but file not found: commands/$cmd.md"
      fi
    done
    
    # Check for command files not in pack.yaml
    if [ -d "$pack_path/commands" ]; then
      for cmd_file in "$pack_path/commands"/*.md; do
        [ -f "$cmd_file" ] || continue
        cmd=$(basename "$cmd_file" .md)
        if ! extract_list "commands" "$pack_path/pack.yaml" | grep -qx "$cmd"; then
          warn "$pack_name: Command file '$cmd.md' exists but not listed in pack.yaml"
        fi
      done
    fi
  fi
  
  # Check for commands: [] meaning empty
  if grep -q "^commands: \[\]" "$pack_path/pack.yaml"; then
    if [ -d "$pack_path/commands" ] && [ "$(ls -A "$pack_path/commands" 2>/dev/null)" ]; then
      warn "$pack_name: commands: [] but commands/ directory is not empty"
    fi
  fi
  
  # Check skill reference links
  if [ -d "$pack_path/skills" ]; then
    for skill_file in "$pack_path/skills"/*/SKILL.md; do
      [ -f "$skill_file" ] || continue
      skill_dir=$(dirname "$skill_file")
      skill_name=$(basename "$skill_dir")
      
      # Extract link targets - look for [text](path) pattern where path looks like a file
      grep -oE '\]\([^)]+\)' "$skill_file" 2>/dev/null | sed 's/\](//' | sed 's/)$//' | while read -r target; do
        check_link "$skill_dir" "$target" "$pack_name" "$skill_name"
      done || true
    done
  fi
}

# Validate kit-level symlinks
validate_symlinks() {
  info "Validating kit symlinks"
  
  if [ -e "$KIT_ROOT/CLAUDE.md" ] && [ ! -L "$KIT_ROOT/CLAUDE.md" ]; then
    error "CLAUDE.md exists but is not a symlink"
  elif [ -L "$KIT_ROOT/CLAUDE.md" ]; then
    target=$(readlink "$KIT_ROOT/CLAUDE.md")
    if [ "$target" != "AGENTS.md" ]; then
      error "CLAUDE.md symlink points to '$target' instead of 'AGENTS.md'"
    fi
  fi
  
  if [ -e "$KIT_ROOT/.cursorrules" ] && [ ! -L "$KIT_ROOT/.cursorrules" ]; then
    error ".cursorrules exists but is not a symlink"
  elif [ -L "$KIT_ROOT/.cursorrules" ]; then
    target=$(readlink "$KIT_ROOT/.cursorrules")
    if [ "$target" != "AGENTS.md" ]; then
      error ".cursorrules symlink points to '$target' instead of 'AGENTS.md'"
    fi
  fi
}

# Validate shell scripts with shellcheck if available
validate_scripts() {
  info "Validating shell scripts"
  
  if command -v shellcheck >/dev/null 2>&1; then
    for script in "$KIT_ROOT/core/scripts"/*.sh; do
      [ -f "$script" ] || continue
      if ! shellcheck -S warning "$script" 2>/dev/null; then
        error "shellcheck failed for $(basename "$script")"
      fi
    done
  else
    warn "shellcheck not installed, skipping script validation"
  fi
}

# Main
if [ -n "$PACK" ]; then
  # Validate single pack
  case "$PACK" in
    core) pack_path="$KIT_ROOT/core" ;;
    *) pack_path="$KIT_ROOT/packs/$PACK" ;;
  esac
  
  if [ ! -d "$pack_path" ]; then
    error "Pack not found: $PACK"
    exit 1
  fi
  
  validate_pack "$pack_path"
else
  # Validate all packs
  validate_pack "$KIT_ROOT/core"
  for pack_dir in "$KIT_ROOT/packs"/*/; do
    [ -d "$pack_dir" ] || continue
    validate_pack "$pack_dir"
  done
  validate_symlinks
  validate_scripts
fi

ERRORS=$(cat "$ERROR_FILE")
WARNINGS=$(cat "$WARN_FILE")

echo ""
echo "=== Validation Summary ==="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
exit 0
