// Language / skill fluency rendering — text label on the left, filled
// / half-filled / empty dots on the right.
//
// Half-fill (1.5 → 1 full + 1 half + 3 empty) uses a 50%/50% linear
// gradient — Typst has no native half-circle fill, and a gradient
// produces a sharp boundary where a transparent overlay wouldn't.

#import "state.typ": (
  _accent_state, _body_size_state, _empty_dot_colour, _max_rating_state,
)
#import "text.typ": _altacv

// Half-dot precision is the only fraction the renderer can draw.
#let _round_half(x) = calc.round(x * 2) / 2

// LinkedIn-style fluency strings, as fractions of full fluency. Keys
// are lowercase; `fluency` is matched case-insensitively.
#let _fluency_rating = (
  "native": 1.0,
  "bilingual": 1.0,
  "full professional": 0.8,
  "professional working": 0.6,
  "limited working": 0.4,
  "elementary": 0.2,
)

// A numeric `custom.altacv.rating` is used as given and wins over `fluency`, so callers can
// opt into fractional precision without rewriting their data. A
// recognised `fluency` becomes that fraction of `max` (the dot count),
// rounded to the nearest half, so it fits any scale.
// `none` = caller should render label-only (a `fluency` not in
// `_fluency_rating`). Both-absent and non-string fluency panic so a
// typo'd key or wrong-typed value surfaces immediately. Numeric
// type/bounds checks live in `rating()`.
#let _resolve_rating(entry, max) = {
  let value = _altacv(entry, "rating") // avoid shadowing `rating()`
  if value != none { return value }
  let fluency = entry.at("fluency", default: none)
  if fluency == none {
    panic(
      "Language entry needs either a numeric `custom.altacv.rating` (or the deprecated `rating`) or a `fluency` string. Got: "
        + repr(entry),
    )
  }
  if type(fluency) != str {
    panic(
      "Language `fluency` must be a string, got "
        + repr(fluency)
        + " in entry: "
        + repr(entry),
    )
  }
  let fraction = _fluency_rating.at(lower(fluency.trim()), default: none)
  if fraction != none { _round_half(fraction * max) }
}

#let _half_fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_empty_dot_colour, 50%),
  (_empty_dot_colour, 100%),
)

// `max` (the dot count) defaults to `preferences.maxRating` of the
// enclosing `alta()`.
#let rating(label, value, max: auto) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let max-rating = if max == auto { _max_rating_state.get() } else { max }
  if type(value) not in (int, float) {
    panic("Rating must be numeric, got: " + repr(value))
  }
  if value < 0 or value > max-rating {
    panic(
      "Rating out of range: "
        + repr(value)
        + ". Expected 0–"
        + str(max-rating)
        + ".",
    )
  }
  // Half-dot precision is the only fractional shape the renderer can
  // express (a single `_half_fill` gradient). Reject other fractions
  // up front so `3.1` and `3.9` don't both silently round to a
  // half-dot — callers either ask for a full step or a half step.
  if _round_half(value) != value {
    panic("Rating must use 0.5 increments, got: " + repr(value))
  }
  let dot-radius = 0.45 * body-size
  let dot-baseline = -0.25 * body-size
  let dot-spacing = 0.4 * body-size

  text(label)
  h(1fr)
  for i in range(1, max-rating + 1) {
    let fill = if value >= i {
      accent
    } else if value > i - 1 {
      _half_fill(accent)
    } else {
      _empty_dot_colour
    }
    box(baseline: dot-baseline, circle(radius: dot-radius, fill: fill))
    if i != max-rating { h(dot-spacing) }
  }
  [\ ]
}
