// A label and a row of dots on a scale (the public `rating`), or the
// label with a text in their place (`_rating-row`).
//
// A half dot is a hard-stop gradient: Typst has no half-circle fill,
// and a gradient gives a sharper edge than a transparent overlay.

#import "../design/theme.typ": _theme
#import "../context.typ": _accent-state, _body-size-state, _max-rating-state
#import "../util/checks.typ": _require
#import "../util/values.typ": _round-half
#import "../primitives.typ": _small

#let _half-fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_theme.colour.empty-dot, 50%),
  (_theme.colour.empty-dot, 100%),
)

// A label with `trailing` pushed to the right edge, then a line
// break: the row every language renders, dots or not, so mixed rows
// align.
#let _label-row(label, trailing) = {
  text(label)
  h(1fr)
  trailing
  [\ ]
}

// `max` defaults to the enclosing `alta()`'s `preferences.maxRating`.
#let rating(label, value, max: auto) = context {
  let body-size = _body-size-state.get()
  let accent = _accent-state.get()
  let max-rating = if max == auto { _max-rating-state.get() } else { max }
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
  if _round-half(value) != value {
    panic("Rating must use 0.5 increments, got: " + repr(value))
  }
  let (radius, baseline, gap) = _theme.rating
  let dot(fill) = box(
    baseline: baseline * body-size,
    circle(radius: radius * body-size, fill: fill),
  )
  _label-row(
    label,
    range(1, max-rating + 1)
      .map(i => dot(
        if value >= i { accent } else if value > i - 1 {
          _half-fill(accent)
        } else { _theme.colour.empty-dot },
      ))
      .join(h(gap * body-size)),
  )
}

// The label's rating as dots on a scale of `max` or, with no `value`,
// the `fallback` text in their place.
#let _rating-row(label, value, max: auto, fallback: none) = if (
  value != none
) { rating(label, value, max: max) } else {
  _label-row(label, _small(fallback))
}
