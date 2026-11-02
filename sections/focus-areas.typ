// Prose-style "Areas of Focus" — an array of content items rendered
// as a bulleted list. This is an altacv extension, read from
// `custom.altacv.focusAreas` or the deprecated top-level `focusAreas`
// (the `read` hook on its `_sections` row in `layout.typ`); JSON
// Resume's `interests` carries the `{name, keywords}` shape that the
// `skills` section uses. `prefs` is unused; it's accepted so every
// renderer shares the `(entries, labels, prefs)` dispatch signature.

#let _focus_areas(items, labels, prefs) = if items.len() > 0 [
  == #labels.focusAreas

  #for item in items [- #item]
]
