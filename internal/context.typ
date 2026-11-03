// Render-time context: the values `alta()` provides, from the merged
// preferences, to everything that renders. Typst `state` cells, read
// inside `context { }`, because the public helpers (`tag`, `term`,
// `divider`, `rating`, `icon`) can sit anywhere in a user's document
// and can't be passed the preferences. The theme's fixed values live
// in `design/theme.typ`.

#import "design/presets.typ": palettes

#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", palettes.teal)
// Read only by the public `rating()` helper's default `max`; the
// languages section passes `prefs.maxRating` explicitly.
#let _max_rating_state = state("alta-max-rating", 5)
