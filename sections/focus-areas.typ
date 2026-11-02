// "Areas of Focus", an altacv extension read from
// `custom.altacv.focusAreas` (the `read` hook in `layout.typ`'s
// `_sections`); JSON Resume's `interests` has the `{name, keywords}`
// shape that `skills` renders.

#let _focus_areas(items, (labels, ..)) = if items.len() > 0 [
  == #labels.focusAreas

  #for item in items [- #item]
]
