// Render-time context: the values `alta()` provides, from the merged
// preferences, to everything that renders. Typst `state` cells, read
// inside `context { }`, because the public helpers (`tag`, `term`,
// `divider`, `rating`, `icon`) can sit anywhere in a user's document
// and can't be passed the preferences. The theme's tokens and roles
// live in `design/theme.typ`.

#import "design/theme.typ": _default-theme

// The built themes (`_theme-for`) of the templates the content sits
// in, innermost last: `_document` pushes its theme and pops it after
// its body, so content after a nested template reads the outer one.
#let _theme-state = state("alta-theme", (_default-theme,))
// The theme in effect where it's read (in `context`).
#let _theme() = _theme-state.get().last()
// Read only by the public `rating()` helper's default `max`; the
// languages section passes `prefs.max-rating` explicitly.
#let _max-rating-state = state("alta-max-rating", 5)

