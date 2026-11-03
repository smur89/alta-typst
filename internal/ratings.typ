// Language fluency as a label and a row of dots (the public `rating`).
// A half dot is a hard-stop gradient: Typst has no half-circle fill,
// and a gradient gives a sharper edge than a transparent overlay.

#import "state.typ": _accent_state, _body_size_state, _max_rating_state
#import "theme.typ": _theme
#import "text.typ": _altacv, _string_at
#import "validation.typ": _require
#import "primitives.typ": _small

#let _round_half(x) = calc.round(x * 2) / 2

// LinkedIn fluency strings as fractions of full fluency; matched
// case-insensitively.
#let _fluency_rating = (
  "native": 1.0,
  "bilingual": 1.0,
  "full professional": 0.8,
  "professional working": 0.6,
  "limited working": 0.4,
  "elementary": 0.2,
)

// A `custom.altacv.rating` wins over `fluency`; a known `fluency`
// scales to `max` dots, rounded to the half. `none` (an unknown
// `fluency`) means render the label only. Numeric checks live in
// `rating()`.
#let _resolve_rating(entry, max) = {
  let value = _altacv(entry, "rating") // avoid shadowing `rating()`
  if value != none { return value }
  let fluency = entry.at("fluency", default: none)
  if fluency == none {
    panic(
      "Language entry needs either a numeric `custom.altacv.rating` or a `fluency` string. Got: "
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
  (_theme.colour.empty-dot, 50%),
  (_theme.colour.empty-dot, 100%),
)

// A label with `trailing` pushed to the right edge, then a line
// break: the row every language renders, dots or not, so mixed rows
// align.
#let _label_row(label, trailing) = {
  text(label)
  h(1fr)
  trailing
  [\ ]
}

// `max` defaults to the enclosing `alta()`'s `preferences.maxRating`.
#let rating(label, value, max: auto) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let max-rating = if max == auto { _max_rating_state.get() } else { max }
  // The state is validated as `maxRating`; an explicit `max` isn't.
  _require(
    "rating() max",
    max-rating,
    type(max-rating) == int and max-rating >= 1,
    "a positive integer",
  )
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
  // Half dots are the only fraction drawable; rejecting others stops
  // `3.1` and `3.9` silently rounding alike.
  if _round_half(value) != value {
    panic("Rating must use 0.5 increments, got: " + repr(value))
  }
  let (radius, baseline, gap) = _theme.rating
  let dot(fill) = box(
    baseline: baseline * body-size,
    circle(radius: radius * body-size, fill: fill),
  )
  _label_row(
    label,
    range(1, max-rating + 1)
      .map(i => dot(
        if value >= i { accent } else if value > i - 1 {
          _half_fill(accent)
        } else { _theme.colour.empty-dot },
      ))
      .join(h(gap * body-size)),
  )
}

// A `languages[]` entry's row: its rating as dots on a scale of
// `max` or, when `fluency` isn't one `_fluency_rating` knows, that
// text in their place.
#let _language_row(lang, max) = {
  let value = _resolve_rating(lang, max)
  if value != none { rating(lang.language, value, max: max) } else {
    _label_row(lang.language, _small(_string_at(lang, "fluency")))
  }
}
