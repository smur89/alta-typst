// Languages: rating dots when `_resolve_rating` gives a number, else
// the `fluency` text alone (one not in `_fluency_rating`).

#import "../internal/util/fields.typ": _field, _string_at
#import "../internal/util/values.typ": _round_half
#import "../internal/data/cv.typ": _altacv
#import "../internal/components/frame.typ": _section
#import "../internal/components/ratings.typ": _rating_row, rating

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

#let _languages(items, (labels, prefs, ..)) = _section(
  labels.languages,
  // Nameless entries are dropped, not a panic.
  items.filter(l => _field(l, "language") != none),
  lang => _rating_row(
    lang.language,
    _resolve_rating(lang, prefs.maxRating),
    max: prefs.maxRating,
    fallback: _string_at(lang, "fluency"),
  ),
)
