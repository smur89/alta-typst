// Accessors that know the CV's shape: the references flag, a profile's
// network, a location, an entry's period and altacv's own
// `custom.altacv` namespace.

#import "../design/icon-set.typ": _network-aliases
#import "../util/dates.typ": _date-span
#import "../util/fields.typ": _dict-or-empty, _field
#import "../util/values.typ": _present, _round-half

// A `references[]` entry's flag: only a real boolean counts, so a
// stray `"yes"` doesn't hide a quote. Rendering reads it kebab-case
// (`_kebab-fields`), the checks under JSON Resume's name.
#let _on-request(r, key: "available-on-request") = (
  r.at(key, default: false) == true
)

// A reference worth rendering, read before the field names go
// kebab-case (`_read-sections`' `keep`, `_canonical-cv`): a quote, or
// the on-request flag.
#let _reference-usable(r) = (
  _on-request(r, key: "availableOnRequest") or _field(r, "reference") != none
)

// `(:)` when either level is missing or not a dictionary.
#let _altacv-ns(obj) = _dict-or-empty(
  _dict-or-empty(obj.at("custom", default: none)).at("altacv", default: none),
)

// One of altacv's non-spec fields (`focusAreas`, `languages[].rating`,
// `awards[].url`) from its own `custom` namespace (#242), on the CV
// root or an entry. `_canonical-cv` has already lifted the deprecated
// top-level forms there.
#let _altacv(obj, key, default: none) = _altacv-ns(obj).at(
  key,
  default: default,
)

// A `basics.profiles[]` entry's network as its icon key: lowercased,
// with renamed networks mapped to the key their icon still ships under.
#let _profile-network(profile) = {
  let raw = lower(profile.network)
  _network-aliases.at(raw, default: raw)
}

// A profile network's FontAwesome glyph from the merged, lowercase-keyed
// `preferences.profile-icons`, or `none` for a network it doesn't map.
// The network as written is looked up before its alias's key, so `x`
// can be mapped apart from `twitter`, and a `twitter` mapping covers
// both.
#let _profile-glyph(profile, profile-icons) = {
  let raw = lower(profile.network)
  profile-icons.at(
    raw,
    default: profile-icons.at(_profile-network(profile), default: none),
  )
}

// JSON Resume's `location` (a string or the shared dict), collapsed
// one way for every caller so a location reads the same everywhere.
// `address` / `postalCode` are accepted but not rendered — a CV isn't
// a mailing label. The fields are JSON Resume's names, for the checks;
// the display order is rendering's (`_kebab-fields`). Absent values
// become `none`, so callers' `!= none` checks leave no orphan row or
// blank-query maps URL.
#let _location-fields = (
  "address",
  "postalCode",
  "city",
  "countryCode",
  "region",
)
#let _location-display-order = ("city", "region", "country-code")
// `obj`'s `location` (an entry's or `basics`') as its present parts,
// for `_fact-line` to join with the theme's separator; `()` when
// there are none. It has passed `_check-location` (`cv-checks.typ`).
#let _location-parts(obj) = {
  let value = obj.at("location", default: none)
  if not _present(value) { return () }
  if type(value) == str { return (value,) }
  _location-display-order.map(k => _field(value, k)).filter(_present)
}

// A `start-date` / `end-date` entry's period as `_date-span` sides, a
// missing end reading `present` (`labels.present`); a fully undated
// entry has neither side, not a bare "Present".
#let _entry-period(entry, format-date, present) = {
  let start = _field(entry, "start-date")
  let end = _field(entry, "end-date")
  if start == none and end == none { return (none, none) }
  _date-span(start, end, format-date, open-end: present)
}

// Rating terms as fractions of the full scale, matched
// case-insensitively: LinkedIn's `languages[].fluency` and the common
// `skills[].level` words.
#let _fluency-terms = (
  "Native": 1.0,
  "Bilingual": 1.0,
  "Full Professional": 0.8,
  "Professional Working": 0.6,
  "Limited Working": 0.4,
  "Elementary": 0.2,
)
#let _skill-levels = (
  "Beginner": 0.2,
  "Novice": 0.2,
  "Intermediate": 0.6,
  "Advanced": 0.8,
  "Expert": 1.0,
  "Master": 1.0,
)

// An entry's rating on a scale of `max`: its `custom.altacv.rating`,
// else its `field` (one of `terms`) scaled and rounded to the half,
// else `none`.
#let _term-rating(entry, field, terms, max) = {
  let value = _altacv(entry, "rating")
  if value != none { return value }
  let term = _field(entry, field)
  if type(term) != str { return none }
  let key = lower(term.trim())
  let match = terms.pairs().find(((t, _)) => lower(t) == key)
  if match != none { _round-half(match.last() * max) }
}
