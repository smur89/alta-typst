// Unit checks for the recognised top-level CV keys in
// internal/data/sections.typ.

#import "/internal/data/json-resume.typ": _altacv-schema
#import "/internal/data/sections.typ": _cv-keys

// Every root key the JSON import accepts is accepted by `alta()` too,
// so a gairm-import bump that adds one fails here instead of being
// rejected later by `alta()`.
#for key in _altacv-schema.shape.keys() {
  assert(key in _cv-keys, message: key + " is missing from _cv-keys")
}
// Deprecated top-level `focusAreas` comes from the canonical step's
// legacy list, not from the section table.
#assert("focusAreas" in _cv-keys)
#assert("objective" in _cv-keys)
// And the reverse: the JSON import takes every CV key, so neither
// route has a top-level key the other rejects.
#assert.eq(
  _cv-keys.filter(k => k not in _altacv-schema.shape.keys()),
  (),
)
