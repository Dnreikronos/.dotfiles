#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
case "$mode" in
  light|dark) ;;
  *) echo "usage: $0 light|dark" >&2; exit 1 ;;
esac

dir="$(cd "$(dirname "$0")" && pwd)"
cat > "$dir/theme.conf" <<EOF
# Active theme - managed by switch-theme.sh (F2=light, F3=dark)
include theme-${mode}.conf
EOF

kitty @ load-config
