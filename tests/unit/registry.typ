// Unit checks for the recognised top-level CV keys in
// internal/data/sections.typ.

#import "/internal/data/json-resume.typ": _altacv-schema
#import "/internal/data/sections.typ": _cv-keys

// `alta()` and the JSON import take the same top-level keys, so a
// gairm-import bump that adds one fails here, not in a user's build.
#assert.eq(_cv-keys.sorted(), _altacv-schema.shape.keys().sorted())
