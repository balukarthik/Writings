#!/usr/bin/env bash
# Build an upload-ready PDF from a master .txt, typeset in Noto Serif Tamil.
#
#   tools/make-pdf.sh works/mazhai-kathai/mazhai-kathai.txt
#
# The PDF is a build product — it is gitignored on purpose. Regenerate it
# whenever you need to upload; the .txt is the thing that is kept.
#
# Requires: libreoffice-writer and a Tamil font. On Debian/Ubuntu:
#   sudo apt-get install -y libreoffice-writer fonts-noto-core
set -euo pipefail

src="${1:-}"
[ -z "$src" ] && { echo "usage: tools/make-pdf.sh <path/to/work.txt>" >&2; exit 1; }
[ -f "$src" ] || { echo "error: no such file: $src" >&2; exit 1; }

command -v soffice >/dev/null 2>&1 || {
  echo "error: libreoffice not found. Install libreoffice-writer." >&2; exit 1; }

# No pipe here on purpose: under `set -o pipefail`, `... | grep -q` lets grep
# exit early, the producer dies of SIGPIPE, and the check misfires. A
# here-string has no producer process, so it cannot.
installed_fonts="$(fc-list 2>/dev/null || true)"
if ! grep -qi tamil <<<"$installed_fonts"; then
  echo "warning: no Tamil font found — output may render as empty boxes." >&2
  echo "         install fonts-noto-core, then re-run." >&2
fi

dir="$(cd "$(dirname "$src")" && pwd)"
base="$(basename "$src" .txt)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Wrap the plain text in HTML so LibreOffice applies a real Tamil font and
# sensible page margins. Escaping is done in Python so that &, < and > in the
# text cannot break the markup.
python3 - "$src" "$tmp/$base.html" <<'PY'
import html, sys, pathlib
src, dst = sys.argv[1], sys.argv[2]
text = pathlib.Path(src).read_text(encoding="utf-8")
# LibreOffice's HTML import ignores white-space:pre and adds its own spacing
# around every <p>, so the text goes in as ONE paragraph with <br> line
# breaks (honoured literally) and verse indentation as explicit &nbsp;.
def line_html(line):
    stripped = line.lstrip(" ")
    return "&nbsp;" * (len(line) - len(stripped)) + html.escape(stripped)
body = "<p>" + "<br>\n".join(line_html(l) for l in text.splitlines()) + "</p>"
pathlib.Path(dst).write_text(f"""<!doctype html>
<meta charset="utf-8">
<style>
  @page {{ size: A4; margin: 2.2cm 2cm; }}
  body {{ font-family: 'Noto Serif Tamil', 'Noto Sans Tamil', serif;
         font-size: 12pt; line-height: 1.6; }}
  p {{ margin: 0; }}
</style>
<body>
{body}
</body>
""", encoding="utf-8")
PY

# HOME must be writable — LibreOffice refuses to start without a profile dir.
HOME="$tmp" soffice --headless --norestore \
  --convert-to pdf "$tmp/$base.html" --outdir "$tmp" >/dev/null 2>&1

[ -f "$tmp/$base.pdf" ] || { echo "error: conversion produced no PDF" >&2; exit 1; }
mv "$tmp/$base.pdf" "$dir/$base.pdf"
echo "wrote $dir/$base.pdf"
