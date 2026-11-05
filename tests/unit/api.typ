// The public API is exactly what `lib.typ` re-exports: Typst
// re-exports every name a module imports, so an internal helper
// imported there would leak into a user's `#import ...: *`, and a
// dropped re-export would break callers.

#import "/lib.typ"

#assert.eq(
  dictionary(lib).keys().sorted(),
  (
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
    "maps-providers",
    "name",
    "palettes",
    "rating",
    "styled-link",
    "tag",
    "term",
    "themes",
  ),
)
