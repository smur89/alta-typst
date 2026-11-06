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
    "alta-footer",
    "alta-from-json",
    "alta-updated-footer",
    "altacv",
    "avatar-placeholder",
    "contact",
    "cv-header",
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
    "skills",
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
    "fluency-rating",
    "format-date",
    "group-by-type",
    "labels",
    "location-text",
  ),
)
