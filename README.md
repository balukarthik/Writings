# Writings

The original Tamil writings of **Rajarajeswari Balasubramanian**
(**ராஜராஜேஸ்வரி பாலசுப்ரமணியன்**) — handwritten notebooks — transcribed and
kept as plain UTF-8 text under Creative Commons Attribution 4.0.

She is the author. This repository is custodianship by her son, Karthik Balu
(கார்த்திக் பாலு) — typing, typesetting and uploading — and that work carries
no claim over the writing itself. Her name goes on every file, in every
copyright line, and in archive.org's Creator field; the transcriber is
credited separately, in the description.

**The `.txt` files are the archive.** Everything else — PDFs, EPUBs,
archive.org items — is generated from them or uploaded from them. Plain text
in git is the format most likely to still open in fifty years, and the only
one that survives a phone being lost, an app shutting down, or a cloud account
lapsing.

## Layout

```
author.conf                    Her name, yours, the licence — filled in once, read by the scripts
LICENSE                        CC BY 4.0
notebooks/register.csv         The physical notebooks and what has been done with each
templates/                     Licence header · working draft · archive.org sheet · email
tools/new-work.sh              Scaffold a new work with the header already stamped
tools/make-pdf.sh              Build an upload-ready PDF, typeset in Noto Serif Tamil
works/<slug>/<slug>-draft.txt  Working transcript, with page markers and doubts
works/<slug>/<slug>.txt        The finished text — the thing being preserved
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

1. **Photograph** the pages — see "Photographing handwriting" below. This is
   the one step that touches the originals, so it is worth doing carefully and
   once.
2. **Transcribe** into `<slug>-draft.txt`, keeping the `[[p012]]` page markers
   so every line can be traced back to the photo it came from. Handwriting is
   where OCR fails hardest — see "Transcribing handwriting" below for what
   actually works.
3. **Resolve the doubts.** This is the actual work. The errors that matter:
   ல/ள/ழ, ர/ற, ன/ண/ந, missing pulli (்), and lines put back in the wrong
   order. Mark anything uncertain `[?]` rather than guessing, and ask her —
   she can read her own hand, and a guess becomes *her* sentence in every copy
   that follows. Resolve every `[?]` before step 7.
4. **Move** the clean text below the dashed line in `<slug>.txt`, leaving the
   draft in place as the audit trail. Keep it UTF-8.
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

## Notebooks come first

Photograph a notebook **completely** before pulling individual works out of
it. Where a piece begins and ends is often not obvious until you can see the
pages side by side on a screen, and capturing the whole book first means the
paper is handled once rather than revisited every time a new story is found in
it. `notebooks/register.csv` tracks which notebooks are photographed, which are
transcribed, and where each physical book is.

## Photographing handwriting

Scanner apps are built for printed documents, and their defaults actively harm
handwriting:

- **Turn off the black-and-white / "document" filter.** It is tuned for printed
  black on white and will drop faint pencil, thin strokes and anything written
  in a lighter pen. Shoot in colour or greyscale.
- **Shoot at full resolution** and stop the app downscaling. A pulli is a few
  pixels; resolution is what makes it recoverable.
- **One page per photo, never a spread.** Pages curve toward the spine, and a
  curved page is what turns ஈ into ஈா in the transcript.
- **Include the margins.** Corrections, insertions and afterthoughts live
  there, and a tight crop silently deletes them.
- **Photograph every page in order, blanks included**, named
  `<notebook-id>-p001.jpg`. A missing number later is ambiguous — was the page
  blank, or was it missed?
- Diffuse light from above, phone parallel to the page, no hand shadow.

Do **three pages first** and get them transcribed before committing to two
hundred. How her particular hand comes out is only knowable by trying it, and
it may change how you shoot the rest.

## Transcribing handwriting

Google Lens and Docs OCR read printed Tamil well and handwritten Tamil badly —
badly enough that cleaning their output usually costs more than typing from
scratch. Realistic options, in order of how well they tend to work:

1. **Ask Claude to read the photos.** It handles handwriting far better than
   OCR because it reads words in context rather than shape by shape. It still
   makes mistakes — ல/ள/ழ and ன/ண especially — so its output is a draft with
   `[?]` markers, never the final file.
2. **Type it, with her reading aloud.** Slower per page, but it resolves the
   unreadable words at the same time, and it is the only method where the
   author is in the loop while the text is being made.
3. **Type it yourself** with Gboard Tamil, marking `[?]` for anything doubtful.

Whichever is used, step 3 above does not get skipped.

## Why more than one place

GitHub holds the text and its history. archive.org holds the citable public
copy and will outlive most things on this list. The Wayback snapshot proves
what the item said on a given date. Drive or a pendrive covers the case where
an account is lost. No single one of these is a backup by itself.
