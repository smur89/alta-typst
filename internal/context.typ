// Render-time context: the values `alta()` provides, from the merged
// preferences, to everything that renders. Typst `state` cells, read
// inside `context { }`, because the public helpers (`tag`, `term`,
// `divider`, `rating`, `icon`) can sit anywhere in a user's document
// and can't be passed the preferences. The theme's tokens and roles
// live in `design/theme.typ`.

#import "design/theme.typ": _default-theme

// The built theme (`_theme-for`).
#let _theme-state = state("alta-theme", _default-theme)
// Read only by the public `rating()` helper's default `max`; the
// languages section passes `prefs.max-rating` explicitly.
#let _max-rating-state = state("alta-max-rating", 5)
