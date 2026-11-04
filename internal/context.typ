// Render-time context: the values `alta()` provides, from the merged
// preferences, to everything that renders. Typst `state` cells, read
// inside `context { }`, because the public helpers (`tag`, `term`,
// `divider`, `rating`, `icon`) can sit anywhere in a user's document
// and can't be passed the preferences. The theme's fixed values live
// in `design/theme.typ`.

#import "design/theme.typ": _colour-roles, _default-colours

#let _body-size-state = state("alta-body-size", 10pt)
// `preferences.colours`, resolved (`_colour-roles`).
#let _colour-state = state("alta-colours", _colour-roles(_default-colours))
// Read only by the public `rating()` helper's default `max`; the
// languages section passes `prefs.maxRating` explicitly.
#let _max-rating-state = state("alta-max-rating", 5)
// The alt text of an entry's date and location icons (`labels.date`,
// `labels.location`). Not for a public helper, unlike the rest: the
// entry heading reads it, as labels would otherwise have to pass
// through every section's `_entry` call.
#let _icon-alts-state = state("alta-icon-alts", (date: none, location: none))
