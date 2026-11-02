// Language / skill fluency rendering — text label on the left, filled
// / half-filled / empty dots on the right.
//
// Half-fill (1.5 → 1 full + 1 half + 3 empty) uses a 50%/50% linear
// gradient — Typst has no native half-circle fill, and a gradient
// produces a sharp boundary where a transparent overlay wouldn't.

#import "state.typ": (
  _accent_state, _body_size_state, _empty_dot_colour, _max_rating_state,
)

// `fluency` → dots, keyed lowercase without a trailing "proficiency"
// (LinkedIn's labels carry one: "Professional working proficiency"),
// as fractions of a 0–5 scale that `_resolve_rating` scales to
// `preferences.maxRating`. CEFR's six levels are spread over five
// dots, rounded to halves.
#let _fluency_rating = (
  // LinkedIn
  "native": 5,
  "bilingual": 5,
  "native or bilingual": 5,
  "full professional": 4,
  "professional working": 3,
  "limited working": 2,
  "elementary": 1,
  // Common words, including JSON Resume's examples ("Fluent", "Beginner")
  "mother tongue": 5,
  "fluent": 4.5,
  "advanced": 4,
  "proficient": 4,
  "upper intermediate": 3.5,
  "intermediate": 3,
  "conversational": 2,
  "basic": 1,
  "beginner": 1,
  // CEFR
  "c2": 5,
  "c1": 4,
  "b2": 3.5,
  "b1": 2.5,
  "a2": 1.5,
  "a1": 1,
)

// A numeric `rating` is used as given and wins over `fluency`. A
// recognised `fluency` is scaled from 0–5 to `max` (the dot count) and
// rounded to the nearest half, so it fits any scale. `none` = caller
// should render label-only (free-text `fluency` outside
// `_fluency_rating`). Both-absent and non-string fluency panic so a
// typo'd key or wrong-typed value surfaces immediately. Numeric
// type/bounds checks live in `rating()`.
#let _resolve_rating(entry, max) = {
  let value = entry.at("rating", default: none) // avoid shadowing `rating()`
  if value != none { return value }
  let fluency = entry.at("fluency", default: none)
  if fluency == none {
    panic(
      "Language entry needs either a numeric `rating` or a `fluency` string. Got: "
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
  let key = lower(fluency.trim()).trim(" proficiency", at: end).trim()
  let value = _fluency_rating.at(key, default: none)
  if value != none { calc.round(value / 5 * max * 2) / 2 }
}

#let _half_fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_empty_dot_colour, 50%),
  (_empty_dot_colour, 100%),
)

#let rating(label, value) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let max-rating = _max_rating_state.get()
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
  if calc.round(value * 2) / 2 != value {
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
