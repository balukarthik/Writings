# archive.org upload sheet — {{TITLE_TA}}

Fill nothing in here by hand: `tools/new-work.sh` already substituted the
details. Open https://archive.org, click **Upload**, and copy each value across.

The **Creator is the author — {{AUTHOR_TA}} — not the account doing the
uploading.** archive.org has no separate field for a custodian, so the
transcriber is credited in the description instead.

## Files to upload (all three)

- `{{SLUG}}.txt` — the master text. **This is the one that matters.**
- `{{SLUG}}.pdf` — built with `tools/make-pdf.sh`
- `{{SLUG}}-scans.pdf` — the page photos, if you have them

## Form values

| Field | Value |
|---|---|
| Page title | {{TITLE_TA}} |
| Identifier | `{{SLUG}}-{{AUTHOR_SLUG}}-{{YEAR}}` |
| Creator | {{AUTHOR_TA}} / {{AUTHOR_EN}} |
| Date | {{YEAR}} — the year it was **written**, not the year scanned |
| Language | **Tamil** (`tam`) — must not be left as English |
| Collection | Community Texts |
| Licence | CC BY 4.0 |
| Subject tags | Tamil, Tamil literature, short story, {{AUTHOR_EN}}, Creative Commons |

## Description (paste as-is, then add a Tamil sentence or two above it)

```
Original Tamil work by {{AUTHOR_TA}} ({{AUTHOR_EN}}), written {{YEAR}}.
Digitised from the author's manuscript and published with her permission by
{{CUSTODIAN_EN}}, {{DIGITIZED_YEAR}}.
Licensed CC BY 4.0 — https://creativecommons.org/licenses/by/4.0/
```

## After uploading

1. Wait for the item to go public (a few minutes), then record the URL below.
2. Paste that URL into https://web.archive.org/save and record the snapshot URL.

- Item URL: `https://archive.org/details/{{SLUG}}-{{AUTHOR_SLUG}}-{{YEAR}}`
- Wayback snapshot: _(paste here)_

**Why the language field matters:** if it is left as English, archive.org runs
English OCR over the scans and stores mangled text as the item's searchable
content. The `.txt` you uploaded is the defence against that — it is the only
copy guaranteed to be correct.
