#!/usr/bin/env bash
# Upload one finished work to the Internet Archive, then snapshot the item
# in the Wayback Machine. Replaces the web form.
#
#   tools/upload-ia.sh works/surya-vanakkam --date 2024-08-18
#   tools/upload-ia.sh works/surya-vanakkam --date 2024-08-18 --dry-run
#
# One-time setup on the machine you run this from:
#   pip install internetarchive
#   ia configure            # asks for your archive.org email + password once
#
# Metadata comes from the work's .txt header and author.conf, so the item
# says exactly what the file says. --date is the day it was written; without
# it the year from the header is used. --dry-run assembles the request and
# prints it without sending anything.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=/dev/null
source "$ROOT/author.conf"

dir=""; date=""; dry=""
while [ $# -gt 0 ]; do
  case "$1" in
    --date)    date="$2"; shift 2 ;;
    --dry-run) dry=1; shift ;;
    -*)        echo "unknown option: $1" >&2; exit 1 ;;
    *)         dir="$1"; shift ;;
  esac
done
[ -n "$dir" ] || { echo "usage: tools/upload-ia.sh works/<slug> [--date YYYY-MM-DD] [--dry-run]" >&2; exit 1; }
dir="${dir%/}"; slug="$(basename "$dir")"
txt="$dir/$slug.txt"; pdf="$dir/$slug.pdf"; scans="$dir/$slug-scans.pdf"

[ -f "$txt" ] || { echo "error: $txt not found" >&2; exit 1; }
[ -f "$pdf" ] || { echo "error: $pdf not found — run tools/make-pdf.sh $txt first" >&2; exit 1; }
command -v ia >/dev/null || { echo "error: 'ia' not found — pip install internetarchive" >&2; exit 1; }

if grep -q '\[[^]]*?\]' "$txt"; then
  echo "error: $txt still has [?] doubt markers — resolve them before uploading" >&2
  exit 1
fi

# Pull the title and year from the licence header, so the item and the file
# can never disagree.
title="$(sed -n 's/^தலைப்பு: //p' "$txt" | head -1)"
year="$(sed -n 's/^எழுதப்பட்ட ஆண்டு: //p' "$txt" | head -1)"
[ -n "$title" ] && [ -n "$year" ] || { echo "error: could not read தலைப்பு / ஆண்டு from $txt header" >&2; exit 1; }
[ -n "$date" ] || date="$year"

identifier="$slug-$AUTHOR_SLUG-$year"

description="$title — $AUTHOR_TA எழுதிய படைப்பு ($year).

Original Tamil work by $AUTHOR_TA ($AUTHOR_EN), written $date. Digitised from the author's handwritten notebook and published with her permission by $CUSTODIAN_EN, $DIGITIZED_YEAR. Licensed CC BY 4.0 — $LICENSE_URL

Source text and history: https://github.com/balukarthik/Writings"

files=("$txt" "$pdf")
[ -f "$scans" ] && files+=("$scans")

args=(
  --metadata="mediatype:texts"
  --metadata="collection:opensource"          # = Community Texts
  --metadata="title:$title"
  --metadata="creator:$AUTHOR_TA / $AUTHOR_EN"
  --metadata="date:$date"
  --metadata="language:tam"                    # Tamil — decides which OCR runs
  --metadata="licenseurl:$LICENSE_URL"
  --metadata="rights:$LICENSE_NAME"
  --metadata="subject:Tamil; Tamil literature; $AUTHOR_EN; Creative Commons"
  --metadata="description:$description"
  --retries=5
)

echo "identifier : $identifier"
echo "files      : ${files[*]}"
echo "title      : $title"
echo "date       : $date"
echo

if [ -n "$dry" ]; then
  ia upload "$identifier" "${files[@]}" "${args[@]}" --debug
  echo; echo "(dry run — nothing uploaded)"
  exit 0
fi

ia upload "$identifier" "${files[@]}" "${args[@]}"
item="https://archive.org/details/$identifier"
echo; echo "item       : $item"

# Wayback snapshot. The save endpoint returns the archived path in a
# Content-Location header; if it doesn't (rate limit, queue), do it by hand.
echo "snapshotting in the Wayback Machine..."
snap="$(curl -s -o /dev/null -D - --max-time 120 "https://web.archive.org/save/$item" \
        | tr -d '\r' | sed -n 's/^[Cc]ontent-[Ll]ocation: //p' | head -1 || true)"
if [ -n "$snap" ]; then
  echo "wayback    : https://web.archive.org$snap"
else
  echo "wayback    : not confirmed — open https://web.archive.org/save and paste the item URL"
fi
echo
echo "Record both URLs in $dir/archive-metadata.md and commit."
