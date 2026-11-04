// A label and a row of dots on a scale (the public `rating`), or the
// label with a text in their place (`_rating-row`).
//
// A half dot is a hard-stop gradient: Typst has no half-circle fill,
// and a gradient gives a sharper edge than a transparent overlay.

#import "../design/styles.typ": _inline
#import "../design/theme.typ": _theme
#import "../context.typ": _accent-state, _body-size-state, _max-rating-state
#import "../util/checks.typ": _check, _check-rating, _positive-int-rule

#let _half-fill(accent) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (_theme.colour.border, 50%),
  (_theme.colour.border, 100%),
)

// A label with `trailing` pushed to the right edge, then a line
// break: the row every language renders, dots or not. A strut of
// `rating.row-height`, centred as the dots are, gives every row the
// same height, so mixed rows align.
#let _label-row(label, trailing) = {
  _inline(box(height: _theme.rating.row-height * 1em))
  [#label<alta-rating-label>]
  h(1fr)
  trailing
  [\ ]
}

// `value` as `max` dots: filled, half-filled, then empty. Each dot is
// centred on its own (`_inline`), so a long row can still break
// between dots. Unchecked: `rating` checks its arguments, and
// `_read-cv` the CV's ratings.
#let _rating-dots(value, max) = context {
  let body-size = _body-size-state.get()
  let accent = _accent-state.get()
  let (radius, gap, ..) = _theme.rating
  let dot(fill) = _inline(box(circle(radius: radius * body-size, fill: fill)))
  range(1, max + 1)
    .map(i => dot(
      if value >= i { accent } else if value > i - 1 {
        _half-fill(accent)
      } else { _theme.colour.border },
    ))
    .join(h(gap * body-size))
}

// `max` defaults to the enclosing `alta()`'s `preferences.maxRating`.
#let rating(label, value, max: auto) = context {
  let max-rating = if max == auto { _max-rating-state.get() } else { max }
  // The state is validated as `maxRating`; an explicit `max` isn't.
  _check("rating() max", max-rating, _positive-int-rule)
  _check-rating("rating value", value, max-rating)
  _label-row(label, _rating-dots(value, max-rating))
}

// The label's rating as dots on a scale of `max` or, with no `value`,
// the `fallback` text in their place.
#let _rating-row(label, value, max: auto, fallback: none) = if (
  value != none
) { rating(label, value, max: max) } else {
  _label-row(label, fallback)
}
