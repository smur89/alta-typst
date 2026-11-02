// Languages: rating dots when `_resolve_rating` gives a number, else
// the `fluency` text alone (one not in `_fluency_rating`).

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _section
#import "../internal/ratings.typ": _resolve_rating, rating
#import "../internal/state.typ": _body_colour, _body_size_state

// Keep row shape in sync with `rating()` — mixed-mode rows must align.
#let _label_only(label, fluency) = context {
  let body-size = _body_size_state.get()
  text(label)
  h(1fr)
  if type(fluency) == str and fluency.len() > 0 {
    text(0.85 * body-size, fill: _body_colour, fluency)
  }
  [\ ]
}

#let _languages(items, (labels, prefs, ..)) = _section(
  labels.languages,
  // Nameless entries are dropped, not a panic.
  items.filter(l => _present(l.at("language", default: none))),
  lang => {
    let value = _resolve_rating(lang, prefs.maxRating)
    if value != none {
      rating(lang.language, value, max: prefs.maxRating)
    } else {
      _label_only(lang.language, lang.at("fluency", default: none))
    }
  },
)
