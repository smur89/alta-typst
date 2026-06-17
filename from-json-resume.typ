// JSON Resume → altacv input adapter. Imports gairm-import as a
// transitive dep, so users only pay for it when they opt into this
// module via `@preview/altacv:X.Y.Z/from-json-resume.typ` — the
// main `@preview/altacv` entry stays gairm-import-free.

#import "lib.typ": alta as _alta
#import "@preview/gairm-import:0.7.0": (
  parse as _parse,
  resume-schema-strict,
  lens, add-field,
  array-of, content-type, number-type, str-type,
)

// JSON Resume + altacv's three extensions. Dates stay validated as
// iso8601 (YYYY / YYYY-MM / YYYY-MM-DD) per the JSON Resume spec —
// altacv's `preferences.dateFormat` is the right place to control
// presentation. Free-text fields are coerced to `content` by the
// strict overlay, which is what altacv expects to splice into markup.
#let altacv-schema = {
  let s = resume-schema-strict
  s = add-field(s, lens(()), "focusAreas", array-of(content-type))
  s = add-field(s, lens(("languages", "items")), "rating", number-type)
  s = add-field(s, lens(("publications", "items")), "type", str-type)
  s
}

// Load + validate a JSON Resume document and return the dict
// `alta` expects. Use this when you want to inspect or transform
// the dict before rendering.
//
//   #import "@preview/altacv:X.Y.Z": alta
//   #import "@preview/altacv:X.Y.Z/from-json-resume.typ": from-json-resume
//   #alta(from-json-resume(path("resume.json")))
//
// `data` accepts what gairm-import's `parse` accepts: a `path(…)`
// value, a Typst-root-relative path string, or an already-parsed dict.
#let from-json-resume(data) = _parse(data, schema: altacv-schema)

// One-call alternative: read + validate + render in a single import.
// Equivalent to `alta(from-json-resume(data), labels: …, preferences: …)`.
//
//   #import "@preview/altacv:X.Y.Z/from-json-resume.typ": alta-from-json
//   #alta-from-json(path("resume.json"), preferences: (accent: rgb("#0a4")))
#let alta-from-json(data, labels: (:), preferences: (:)) = _alta(
  from-json-resume(data),
  labels: labels,
  preferences: preferences,
)
