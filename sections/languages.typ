// Languages — one row per entry, label on the left and rating dots on
// the right (or a fluency string mapped to numeric via the LinkedIn
// scale in `_resolve_rating`). When `_resolve_rating` returns `none`
// (`fluency` is a free-text string outside the LinkedIn enum — the
// canonical JSON Resume shape), the row drops the dots and renders
// the fluency string as a small annotation in their place. Entries
// with neither `rating` nor `fluency` panic in `_resolve_rating`, so
// typos in those keys surface as actionable errors.

#import "../internal/primitives.typ": _join_with_dividers
#import "../internal/ratings.typ": rating, _resolve_rating
#import "../internal/state.typ": _body_size_state, _body_colour

// Row shape mirrors `rating()` in `internal/ratings.typ` — label on
// the left, `h(1fr)`, trailing `[\ ]` — so the two rendering paths
// produce vertically-aligned rows when mixed in the same languages
// block. Keep them in sync if either layout changes.
#let _label_only(label, fluency) = context {
  let body-size = _body_size_state.get()
  text(label)
  h(1fr)
  if type(fluency) == str and fluency.len() > 0 {
    text(0.85 * body-size, fill: _body_colour, fluency)
  }
  [\ ]
}

#let _languages(items, labels) = if items.len() > 0 [
  == #labels.languages

  #_join_with_dividers(items, lang => block(
    breakable: false,
    {
      let value = _resolve_rating(lang)
      if value != none {
        rating(lang.language, value)
      } else {
        _label_only(lang.language, lang.at("fluency", default: none))
      }
    },
  ))
]
