// Languages: rating dots when `_resolve-rating` gives a number, else
// the `fluency` text alone (one not in `_fluency-rating`).

#import "../internal/util/fields.typ": _string-at
#import "../internal/util/values.typ": _round-half
#import "../internal/data/cv.typ": _altacv
#import "../internal/components/frame.typ": _section
#import "../internal/components/ratings.typ": _rating-row

// LinkedIn fluency strings as fractions of full fluency; matched
// case-insensitively.
#let _fluency-rating = (
  "native": 1.0,
  "bilingual": 1.0,
  "full professional": 0.8,
  "professional working": 0.6,
  "limited working": 0.4,
  "elementary": 0.2,
)

// A `custom.altacv.rating` wins over `fluency`; a known `fluency`
// scales to `max` dots, rounded to the half. `none` (an unknown
// `fluency`) means render the label only. `_read-cv` has checked that
// one of them is set.
#let _resolve-rating(entry, max) = {
  let value = _altacv(entry, "rating")
  if value != none { return value }
  let fraction = _fluency-rating.at(lower(entry.fluency.trim()), default: none)
  if fraction != none { _round-half(fraction * max) }
}

#let _languages(items, (labels, prefs, ..)) = _section(
  labels.languages,
  items,
  lang => _rating-row(
    lang.language,
    _resolve-rating(lang, prefs.maxRating),
    max: prefs.maxRating,
    fallback: _string-at(lang, "fluency"),
  ),
  separator: "space",
)
