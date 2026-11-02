// Languages: rating dots when `_resolve_rating` gives a number, else
// the `fluency` text alone (one not in `_fluency_rating`).

#import "../internal/text.typ": _present, _present_str
#import "../internal/primitives.typ": _section, _small
#import "../internal/ratings.typ": _label_row, _resolve_rating, rating

#let _languages(items, (labels, prefs, ..)) = _section(
  labels.languages,
  // Nameless entries are dropped, not a panic.
  items.filter(l => _present(l.at("language", default: none))),
  lang => {
    let value = _resolve_rating(lang, prefs.maxRating)
    if value != none {
      rating(lang.language, value, max: prefs.maxRating)
    } else {
      let fluency = lang.at("fluency", default: none)
      _label_row(lang.language, if _present_str(fluency) { _small(fluency) })
    }
  },
)
