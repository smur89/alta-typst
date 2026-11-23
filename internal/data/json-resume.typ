// JSON Resume import: the strict JSON Resume 1.7.0 schema, whose
// `custom` objects carry altacv's extensions (`custom.altacv`), plus
// the deprecated forms of three of them as optional fields, so a
// `resume.json` still using them validates (`_canonical-cv` lifts them
// into `custom.altacv`) until #239 removes them. `alta-from-json`
// lives in `render.typ`, as it composes `alta`.
//
// The schema is JSON Resume's own `schema.json`, vendored at 1.7.0 as
// `template/resume.schema.json`, the copy `typst init` gives users for
// gairm-import's `parse` (#418). It is made strict as gairm-import's
// REFERENCE.md "A stricter JSON Resume" shows, which is what
// gairm-import 0.13.0's `resume-schema-strict` did.

#import "@preview/gairm-import:1.0.0": (
  add-field, array-of, markup, number, parse as _parse, schema-from-json-schema,
  schema-put, string,
)

// Closes every object that declares its properties, so a misspelt key
// is reported. `custom` declares none, so it stays open. JSON Resume
// has no `not` or `if`, where closing would loosen the schema.
#let _close(js) = if type(js) == dictionary {
  let js = js.pairs().map(((k, v)) => (k, _close(v))).to-dict()
  if (
    "properties" in js and js.at("additionalProperties", default: true) == true
  ) {
    js.additionalProperties = false
  }
  js
} else if type(js) == array { js.map(_close) } else { js }

#let _strict-json = {
  let js = _close(json("/template/resume.schema.json"))
  // A full date, checked as one, or the year and month JSON Resume
  // also allows.
  js.definitions.iso8601 = (
    anyOf: (
      (type: "string", format: "date"),
      (type: "string", pattern: "^[0-9]{4}(-(0[1-9]|1[0-2]))?$"),
    ),
  )
  js
}

// The free-text fields, taken as Typst `content`.
#let _markup-paths = (
  ("objective",),
  ("basics", "summary"),
  ("work", "items", "summary"),
  ("work", "items", "highlights", "items"),
  ("volunteer", "items", "summary"),
  ("volunteer", "items", "highlights", "items"),
  ("education", "items", "summary"),
  ("awards", "items", "summary"),
  ("certificates", "items", "summary"),
  ("publications", "items", "summary"),
  ("references", "items", "reference"),
  ("projects", "items", "summary"),
  ("projects", "items", "description"),
  ("projects", "items", "highlights", "items"),
)

#let _altacv-schema = (
  (("focusAreas",), array-of(markup())),
  (("languages", "items", "rating"), number()),
  (("awards", "items", "url"), string()),
).fold(
  _markup-paths.fold(
    schema-from-json-schema(_strict-json),
    (s, at) => schema-put(s, at, markup()),
  ),
  (s, (at, field)) => add-field(s, at, field),
)

/// Validates a `resume.json` against the JSON Resume schema (plus
/// altacv's extensions) and returns the CV dictionary `alta` takes.
/// Panics on an invalid document, naming the field. Deprecated (#239):
/// gairm-import's `parse`, with the JSON Resume schema `typst init`
/// copies beside `resume.json`:
/// `parse(schema-from-json-schema(json("resume.schema.json")), path("resume.json"))`.
///
/// - data (path, dictionary): The `resume.json`, as
///   `path("resume.json")`, or an already-decoded dictionary.
/// -> dictionary
#let from-json-resume(data) = _parse(_altacv-schema, data)
