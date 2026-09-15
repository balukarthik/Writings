#!/usr/bin/env bash
# Scaffold a new work: creates works/<slug>/<slug>.txt with the licence
# header already stamped, plus its archive.org metadata sheet.
#
#   tools/new-work.sh mazhai-kathai "மழைக்கதை"
#
# The slug must be Latin letters and hyphens only — archive.org identifiers
# and file names must not contain Tamil characters.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/author.conf"

slug="${1:-}"
title_ta="${2:-}"

if [ -z "$slug" ] || [ -z "$title_ta" ]; then
  echo "usage: tools/new-work.sh <english-slug> \"<தமிழ் தலைப்பு>\"" >&2
  exit 1
fi

if ! printf '%s' "$slug" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "error: slug must be lowercase Latin letters, digits and hyphens only" >&2
  echo "       got: $slug" >&2
  exit 1
fi

if [ "$AUTHOR_TA" = "FILL_ME" ] || [ "$AUTHOR_EN" = "FILL_ME" ]; then
  echo "error: fill in author.conf first (AUTHOR_TA, AUTHOR_EN, AUTHOR_SLUG)" >&2
  exit 1
fi

dir="$ROOT/works/$slug"
txt="$dir/$slug.txt"
[ -e "$txt" ] && { echo "error: $txt already exists" >&2; exit 1; }

mkdir -p "$dir"

subst() {
  sed -e "s|{{TITLE_TA}}|$title_ta|g" \
      -e "s|{{AUTHOR_TA}}|$AUTHOR_TA|g" \
      -e "s|{{AUTHOR_EN}}|$AUTHOR_EN|g" \
      -e "s|{{AUTHOR_SLUG}}|$AUTHOR_SLUG|g" \
      -e "s|{{YEAR}}|$YEAR|g" \
      -e "s|{{SLUG}}|$slug|g" \
      -e "s|{{LICENSE_NAME}}|$LICENSE_NAME|g" \
      -e "s|{{LICENSE_URL}}|$LICENSE_URL|g"
}

subst < "$ROOT/templates/work-header.txt" > "$txt"
subst < "$ROOT/templates/archive-metadata.md" > "$dir/archive-metadata.md"

echo "created $txt"
echo "        $dir/archive-metadata.md"
echo
echo "next: paste the proofread Tamil text below the dashed line in the .txt,"
echo "      then run: tools/make-pdf.sh works/$slug/$slug.txt"
