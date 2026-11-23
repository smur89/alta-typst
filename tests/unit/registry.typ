// Unit checks for the recognised top-level CV keys in
// internal/data/sections.typ.

#import "/internal/data/canonical.typ": _legacy-root-fields
#import "/internal/data/sections.typ": _cv-keys

// `alta()` takes the schema's top-level keys plus the deprecated ones,
// so a schema update that adds one fails here.
#assert.eq(
  _cv-keys.sorted(),
  (
    json("/template/resume.schema.json").properties.keys() + _legacy-root-fields
  ).sorted(),
)
