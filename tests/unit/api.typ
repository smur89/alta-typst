// The public API is exactly what `lib.typ` re-exports: Typst
// re-exports every name a module imports, so an internal helper
// imported there would leak into a user's `#import ...: *`, and a
// dropped re-export would break callers.

#import "/lib.typ"

#assert.eq(
  dictionary(lib).keys().sorted(),
  (
    "adapter",
    "alta",
    "alta-from-json",
    "altacv",
    "avatar-placeholder",
    "contact",
    "cv-columns",
    "cv-footer",
    "cv-header",
    "cv-updated-footer",
    "divider",
    "entry",
    "from-json-resume",
    "icon",
    "label-row",
    "maps-providers",
    "name",
    "palettes",
    "publication",
    "rating",
    "skill-row",
    "styled-link",
    "tag",
    "term",
    "themes",
  ),
)

// `adapter` is a module: its helpers, and none of their imports.
#assert.eq(
  dictionary(lib.adapter).keys().sorted(),
  (
    "basics-contacts",
    "entries",
    "entry-type",
    "fluency-rating",
    "format-date",
    "group-by-type",
    "labels",
    "location-text",
    "preferences",
  ),
)
