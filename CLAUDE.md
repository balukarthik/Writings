# Writings — instructions for Claude

The handwritten Tamil notebooks of **Rajarajeswari Balasubramanian**
(ராஜராஜேஸ்வரி பாலசுப்ரமணியன்), transcribed into plain UTF-8 text under
CC BY 4.0 by her son **Karthik Balu**, the custodian. She is the author;
nothing in this repo claims otherwise. Read `README.md` for the full
workflow; this file is the part Claude needs to act on.

## The job Claude does here

Read photographs of notebook pages and produce a **transcript draft** —
never a finished file. The draft goes in `works/<slug>/<slug>-draft.txt`;
the clean text is moved to `works/<slug>/<slug>.txt` only after Karthik (and
she) have resolved every doubt.

Photos arrive as chat attachments or via the Google Drive connector
(`read_file_content` handles jpg/png/pdf). Photos live in Drive and on
archive.org — **never in this repository** (`.gitignore` enforces it).

## Transcription rules

1. **Transcribe what is written, not what should have been written.** Her
   spelling, her grammar, her punctuation, older orthography, dialect forms —
   all of it is the text. Do not modernise, correct or smooth. This is an
   archive of her writing, not an edition of it.
2. **Never guess silently.** A word that cannot be read with confidence is
   `[?]`; a best guess with doubt is `[சொல்?]`. A silent guess becomes her
   sentence in every later copy. When in doubt, mark it.
3. **Confusable letters get extra care**: ல/ள/ழ, ர/ற, ன/ண/ந, and the pulli
   (்). When the handwriting genuinely does not settle it, prefer the reading
   the sentence requires and mark it `[…?]` so a human confirms.
4. **Page markers.** Start every page with `[[pNNN]]` matching the photo's
   number (`<notebook-id>-p012.jpg` → `[[p012]]`). Blank pages are recorded
   as `[[p013]] [[blank]]`, never skipped.
5. **Layout.** Keep her line breaks within verse; for prose, one paragraph
   per paragraph on the page. Crossed-out text is omitted (her final intent
   is the text); insertions go where her caret points; marginal notes that
   are part of the text go inline as `[margin: …]`, anything else (dates,
   doodles, unrelated lists) as a one-line `[note: …]`.
6. **Report per page**, after the transcript: how legible the page was and
   which `[?]` marks need her. Karthik uses this to decide whether to reshoot.
7. **Batch size.** A few pages per turn, checked, beats fifty pages of drift.
   Number the pages in the reply so the transcript and the photos stay aligned.

## Files and tools

- `author.conf` — names, years, licence. Read by the scripts. Do not edit
  without being asked; the names are confirmed correct.
- `tools/new-work.sh <slug> "<தமிழ்த் தலைப்பு>" <year-written>` — creates
  `works/<slug>/` with the header stamped, the draft file, and the archive.org
  sheet. Slugs are lowercase Latin letters and hyphens only. Always use the
  script; never hand-write the header.
- `tools/make-pdf.sh works/<slug>/<slug>.txt` — builds the upload PDF.
  Needs `libreoffice-writer` and `fonts-noto-core`; in a fresh remote
  container: `apt-get update && apt-get install -y libreoffice-writer
  fonts-noto-core` (verified working). The PDF is gitignored — a build
  product, rebuilt when needed.
- `notebooks/register.csv` — one row per physical notebook. Update
  `photographed` / `transcribed` as work progresses (`none`/`partial`/`done`).
- `templates/` — the sources of the header, draft skeleton, archive.org
  sheet and FreeTamilEbooks email. Edit these, not their generated copies.

## Git

- Commit directly to `main` and push (`git push -u origin main`).
- Text only: `.txt`, `.md`, `.csv`, `.sh`, `.conf`. If a photo or PDF is
  about to be staged, something is wrong — stop.
- Commit the draft as it progresses. It is the audit trail, and partial
  progress that exists only in a chat session is lost when the session ends.

## What Claude cannot do from a remote session

archive.org and web.archive.org are network-blocked and need Karthik's
credentials regardless. `tools/upload-ia.sh works/<slug> --date …` does the
upload and Wayback snapshot in one command **on his machine** (after a
one-time `ia configure`). From a remote session, Claude gets the work to the
point where that command is all that is left, and never runs it.
