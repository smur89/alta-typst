#!/usr/bin/env bash
# Every public export (the list tests/unit/api.typ pins) needs a `///`
# doc comment on the line above its definition, as Tinymist shows on
# hover. Typst can't see comments, so this is a source check.
set -euo pipefail
cd "$(dirname "$0")/.."
names=$(sed -n '/^    "/s/^    "\([^"]*\)",$/\1/p' tests/unit/api.typ)
status=0
for name in $names; do
  hit=$(grep -n -E "^#let ${name}( |\(|$)" lib.typ internal/*.typ internal/*/*.typ | head -1)
  if [ -z "$hit" ]; then
    echo "doc-comments: no definition found for \`$name\`" >&2; status=1; continue
  fi
  file=${hit%%:*}; line=$(echo "$hit" | cut -d: -f2)
  if [ "$line" -le 1 ] || ! sed -n "$((line - 1))p" "$file" | grep -q '^///'; then
    echo "doc-comments: $file:$line \`$name\` has no /// doc comment above it" >&2; status=1
  fi
done
exit $status
