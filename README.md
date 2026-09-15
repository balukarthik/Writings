# Writings

My mother's original Tamil writings, transcribed from her manuscripts and kept
as plain UTF-8 text under Creative Commons Attribution 4.0.

She is the author. This repository is custodianship — typing, typesetting and
uploading — and that work carries no claim over the writing itself. Her name
goes on every file, in every copyright line, and in archive.org's Creator
field; the transcriber is credited separately, in the description.

**The `.txt` files are the archive.** Everything else — PDFs, EPUBs,
archive.org items — is generated from them or uploaded from them. Plain text
in git is the format most likely to still open in fifty years, and the only
one that survives a phone being lost, an app shutting down, or a cloud account
lapsing.

## Layout

```
author.conf              Her name, yours, the licence — filled in once, read by the scripts
LICENSE                  CC BY 4.0
templates/               Licence header · archive.org sheet · submission email
tools/new-work.sh        Scaffold a new work with the header already stamped
tools/make-pdf.sh        Build an upload-ready PDF, typeset in Noto Serif Tamil
works/<slug>/<slug>.txt  One directory per finished work
```

Directory and file names use a Latin-letter slug (`mazhai-kathai`), never Tamil
characters — archive.org identifiers and older tools mangle non-Latin filenames.
The Tamil title lives *inside* the file, in the header.

## Whose permission this is

She has agreed to CC BY 4.0. `author.conf` holds the record, under
`LICENSE_GRANTED_BY` / `LICENSE_GRANTED_ON` — worth keeping accurate, because
the grant is hers and nobody else's to make, and because once a work is public
the licence cannot be withdrawn: anyone may copy, translate and republish it,
and must credit her.

Everything published here goes out under that grant. Anything she has not
released is still worth scanning and transcribing — steps 1 to 6 below are
preservation either way — it simply stops before step 7.

## Adding a work

```bash
tools/new-work.sh mazhai-kathai "மழைக்கதை" 1987
```

The third argument is the year **she wrote it**, which is usually not the year
you are typing it up. It is stamped into the copyright line and used as the
archive.org date, so pass it whenever you know it. Where a piece is undated,
ask her, or estimate and mark the estimate plainly.

That writes `works/mazhai-kathai/mazhai-kathai.txt` with the licence header
already in place, and an `archive-metadata.md` next to it holding every value
the archive.org upload form asks for.

Then:

1. **Photograph** the pages with a scanner app (Adobe Scan, or iPhone Notes →
   Scan Documents) — not the plain camera. One page per shot, light from above,
   phone parallel to the page. Handle the originals as the originals; the paper
   is the thing the copies are made from.
2. **Transcribe** to Tamil Unicode. Handwriting is where OCR fails hardest, so
   treat whatever comes out as a draft, never as the file.
3. **Proofread.** This is the actual work. The errors that matter: ல/ள/ழ,
   ர/ற, ன/ண/ந, missing pulli (்), and lines put back in the wrong order.
   Where you genuinely cannot read a word, mark it `[?]` rather than guessing,
   and ask her — a guess becomes permanent the moment it is uploaded, and it
   becomes *her* sentence in everyone else's copy. Resolve every `[?]` before
   step 7.
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
