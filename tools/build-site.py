#!/usr/bin/env python3
"""Build the readable website from the works.

    tools/build-site.py

Writes docs/ — an index page and one page per finished work — from the
.txt files, so the site can never say something the archive copy doesn't.
GitHub Pages serves docs/ at https://balukarthik.github.io/Writings/ .

A work is published only when its text has no [?] markers left. Run this
after any change to a work, then commit docs/ with it.
"""
import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORKS = ROOT / "works"
OUT = ROOT / "docs"
RULE = "------------------------------------------------"

def conf():
    c = {}
    for line in (ROOT / "author.conf").read_text(encoding="utf-8").splitlines():
        m = re.match(r'^([A-Z_]+)="([^"]*)"', line)
        if m:
            k, v = m.groups()
            c[k] = re.sub(r"\$([A-Z_]+)", lambda mm: c.get(mm.group(1), ""), v)
    return c

def read_work(d):
    txt = d / f"{d.name}.txt"
    if not txt.exists():
        return None
    raw = txt.read_text(encoding="utf-8")
    if re.search(r"\[[^\[\]]*\?\]", raw):
        print(f"skip {d.name}: still has [?] markers", file=sys.stderr)
        return None
    head, _, body = raw.partition(RULE)
    fields = dict(re.findall(r"^([^:\n]+): (.*)$", head, re.M))
    title = fields.get("தலைப்பு", d.name)
    year = fields.get("எழுதப்பட்ட ஆண்டு", "")
    lines = body.strip("\n").splitlines()
    if lines and lines[0].strip() == title:      # title repeated at top of text
        lines = lines[1:]
    body = "\n".join(lines).strip("\n")
    date, archive = year, None
    meta = d / "archive-metadata.md"
    if meta.exists():
        m = meta.read_text(encoding="utf-8")
        dm = re.search(r"^\| Date \| (\d{4}-\d{2}-\d{2})", m, re.M)
        if dm:
            date = dm.group(1)
        # Link the archive item only once the Wayback line has been filled in —
        # that is the signal the upload actually happened.
        if "_(paste here)_" not in m:
            am = re.search(r"Item URL: `(https://archive\.org/details/[^`]+)`", m)
            archive = am.group(1) if am else None
    return dict(slug=d.name, title=title, year=year, date=date, body=body, archive=archive)

def verse(body):
    """One <p> per line so a line that wraps on a phone gets a hanging indent
    and still reads as one line; blank lines become stanza gaps."""
    out = []
    for line in body.splitlines():
        out.append('<p class="gap"></p>' if not line.strip() else f"<p>{html.escape(line)}</p>")
    return "\n".join(out)

def page(c, w, works):
    head = f"""<!doctype html>
<html lang="ta">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(w['title'])} — {html.escape(c['AUTHOR_TA'])}</title>
<link rel="stylesheet" href="../style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+Tamil:wght@400;600&display=swap" rel="stylesheet">
<body>
<header><a class="home" href="../">{html.escape(c['AUTHOR_TA'])}</a></header>
<main>
<article>
<h1>{html.escape(w['title'])}</h1>
<p class="byline">{html.escape(c['AUTHOR_TA'])} · <span class="when">{html.escape(w['date'])}</span></p>
<div class="text">
{verse(w['body'])}
</div>
</article>
"""
    links = []
    if w["archive"]:
        links.append(f'<a href="{w["archive"]}">Internet Archive</a>')
    links.append(f'<a href="https://github.com/balukarthik/Writings/blob/main/works/{w["slug"]}/{w["slug"]}.txt">மூல உரை · source text</a>')
    return head + footer(c, links)

def footer(c, links):
    return f"""<footer>
<p>© {html.escape(c['AUTHOR_TA'])} · <a href="{c['LICENSE_URL']}">CC BY 4.0</a>
— பகிரலாம், மொழிபெயர்க்கலாம்; ஆசிரியரின் பெயரைக் குறிப்பிட வேண்டும்.</p>
<p>{' · '.join(links)}</p>
</footer>
</main>
</html>
"""

def index(c, works):
    items = "\n".join(
        f'<li><a href="{w["slug"]}/">{html.escape(w["title"])}</a> <span class="when">{html.escape(w["date"])}</span></li>'
        for w in works)
    return f"""<!doctype html>
<html lang="ta">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(c['AUTHOR_TA'])} — படைப்புகள்</title>
<link rel="stylesheet" href="style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+Tamil:wght@400;600&display=swap" rel="stylesheet">
<body>
<main>
<h1 class="site">{html.escape(c['AUTHOR_TA'])}</h1>
<p class="sub">{html.escape(c['AUTHOR_EN'])} · படைப்புகள் · writings</p>
<ul class="works">
{items}
</ul>
""" + footer(c, [f'<a href="https://github.com/balukarthik/Writings">மூல உரைகள் · source texts</a>'])

CSS = """:root { color-scheme: light dark;
  --bg:#fbf8f2; --fg:#1d1a16; --muted:#7a7268; --rule:#e5ddd0; --link:#8a4b1f; }
@media (prefers-color-scheme: dark) {
  :root { --bg:#17150f; --fg:#ece6da; --muted:#9c9385; --rule:#2e2a22; --link:#e0a06a; } }
html { background:var(--bg); color:var(--fg); }
body { margin:0; font-family:"Noto Serif Tamil","Latha","Nirmala UI",serif;
  font-size:1.15rem; line-height:1.9; -webkit-text-size-adjust:100%; }
header { padding:1.2rem 1.25rem 0; }
header .home { text-decoration:none; color:var(--muted); font-size:.95rem; }
main { max-width:34rem; margin:0 auto; padding:2.5rem 1.25rem 4rem; }
h1 { font-weight:600; font-size:1.7rem; line-height:1.4; margin:0 0 .3rem; }
h1.site { font-size:1.9rem; margin-top:1.5rem; }
.sub, .byline { color:var(--muted); margin:0 0 2.5rem; font-size:.95rem; }
.text { font-size:1.25rem; line-height:2.05; }
.text p { margin:0; white-space:pre-wrap; padding-left:1.4em; text-indent:-1.4em; }
.text p.gap { height:1.2em; }
@media (max-width: 480px) { .text { font-size:1.15rem; } }
ul.works { list-style:none; padding:0; margin:0; }
ul.works li { padding:.9rem 0; border-top:1px solid var(--rule); display:flex;
  justify-content:space-between; gap:1rem; align-items:baseline; }
ul.works li:last-child { border-bottom:1px solid var(--rule); }
ul.works a { color:var(--fg); text-decoration:none; font-size:1.2rem; }
ul.works a:hover { color:var(--link); }
.when { color:var(--muted); font-size:.9rem; white-space:nowrap; }
a { color:var(--link); }
footer { margin-top:4rem; padding-top:1.2rem; border-top:1px solid var(--rule);
  color:var(--muted); font-size:.85rem; line-height:1.7; }
footer p { margin:.3rem 0; }
"""

def main():
    c = conf()
    works = [w for d in sorted(WORKS.iterdir()) if d.is_dir() for w in [read_work(d)] if w]
    works.sort(key=lambda w: w["date"], reverse=True)
    OUT.mkdir(exist_ok=True)
    (OUT / ".nojekyll").write_text("")          # serve as-is; no Jekyll pass
    (OUT / "style.css").write_text(CSS, encoding="utf-8")
    (OUT / "index.html").write_text(index(c, works), encoding="utf-8")
    for w in works:
        d = OUT / w["slug"]; d.mkdir(exist_ok=True)
        (d / "index.html").write_text(page(c, w, works), encoding="utf-8")
        print(f"built docs/{w['slug']}/  ({w['title']})")
    print(f"built docs/index.html  ({len(works)} work{'s' if len(works)!=1 else ''})")

if __name__ == "__main__":
    main()
