// JSON Resume import: the strict JSON Resume 1.7.0 schema, vendored as
// `template/resume.schema.json` (the copy `typst init` gives users for
// gairm-import's `parse`, #418) and made strict as gairm-import's
// REFERENCE.md "A stricter JSON Resume" shows. Its `custom` objects
// carry altacv's extensions (`custom.altacv`); the deprecated forms of
// three of them are optional fields, so a `resume.json` still using
// them validates (`_canonical-cv` lifts them into `custom.altacv`)
// until #239 removes them. `alta-from-json` lives in `render.typ`, as
// it composes `alta`.

#import "@preview/gairm-import:1.0.0": (
  add-field, array-of, markup, number, parse as _parse, schema-from-json-schema,
  string,
)

// Closes every object that declares its properties, so a misspelt key
// is reported. `custom` declares none, so it stays open. JSON Resume
// has no `not` or `if`, where closing would loosen the schema.
#let _close(js) = if type(js) == dictionary {
  let js = js.pairs().map(((k, v)) => (k, _close(v))).to-dict()
  if (
    "properties" in js and js.at("additionalProperties", default: true) == true
  ) { js + (additionalProperties: false) } else { js }
} else if type(js) == array { js.map(_close) } else { js }

// A function, so only a JSON import pays for the schema; Typst caches
// the call.
#let _altacv-schema() = {
  let js = _close(json("/template/resume.schema.json"))
  // A full date, checked as one, or the year and month JSON Resume
  // also allows.
  js.definitions.iso8601 = (
    anyOf: (
      (type: "string", format: "date"),
      (type: "string", pattern: "^[0-9]{4}(-(0[1-9]|1[0-2]))?$"),
    ),
  )
  (
    (("focusAreas",), array-of(markup())),
    (("languages", "items", "rating"), number()),
    (("awards", "items", "url"), string()),
  ).fold(schema-from-json-schema(js), (s, (at, field)) => add-field(
    s,
    at,
    field,
  ))
}

/// Validates a `resume.json` against the JSON Resume schema (plus
/// altacv's extensions) and returns the CV dictionary `alta` takes.
/// Panics on an invalid document, naming the field. Deprecated (#239):
/// gairm-import's `parse` with the JSON Resume schema, as the README's
/// "A `resume.json`" shows.
///
/// - data (path, dictionary): The `resume.json`, as
///   `path("resume.json")`, or an already-decoded dictionary.
/// -> dictionary
#let from-json-resume(data) = _parse(_altacv-schema(), data)
