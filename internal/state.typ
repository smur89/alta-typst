// Private state cells. `alta()` sets them once; helpers read them
// inside `context { }`. The fixed colours live in `theme.typ`.

#import "presets.typ": palettes

#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", palettes.teal)
// Read only by the public `rating()` helper's default `max`; the
// languages section passes `prefs.maxRating` explicitly.
#let _max_rating_state = state("alta-max-rating", 5)
