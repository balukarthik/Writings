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

# Captured first, not piped straight into grep -q: under `set -o pipefail`,
# grep -q exits early, fc-list dies of SIGPIPE, and the check misfires.
installed_fonts="$(fc-list 2>/dev/null || true)"
if ! printf '%s' "$installed_fonts" | grep -qi tamil; then
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
body = "\n".join(
    "<p>&nbsp;</p>" if not line.strip() else f"<p>{html.escape(line)}</p>"
    for line in text.splitlines()
)
pathlib.Path(dst).write_text(f"""<!doctype html>
<meta charset="utf-8">
<style>
  @page {{ size: A4; margin: 2.2cm 2cm; }}
  body {{ font-family: 'Noto Serif Tamil', 'Noto Sans Tamil', serif;
         font-size: 12pt; line-height: 1.6; }}
  p {{ margin: 0 0 0.35em 0; white-space: pre-wrap; }}  /* keep verse indents */
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
