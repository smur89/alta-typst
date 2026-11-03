// Languages: rating dots when `_resolve_rating` gives a number, else
// the `fluency` text alone (one not in `_fluency_rating`).

#import "../internal/util/fields.typ": _field
#import "../internal/components/frame.typ": _section
#import "../internal/components/ratings.typ": _language_row

#let _languages(items, (labels, prefs, ..)) = _section(
  labels.languages,
  // Nameless entries are dropped, not a panic.
  items.filter(l => _field(l, "language") != none),
  lang => _language_row(lang, prefs.maxRating),
)
