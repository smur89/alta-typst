// A label and a row of dots on a scale (the public `rating`), or the
// label with a text in their place (`_rating-row`).
//
// A half dot is a hard-stop gradient: Typst has no half-circle fill,
// and a gradient gives a sharper edge than a transparent overlay.

#import "../design/styles.typ": _inline, _part
#import "../context.typ": _max-rating-state, _theme-state
#import "../util/checks.typ": _check, _check-rating, _positive-int-rule

#let _half-fill(accent, border) = gradient.linear(
  (accent, 0%),
  (accent, 50%),
  (border, 50%),
  (border, 100%),
)

// A label with `trailing` pushed to the right edge, then a line
// break: the row every language renders, dots or not. A strut of
// `rating.row-height`, centred as the dots are, gives every row the
// same height, so mixed rows align. `theme` is the one the caller
// read in context.
#let _label-row(theme, label, trailing) = {
  _inline(box(height: theme.rating.row-height * 1em))
  _part("rating-label", label)
  h(1fr)
  trailing
  [\ ]
}

// `value` as `max` dots: filled, half-filled, then empty. Each dot is
// centred on its own (`_inline`), so a long row can still break
// between dots. Each is a `_part` by its state (see `_glyph`).
// Unchecked: `rating` checks its arguments, and `_read-cv` the CV's
// ratings.
#let _rating-dots(value, max) = context {
  let body-size = text.size
  let theme = _theme-state.get()
  let (accent, border, ..) = theme.colours
  let (radius, gap, ..) = theme.rating
  let fills = (
    full: accent,
    half: _half-fill(accent, border),
    empty: border,
  )
  // A show rule may replace a dot with a glyph, which takes the text
  // fill: the dot's colour, the accent for a half (the glyph draws its
  // own half).
  let dot(state) = _inline(box({
    set circle(fill: fills.at(state))
    set text(fill: if state == "empty" { border } else { accent })
    _part("rating-" + state, circle(radius: radius * body-size))
  }))
  range(1, max + 1)
    .map(i => dot(
      if value >= i { "full" } else if value > i - 1 { "half" } else {
        "empty"
      },
    ))
    .join(h(gap * body-size))
}

/// A label with a row of rating dots at the right edge: filled,
/// half-filled, then empty.
///
/// - label (content, str): The row's label.
/// - value (int, float): The rating, from 0 to `max`, in steps of 0.5.
/// - max (auto, int): The dots in the row; `auto` is the enclosing
///   `alta()`'s `preferences.maxRating`.
/// -> content
#let rating(label, value, max: auto) = context {
  let max-rating = if max == auto { _max-rating-state.get() } else { max }
  // The state is validated as `maxRating`; an explicit `max` isn't.
  _check("rating() max", max-rating, _positive-int-rule)
  _check-rating("rating value", value, max-rating)
  _label-row(_theme-state.get(), label, _rating-dots(value, max-rating))
}

// The label's rating as dots on a scale of `max` or, with no `value`,
// the `fallback` text in their place.
#let _rating-row(label, value, max: auto, fallback: none) = if (
  value != none
) { rating(label, value, max: max) } else {
  context _label-row(_theme-state.get(), label, fallback)
}
