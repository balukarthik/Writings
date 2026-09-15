# Writings

Master copies of my original Tamil writings, kept as plain UTF-8 text under
Creative Commons Attribution 4.0.

**The `.txt` files are the archive.** Everything else — PDFs, EPUBs,
archive.org items — is generated from them or uploaded from them. Plain text
in git is the format most likely to still open in fifty years, and the only
one that survives a phone being lost, an app shutting down, or a cloud account
lapsing.

## Layout

```
author.conf              Your name, year, licence — filled in once, read by the scripts
LICENSE                  CC BY 4.0
templates/               Licence header, archive.org sheet, submission email
tools/new-work.sh        Scaffold a new work with the header already stamped
tools/make-pdf.sh        Build an upload-ready PDF, typeset in Noto Serif Tamil
works/<slug>/<slug>.txt  One directory per finished work
```

Directory and file names use a Latin-letter slug (`mazhai-kathai`), never Tamil
characters — archive.org identifiers and older tools mangle non-Latin filenames.
The Tamil title lives *inside* the file, in the header.

## Adding a work

```bash
tools/new-work.sh mazhai-kathai "மழைக்கதை"
```

That writes `works/mazhai-kathai/mazhai-kathai.txt` with the licence header
already in place, and an `archive-metadata.md` next to it holding every value
the archive.org upload form asks for.

Then:

1. **Photograph** the pages with a scanner app (Adobe Scan, or iPhone Notes →
   Scan Documents) — not the plain camera. One page per shot, light from above,
   phone parallel to the page.
2. **Transcribe** to Tamil Unicode. Google Lens handles printed text well;
   handwriting it does not. Either way the output is a draft, never the
   final file.
3. **Proofread.** This is the actual work, and nobody else can do it. The
   errors that matter: ல/ள/ழ, ர/ற, ன/ண/ந, missing pulli (்), and lines put
   back in the wrong order by OCR. An archive keeps mistakes forever.
4. **Paste** the proofread text below the dashed line in the `.txt`. Keep it
   UTF-8.
5. **Build the PDF**: `tools/make-pdf.sh works/mazhai-kathai/mazhai-kathai.txt`
6. **Commit and push** the `.txt`. (The PDF is gitignored — it is a build
   product, and this repo stays text-only.)
7. **Upload to archive.org** using `works/<slug>/archive-metadata.md`. Set the
   language to Tamil. One item per finished work.
8. **Wayback** the resulting item page at https://web.archive.org/save
9. Record both URLs in `archive-metadata.md` and commit.
10. **FreeTamilEbooks** — only for a full book or collection, using
    `templates/freetamilebooks-email.md`.

Steps 7 and 8 must be done from a signed-in browser; everything above them can
be scripted.

## Why more than one place

GitHub holds the text and its history. archive.org holds the citable public
copy and will outlive most things on this list. The Wayback snapshot proves
what the item said on a given date. Drive or a pendrive covers the case where
an account is lost. No single one of these is a backup by itself.
