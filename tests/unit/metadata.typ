// Unit checks for the PDF metadata (internal/data/metadata.typ), which
// no render shows.

#import "/internal/data/metadata.typ": _pdf-metadata

#let labels = (documentTitle: "{name} — CV")
#let basics = (name: "Jane Doe")

// Only the title and author when nothing else is set.
#assert.eq(
  _pdf-metadata((basics: basics, meta: (:)), (skills: ()), labels),
  (title: "Jane Doe — CV", author: "Jane Doe"),
)

// Skill keywords de-duplicated, first occurrence first, with
// `meta.canonical` / `meta.version` after them; the summary as the
// description; the calendar part of `meta.lastModified` as the date.
#let full = _pdf-metadata(
  (
    basics: basics + (summary: "Backend engineer."),
    meta: (
      canonical: "https://example.com/cv.json",
      version: "v1.0.0",
      lastModified: "2026-06-12T14:00:00Z",
    ),
  ),
  (
    skills: (
      (name: "Languages", keywords: ("Scala", "", "Python")),
      (name: "Infra", keywords: ("Kafka", "Scala")),
      (name: "Soft skills"),
    ),
  ),
  labels,
)
#assert.eq(
  full.keywords,
  ("Scala", "Python", "Kafka", "https://example.com/cv.json", "v1.0.0"),
)
#assert.eq(full.description, "Backend engineer.")
#assert.eq(full.date, datetime(year: 2026, month: 6, day: 12))

// An empty summary and a date that isn't ISO set nothing.
#let sparse = _pdf-metadata(
  (
    basics: basics + (summary: ""),
    meta: (lastModified: "June 2026"),
  ),
  (skills: ()),
  labels,
)
#assert("description" not in sparse and "date" not in sparse)
