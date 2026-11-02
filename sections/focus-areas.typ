// Prose-style "Areas of Focus" — an array of content items rendered
// as a bulleted list. This is an altacv extension, read from
// `custom.altacv.focusAreas` (the `read` hook on its `_sections` row
// in `layout.typ`); JSON Resume's `interests` carries the
// `{name, keywords}` shape that the `skills` section uses.

#let _focus_areas(items, (labels, ..)) = if items.len() > 0 [
  == #labels.focusAreas

  #for item in items [- #item]
]
