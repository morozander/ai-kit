#!/bin/sh
# Copy a kit pack (or core) into a target project.
# Usage:
#   sh core/scripts/install-into.sh --target /path/to/project --pack core
#   sh core/scripts/install-into.sh --target /path/to/project --pack software-frontend
#   sh core/scripts/install-into.sh --target /path/to/project --pack hiking-tutor --force
#   sh core/scripts/install-into.sh --target /path/to/project --pack core --link
set -e

KIT_ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
TARGET=""
PACK=""
FORCE=0
DO_LINK=0

usage() {
  echo "Usage: sh core/scripts/install-into.sh --target <dir> --pack <core|software-frontend|hiking-tutor> [--force] [--link]" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET=$2; shift 2 ;;
    --pack) PACK=$2; shift 2 ;;
    --force) FORCE=1; shift ;;
    --link) DO_LINK=1; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
done

[ -n "$TARGET" ] && [ -n "$PACK" ] || usage
TARGET="$(CDPATH= cd -- "$TARGET" && pwd)"

case "$PACK" in
  core) SRC="$KIT_ROOT/core" ;;
  software-frontend|hiking-tutor) SRC="$KIT_ROOT/packs/$PACK" ;;
  *) echo "Unknown pack: $PACK" >&2; exit 1 ;;
esac

[ -f "$SRC/pack.yaml" ] || { echo "Missing pack.yaml in $SRC" >&2; exit 1; }

# skills | agents | commands → .agents/<kind>; profile and other extras → project root
copy_tree() {
  kind="$1"
  under_agents="$2"   # 1 = install under .agents/, 0 = project root
  src_dir="$SRC/$kind"
  if [ "$under_agents" -eq 1 ]; then
    dst_dir="$TARGET/.agents/$kind"
    label=".agents/$kind"
  else
    dst_dir="$TARGET/$kind"
    label="$kind"
  fi
  [ -d "$src_dir" ] || return 0
  mkdir -p "$dst_dir"
  for path in "$src_dir"/*; do
    [ -e "$path" ] || continue
    name=$(basename "$path")
    dest="$dst_dir/$name"
    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
      echo "Skip existing $label/$name (use --force to overwrite)"
      continue
    fi
    rm -rf "$dest"
    cp -R "$path" "$dest"
    echo "Installed $label/$name"
  done
}

copy_tree skills 1
copy_tree agents 1
copy_tree commands 1
copy_tree profile 0

# Ensure project has a linker at .agents/scripts/link.sh
mkdir -p "$TARGET/.agents/scripts"
if [ ! -f "$TARGET/.agents/scripts/link.sh" ] || [ "$FORCE" -eq 1 ]; then
  cp "$KIT_ROOT/core/scripts/link.sh" "$TARGET/.agents/scripts/link.sh"
  chmod +x "$TARGET/.agents/scripts/link.sh"
  echo "Installed .agents/scripts/link.sh"
fi
chmod +x "$KIT_ROOT/core/scripts/link.sh" "$KIT_ROOT/core/scripts/install-into.sh" 2>/dev/null || true

if [ "$DO_LINK" -eq 1 ]; then
  (cd "$TARGET" && sh .agents/scripts/link.sh)
fi

echo "Done. Pack '$PACK' → $TARGET"
