// Unit checks for the recognised top-level CV keys in
// internal/layout.typ.

#import "/internal/layout.typ": _cv_keys
#import "/internal/json-resume.typ": altacv-schema

// Every root key the JSON import accepts is accepted by `alta()` too,
// so a gairm-import bump that adds one fails here instead of being
// rejected later by `alta()`.
#for key in altacv-schema.shape.keys() {
  assert(key in _cv_keys, message: key + " is missing from _cv_keys")
}
// Deprecated top-level `focusAreas` comes from the canonical step's
// legacy list, not from the section table.
#assert("focusAreas" in _cv_keys)
#assert("objective" in _cv_keys)
